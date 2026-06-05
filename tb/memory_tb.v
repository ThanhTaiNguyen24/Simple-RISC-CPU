`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 04:56:02 PM
// Design Name: 
// Module Name: memory_tb
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


`timescale 1ns / 1ps

module memory_tb;

    reg clk;
    reg [4:0] addr;
    reg rd;
    reg wr;
    wire [7:0] data;

    // This register represents the external datapath driving the bidirectional bus during write.
    reg [7:0] data_bus;

    // Testbench drives data only during write operation.
    // Otherwise, it releases the bus to high impedance.
    assign data = (wr && !rd) ? data_bus : 8'bz;

    memory uut (
        .clk(clk),
        .addr(addr),
        .rd(rd),
        .wr(wr),
        .data(data)
    );
    wire [7:0] mem0_debug;
    wire [7:0] mem1_debug;
    wire [7:0] mem15_debug;
    
    assign mem0_debug  = uut.mem[0];
    assign mem1_debug  = uut.mem[1];
    assign mem15_debug = uut.mem[15];
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task display_memory_array;
        integer i;
        begin
            $display("\n---------------- MEMORY ARRAY ----------------");
            for (i = 0; i < 32; i = i + 1) begin
                $display("mem[%0d] = %b", i, uut.mem[i]);
            end
            $display("----------------------------------------------\n");
        end
    endtask

    initial begin
        addr     = 5'b00000;
        rd       = 1'b0;
        wr       = 1'b0;
        data_bus = 8'b00000000;


        #10;

        // TC1: Write to address 0
        $display("\nTC1: Write 10101010 to address 00000, 1111111 to address 00001");

        addr     = 5'b00000;
        data_bus = 8'b10101010;
        rd       = 1'b0;
        wr       = 1'b1;

        #10;  

        wr = 1'b0;
        $display("Result: mem[%0d] = %b", addr, uut.mem[addr]);
        #10;
        
        addr     = 5'b00001;
        data_bus = 8'b11111111;
        rd       = 1'b0;
        wr       = 1'b1;
        #10;  

        wr = 1'b0;
        $display("Result: mem[%0d] = %b", addr, uut.mem[addr]);
        display_memory_array();
        
        // TC2: Read from address 0
        $display("\nTC2: Read from address 00000");

        addr = 5'b00000;
        rd   = 1'b1;
        wr   = 1'b0;

        #10;

        $display("Result: data = %b, mem[%0d] = %b", data, addr, uut.mem[addr]);
        #10;

        // TC3: Write to address 15
        $display("\nTC3: Write 11110000 to address 01111");

        addr     = 5'b01111;
        data_bus = 8'b11110000;
        rd       = 1'b0;
        wr       = 1'b1;

        #10;

        wr = 1'b0;
        #5;

        $display("Result: mem[%0d] = %b", addr, uut.mem[addr]);
        display_memory_array();

        // TC4: Read from address 15
        $display("\nTC4: Read from address 01111");

        addr = 5'b01111;
        rd   = 1'b1;
        wr   = 1'b0;

        #10;

        $display("Result: data = %b, mem[%0d] = %b", data, addr, uut.mem[addr]);

        rd = 1'b0;
        #10;
        $display("\nFinal Memory Content:");
        display_memory_array();

        #10;
        $finish;
    end

    initial begin
        $monitor("Time=%0t | addr=%b | rd=%b | wr=%b | data_bus=%b | data=%b | mem[%0d]=%b",
                 $time, addr, rd, wr, data_bus, data, addr, uut.mem[addr]);
    end

endmodule