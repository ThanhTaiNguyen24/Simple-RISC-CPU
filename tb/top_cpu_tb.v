`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 04:38:23 PM
// Design Name: 
// Module Name: top_cpu_tb
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


module top_cpu_tb;
    reg clk;
    reg rst;

    top_cpu uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Test stimulus
    initial begin
        // Program stored in memory (5-bit address, 8-bit data)
        // Format: [2:0] = opcode, [4:0] = address operand
        //----------------------------------------------------
        // ALU OP, STORE then HALT
        //----------------------------------------------------
        // Example program:
        // 0: LDA 5   (101_00101) Load value from address 5 to Accumulator
        // 1: ADD 6   (010_00110) Add value from address 6 to Accumulator
        // 2: STO 7   (110_00111) Store Accumulator to address 7
        // 3: HLT     (000_00000) Halt
        // 5: Data = 8'h0A (10)
        // 6: Data = 8'h05 (5)
        // 7: Data = 8'h00 (initially 0, will be updated by STO)
        
        uut.mem.mem[0] = 8'b10100101; // LDA 5
        uut.mem.mem[1] = 8'b01000110; // ADD 6
        uut.mem.mem[2] = 8'b11000111; // STO 7
        uut.mem.mem[3] = 8'b00000000; // HLT
        uut.mem.mem[5] = 8'h0A;        // Data: 10
        uut.mem.mem[6] = 8'h05;        // Data: 5
        uut.mem.mem[7] = 8'h00;        // Data: 0 (will be updated)
        rst = 1;
        #10;
        rst = 0;
        #320;
        //----------------------------------------------------
        // RESET AFTER HALT
        //----------------------------------------------------
        rst = 1;
        #20;
        rst = 0;
        // Program
        // 0 : LDA 5
        // 1 : SKZ
        // 2 : LDA 6  (should be skipped)
        // 3 : STO 7
        // 4 : HALT
        
        uut.mem.mem[0] = 8'b10100101; // LDA 5
        uut.mem.mem[1] = 8'b00100000; // SKZ
        uut.mem.mem[2] = 8'b10100110; // LDA 6
        uut.mem.mem[3] = 8'b11000111; // STO 7
        uut.mem.mem[4] = 8'b00000000; // HALT
        
        uut.mem.mem[5] = 8'h00;       // ACC becomes zero
        uut.mem.mem[6] = 8'hAA;       // should never be loaded
        uut.mem.mem[7] = 8'h00;
        #10;
        //----------------------------------------------------
        // SKZ TEST
        //----------------------------------------------------
        $display("\n========== SKZ TEST ==========");
        

      
        #350;
        
        $display("SKZ RESULT");
        $display("mem[7] = %h", uut.mem.mem[7]);
        
        

        rst = 1;
        #20;
        rst = 0;
                
        // Program
        // 0 : JMP 3
        // 1 : LDA 5 (skip)
        // 2 : STO 7 (skip)
        // 3 : LDA 6
        // 4 : STO 7
        // 5 : HALT
        
        uut.mem.mem[0] = 8'b11100011; // JMP 3
        uut.mem.mem[1] = 8'b10100101; // LDA 5
        uut.mem.mem[2] = 8'b11000111; // STO 7
        uut.mem.mem[3] = 8'b10100110; // LDA 6
        uut.mem.mem[4] = 8'b11000111; // STO 7
        uut.mem.mem[5] = 8'b00000000; // HALT
        
        uut.mem.mem[6] = 8'h55;
        uut.mem.mem[7] = 8'h00;
        #10;
        
        
        //----------------------------------------------------
        // JMP TEST
        //----------------------------------------------------
        $display("\n========== JMP TEST ==========");

        
        #350;
        
        $display("JMP RESULT");
        $display("mem[7] = %h", uut.mem.mem[7]);

        $finish;
    end

    // Initialize memory with a test program
    initial begin

    end

    // Monitor key signals
    initial begin
        $monitor("Time=%0t | PC=%h | Opcode=%b | IR_addr=%h | Mem_addr=%h | Data_bus=%h | Acc=%h | ALU_out=%h | Sel=%b | Rd=%b | Ld_ir=%b | Halt=%b | Inc_pc=%b | Ld_ac=%b | Wr=%b | Ld_pc=%b | Data_e=%b",
                 $time, 
                 uut.pc_addr, 
                 uut.ir_addr[7:5],  // Tách 3 bit cao làm Opcode (hiển thị dạng Nhị phân %b)
                 uut.ir_addr[4:0],  // Tách 5 bit thấp làm Địa chỉ toán hạng (hiển thị dạng Hex %h)
                 uut.mem_addr,
                 uut.data_bus, 
                 uut.acc_out, 
                 uut.alu_out, 
                 uut.sel, 
                 uut.rd, 
                 uut.ld_ir, 
                 uut.halt, 
                 uut.inc_pc, 
                 uut.ld_ac, 
                 uut.wr, 
                 uut.ld_pc,
                 uut.data_e);
    end
    
    initial begin
        $monitor("Time=%0t | mem[7]=%h", $time, uut.mem.mem[7]);
    end

endmodule
