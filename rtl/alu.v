`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:59:37 PM
// Design Name: 
// Module Name: alu
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


module alu #(
    parameter OPCODE_WIDTH = 3,
    parameter OPERAND_WIDTH = 8
    )(
    input        [OPCODE_WIDTH - 1 : 0]  opcode,
    input        [OPERAND_WIDTH - 1 : 0] inA,      // Từ Accumulator
    input        [OPERAND_WIDTH - 1 : 0] inB,      // Từ Memory
    output reg   [OPERAND_WIDTH - 1 : 0] out,
    output                               is_zero
);
    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    always @(*) begin
        case (opcode)
            HLT: out = inA;
            SKZ: out = inA;
            ADD: out = inA + inB;
            AND: out = inA & inB;
            XOR: out = inA ^ inB;
            LDA: out = inB;
            STO: out = inA;
            JMP: out = inA;
            default: out = inA;
        endcase
    end
    assign is_zero = ~|inA;
endmodule
