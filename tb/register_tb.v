`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 04:56:02 PM
// Design Name: 
// Module Name: register_tb
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


module register_tb;
    reg clk;
    reg rst;
    reg ld;
    reg [7:0] data_in;
    wire [7:0] data_out;

    register uut (
        .clk(clk),
        .rst(rst),
        .ld(ld),
        .data_in(data_in[7:0]),
        .data_out(data_out[7:0])
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 0;
        ld = 0;
        data_in = 8'b00010100;

        #10;
        rst = 1;
        #10;
        rst = 0;

        // Test case 2: Load data
        #10;
        data_in = 8'b10101011;
        ld = 1;
        #10;

        // TC3 Hold
        ld = 0;
        data_in = 8'b11110000;
        
        // Test case 5: Reset during load
        #10;
        data_in = 8'b01010101;
        ld = 1;
        #10
        ld = 0;
        
        #10
        data_in = 8'b11001100;
        ld = 1;
        #5;
        rst = 1;
        #10;
        rst = 0;
        ld = 0;
        
        #20
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t rst=%b ld=%b data_in=%b data_out=%b", 
                 $time, rst, ld, data_in, data_out);
    end

endmodule
