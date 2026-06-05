`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 04:54:25 PM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb;
    reg [2:0] opcode;
    reg [7:0] inA;
    reg [7:0] inB;
    wire [7:0] out;
    wire is_zero;

    alu uut (
        .opcode(opcode),
        .inA(inA),
        .inB(inB),
        .out(out),
        .is_zero(is_zero)
    );

    // Test stimulus
    initial begin
        opcode = 3'b000;
        inA = 8'b00000000;
        inB = 8'b00000000;

        // Test case 1: HLT operation
        #10;
        opcode = 3'b000; // HLT
        inA = 8'b10101010;
        inB = 8'b01010101;
        #10;

        // Test case 2: SKZ operation
        #10;
        opcode = 3'b001; // SKZ
        inA = 8'b00000000; // Test is_zero
        inB = 8'b11111111;
        #10;
        inA = 8'h01;
        inB = 8'h00;
        #10;

        // Test case 3: ADD operation
        #10;
        opcode = 3'b010; // ADD
        inA = 8'b00001111;
        inB = 8'b00000001;
        #10;

        // Test case 4: AND operation
        #10;
        opcode = 3'b011; // AND
        inA = 8'b10101010;
        inB = 8'b11001100;
        #10;

        // Test case 5: XOR operation
        #10;
        opcode = 3'b100; // XOR
        inA = 8'b10101010;
        inB = 8'b11001100;
        #10;

        // Test case 6: LDA operation
        #10;
        opcode = 3'b101; // LDA
        inA = 8'b11110000;
        inB = 8'b00001111;
        #10;

        // Test case 7: STO operation
        #10;
        opcode = 3'b110; // STO
        inA = 8'b01010101;
        inB = 8'b10101010;
        #10;

        // Test case 8: JMP operation
        #10;
        opcode = 3'b111; // JMP
        inA = 8'b11111111;
        inB = 8'b00000000;
        #10;
        // Test case 9: ADD overflow
        opcode = 3'b010;
        inA = 8'hFF;
        inB = 8'h01;
        // End simulation
        #10;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t opcode=%b inA=%b inB=%b out=%b is_zero=%b", 
                 $time, opcode, inA, inB, out, is_zero);
    end

endmodule
