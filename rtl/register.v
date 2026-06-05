`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:59:37 PM
// Design Name: 
// Module Name: register
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


module register#(
    parameter DATA_WIDTH = 8 
)(
    input                               clk,
    input                               rst,
    input                               ld,
    input       [DATA_WIDTH - 1 : 0]    data_in,
    output reg  [DATA_WIDTH - 1 : 0]    data_out
);
    always @(posedge clk) begin
        if (rst)
            data_out <= 8'b0;
        else if (ld)
            data_out <= data_in;
    end
endmodule
