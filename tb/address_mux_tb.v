`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 04:56:02 PM
// Design Name: 
// Module Name: address_mux_tb
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


module address_mux_tb;

    reg  [4:0] pc_addr;
    reg  [4:0] ir_addr;
    reg        sel;
    wire [4:0] mem_addr;

    address_mux uut (
        .pc_addr(pc_addr),
        .ir_addr(ir_addr),
        .sel(sel),
        .mem_addr(mem_addr)
    );

    initial begin
        // TC1
        pc_addr = 5'b10101;
        ir_addr = 5'b01010;
        sel = 0;
        
        // TC2
        sel = 1;
        
        // TC3
        sel = 0;
        ir_addr = 5'b00001;
        #10;
        ir_addr = 5'b11100;
        
        // TC4
        sel = 1;
        pc_addr = 5'b00011;
        #10;
        pc_addr = 5'b11010;
        
        // TC5
        pc_addr = 5'b11111;
        ir_addr = 5'b00000;
        
        sel = 0; #10;
        sel = 1; #10;
        sel = 0; #10;
        sel = 1; #10;
        $finish;
    end

    initial begin
        $monitor("Time=%0t | sel=%b | pc_addr=%b | ir_addr=%b | mem_addr=%b",
                 $time, sel, pc_addr, ir_addr, mem_addr);
    end

endmodule