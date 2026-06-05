`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 04:56:02 PM
// Design Name: 
// Module Name: controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller_tb;

    reg clk;
    reg reset;
    reg [2:0] opcode;
    reg is_zero;

    wire sel;
    wire rd;
    wire ld_ir;
    wire halt;
    wire inc_pc;
    wire ld_ac;
    wire wr;
    wire ld_pc;
    wire data_e;

    integer errors;
    integer tests;

    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND_OP = 3'b011;
    localparam XOR_OP = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    localparam INST_ADDR  = 4'd0;
    localparam INST_FETCH = 4'd1;
    localparam INST_LOAD  = 4'd2;
    localparam IDLE       = 4'd3;
    localparam OP_ADDR    = 4'd4;
    localparam OP_FETCH   = 4'd5;
    localparam ALU_OP     = 4'd6;
    localparam STORE      = 4'd7;
    localparam HALT_STATE = 4'd8;

    wire [3:0] current_state;

    assign current_state = uut.cs;
    controller uut (
        .clk(clk),
        .rst(reset),
        .opcode(opcode),
        .is_zero(is_zero),
        .sel(sel),
        .rd(rd),
        .ld_ir(ld_ir),
        .halt(halt),
        .inc_pc(inc_pc),
        .ld_ac(ld_ac),
        .wr(wr),
        .ld_pc(ld_pc),
        .data_e(data_e)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task synchronous_reset;
        begin
            reset = 1'b1;
            @(posedge clk);
            #1;
            reset = 1'b0;
            if (uut.cs !== INST_ADDR) begin
                $display("ERROR: Reset failed. Expected state INST_ADDR, got %0d at time %0t", uut.cs, $time);
                errors = errors + 1;
            end
        end
    endtask

    task check_outputs;
        input [4*8-1:0] state_name;
        input [3:0] exp_state;
        input exp_sel;
        input exp_rd;
        input exp_ld_ir;
        input exp_halt;
        input exp_inc_pc;
        input exp_ld_ac;
        input exp_wr;
        input exp_ld_pc;
        input exp_data_e;
        begin
            tests = tests + 1;
            #1;
            if (uut.cs !== exp_state ||
                sel !== exp_sel || rd !== exp_rd || ld_ir !== exp_ld_ir ||
                halt !== exp_halt || inc_pc !== exp_inc_pc || ld_ac !== exp_ld_ac ||
                wr !== exp_wr || ld_pc !== exp_ld_pc || data_e !== exp_data_e) begin

                $display("ERROR at time %0t, state %s", $time, state_name);
                $display("  Expected: cs=%0d sel=%b rd=%b ld_ir=%b halt=%b inc_pc=%b ld_ac=%b wr=%b ld_pc=%b data_e=%b",
                         exp_state, exp_sel, exp_rd, exp_ld_ir, exp_halt, exp_inc_pc, exp_ld_ac, exp_wr, exp_ld_pc, exp_data_e);
                $display("  Got     : cs=%0d sel=%b rd=%b ld_ir=%b halt=%b inc_pc=%b ld_ac=%b wr=%b ld_pc=%b data_e=%b",
                         uut.cs, sel, rd, ld_ir, halt, inc_pc, ld_ac, wr, ld_pc, data_e);
                errors = errors + 1;
            end
        end
    endtask

    task step_clock;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task check_common_instruction_fetch;
        begin
            check_outputs("IADR", INST_ADDR,  1,0,0,0,0,0,0,0,0);
            step_clock;
            check_outputs("IFET", INST_FETCH, 1,1,0,0,0,0,0,0,0);
            step_clock;
            check_outputs("ILOD", INST_LOAD,  1,1,1,0,0,0,0,0,0);
            step_clock;
            check_outputs("IDLE", IDLE,       1,1,1,0,0,0,0,0,0);
            step_clock;
        end
    endtask

    task test_aluop_opcode;
        input [2:0] op;
        input [8*8-1:0] op_name;
        begin
            $display("Testing %s", op_name);
            opcode = op;
            is_zero = 1'b0;
            synchronous_reset;
            check_common_instruction_fetch;

            check_outputs("OADR", OP_ADDR,  0,0,0,0,1,0,0,0,0);
            step_clock;
            check_outputs("OFET", OP_FETCH, 0,1,0,0,0,0,0,0,0);
            step_clock;
            check_outputs("ALUO", ALU_OP,   0,1,0,0,0,0,0,0,0);
            step_clock;
            check_outputs("STOR", STORE,    0,1,0,0,0,1,0,0,0);
            step_clock;
        end
    endtask

    task test_hlt;
        begin
            $display("Testing HLT");
            opcode = HLT;
            is_zero = 1'b0;
            synchronous_reset;
            check_common_instruction_fetch;

            check_outputs("OADR", OP_ADDR, 0,0,0,1,1,0,0,0,0);
            step_clock;
            check_outputs("HALT", HALT_STATE, 0,0,0,1,0,0,0,0,0);
            step_clock;
            check_outputs("HALT", HALT_STATE, 0,0,0,1,0,0,0,0,0);
            step_clock;
            check_outputs("HALT", HALT_STATE, 0,0,0,1,0,0,0,0,0);
        end
    endtask

    task test_skz;
        input zero_value;
        begin
            $display("Testing SKZ with is_zero=%0b", zero_value);
            opcode = SKZ;
            is_zero = zero_value;
            synchronous_reset;
            check_common_instruction_fetch;

            check_outputs("OADR", OP_ADDR,  0,0,0,0,1,0,0,0,0);
            step_clock;
            check_outputs("OFET", OP_FETCH, 0,0,0,0,0,0,0,0,0);
            step_clock;
            check_outputs("ALUO", ALU_OP,   0,0,0,0,zero_value,0,0,0,0);
            step_clock;
            check_outputs("STOR", STORE,    0,0,0,0,0,0,0,0,0);
            step_clock;
        end
    endtask

    task test_sto;
        begin
            $display("Testing STO");
            opcode = STO;
            is_zero = 1'b0;
            synchronous_reset;
            check_common_instruction_fetch;

            check_outputs("OADR", OP_ADDR,  0,0,0,0,1,0,0,0,0);
            step_clock;
            check_outputs("OFET", OP_FETCH, 0,0,0,0,0,0,0,0,0);
            step_clock;
            check_outputs("ALUO", ALU_OP,   0,0,0,0,0,0,0,0,1);
            step_clock;
            check_outputs("STOR", STORE,    0,0,0,0,0,0,1,0,1);
            step_clock;
        end
    endtask

    task test_jmp;
        begin
            $display("Testing JMP");
            opcode = JMP;
            is_zero = 1'b0;
            synchronous_reset;
            check_common_instruction_fetch;

            check_outputs("OADR", OP_ADDR,  0,0,0,0,1,0,0,0,0);
            step_clock;
            check_outputs("OFET", OP_FETCH, 0,0,0,0,0,0,0,0,0);
            step_clock;
            check_outputs("ALUO", ALU_OP,   0,0,0,0,0,0,0,1,0);
            step_clock;
            check_outputs("STOR", STORE,    0,0,0,0,0,0,0,1,0);
            step_clock;
        end
    endtask

    initial begin
        errors = 0;
        tests = 0;
        reset = 1'b0;
        opcode = HLT;
        is_zero = 1'b0;

        test_hlt;
        test_skz(1'b1);
        test_skz(1'b0);
        test_aluop_opcode(ADD, "ADD");
        test_aluop_opcode(AND_OP, "AND");
        test_aluop_opcode(XOR_OP, "XOR");
        test_aluop_opcode(LDA, "LDA");
        test_sto;
        test_jmp;

        $display("Controller testbench finished: %0d checks, %0d errors", tests, errors);
        if (errors == 0)
            $display("PASS: all controller test cases passed");
        else
            $display("FAIL: controller has %0d error(s)", errors);

        #10;
        $finish;
    end

endmodule
