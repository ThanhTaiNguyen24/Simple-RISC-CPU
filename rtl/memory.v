`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:59:37 PM
// Design Name: 
// Module Name: memory
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


module memory #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 8,
    parameter MEM_DEPTH = 32
    )(
    input                       clk,  
    input [ADDR_WIDTH - 1 : 0]  addr,  // 5-bit address
    input                       rd,    // Read enable
    input                       wr,    // Write enable
    inout [DATA_WIDTH - 1 : 0]  data   // 8-bit bidirectional data port
);
    // Array to store data
    reg [DATA_WIDTH - 1 : 0] mem [0 : MEM_DEPTH - 1];    // 32 locations of 8-bit each
    
    // Reading
    wire [7:0] mem_read_data;

    assign mem_read_data = mem[addr];

    tristate_driver mem_driver (
        .enable(rd && !wr),
        .data_in(mem_read_data),
        .data_bus(data)
    );
    
    // Writing
    always @(posedge clk) begin
        if (wr && !rd)
            mem[addr] <= data;
    end
endmodule
