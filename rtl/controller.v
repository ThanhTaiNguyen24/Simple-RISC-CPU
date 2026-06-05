`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:59:37 PM
// Design Name: 
// Module Name: controller
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


module controller #(
    parameter OPCODE_WIDTH = 3
    )(
    input                       clk, rst,
    input [OPCODE_WIDTH - 1:0]  opcode,
    input                       is_zero, 
    output reg                  sel, rd, ld_ir, halt, inc_pc, ld_ac, wr, ld_pc, data_e
);
    localparam  INST_ADDR  = 4'd0;
    localparam  INST_FETCH = 4'd1;
    localparam  INST_LOAD  = 4'd2;
    localparam  IDLE       = 4'd3;
    localparam  OP_ADDR    = 4'd4;
    localparam  OP_FETCH   = 4'd5;
    localparam  ALU_OP     = 4'd6;
    localparam  STORE      = 4'd7;
    localparam  HALT       = 4'd8;
    
    reg [3:0] cs, ns;
    
    always @(posedge clk) begin
        if (rst) cs <= INST_ADDR;
        else cs <= ns;
    end
    
    always @(*) begin
        case (cs)
            INST_ADDR:  ns = INST_FETCH;
            INST_FETCH: ns = INST_LOAD;
            INST_LOAD:  ns = IDLE;
            IDLE:       ns = OP_ADDR;
            OP_ADDR:    ns = (opcode == 3'b000) ? HALT : OP_FETCH; 
            OP_FETCH:   ns = ALU_OP;
            ALU_OP:     ns = STORE;
            STORE:      ns = INST_ADDR;
            HALT:       ns = HALT; 
            default: ns = INST_ADDR;
        endcase
    end
    
    always @(*) begin
        sel = 0; rd = 0; ld_ir = 0; halt = 0; inc_pc = 0;
        ld_ac = 0; ld_pc = 0; data_e = 0; wr = 0;
        
        case (cs)
            INST_ADDR: begin
                sel = 1;
            end
            INST_FETCH: begin
                sel = 1;
                rd = 1;
            end
            INST_LOAD: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
            end
            IDLE: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
            end
            OP_ADDR: begin
                inc_pc = 1;
                if (opcode == 3'b000) halt = 1; 
            end
            OP_FETCH: begin
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) rd = 1;
            end
            ALU_OP: begin
                sel = 0;
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101)
                    rd = 1; // ALUOP
                if (opcode == 3'b001 && is_zero)
                    inc_pc = 1; // SKZ & zero
                if (opcode == 3'b111)
                    ld_pc = 1; // JMP
                if (opcode == 3'b110)
                    data_e = 1; // STO
            end
            STORE: begin
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) begin
                    rd = 1;    // ALUOP
                    ld_ac = 1; 
                end
                if (opcode == 3'b111)
                    ld_pc = 1; // JMP
                if (opcode == 3'b110) begin
                    wr = 1;
                    data_e = 1; // STO
                end
            end
            HALT: begin
                halt = 1; 
            end
        endcase
    end
endmodule