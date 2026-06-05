`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:59:37 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter #(
    parameter ADDR_WIDTH = 5 
)(
    input wire                          clk,       // Clock signal
    input wire                          rst,       // Reset signal (active high)
    input wire                          ld_pc,     // Load signal
    input wire                          inc_pc,    // Increment signal
    input wire                          halt,          
    input wire  [ADDR_WIDTH - 1 : 0]    load_addr, // Address to be loaded (5-bit)
    output reg  [ADDR_WIDTH - 1 : 0]    pc_addr    // Current counter value (5-bit)
);

    reg [ADDR_WIDTH-1:0] n_pc_addr;
    // Counter Register
    always @(posedge clk) begin
        if (rst) begin
            pc_addr <= 5'b00000;
        end else begin 
            pc_addr <= n_pc_addr;
        end
    end
    
    //Next Counter Logic
    always @(*) begin
        n_pc_addr = pc_addr;
        if (!halt) begin
            if (ld_pc) begin
                // Load external value when load signal is active
                n_pc_addr = load_addr;
            end else if (inc_pc) begin
                // Increment counter during inc_pc operation
                n_pc_addr = pc_addr + 1'b1;
            end
        end
    end
endmodule
