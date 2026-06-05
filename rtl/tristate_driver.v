`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 08:59:22 AM
// Design Name: 
// Module Name: tristate_driver
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


module tristate_driver #(
    parameter WIDTH = 8
)(
    input               enable,
    input   [WIDTH-1:0] data_in,
    output  [WIDTH-1:0] data_bus
);
    // 'z' represents high impedance (tri-state)
    // diff read/write --> do not conflict when drives tri-state
    assign data_bus = enable ? data_in : {WIDTH{1'bz}};

endmodule
