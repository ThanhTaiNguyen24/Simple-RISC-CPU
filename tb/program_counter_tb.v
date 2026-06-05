`timescale 1ns / 1ps

module program_counter_tb;

    reg clk;
    reg rst;
    reg ld_pc;
    reg inc_pc;
    reg halt;
    reg [4:0] load_addr;
    wire [4:0] pc_addr;

    program_counter uut (
        .clk(clk),
        .rst(rst),
        .ld_pc(ld_pc),
        .inc_pc(inc_pc),
        .halt(halt),
        .load_addr(load_addr),
        .pc_addr(pc_addr)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("Time=%0t | rst=%b halt=%b ld_pc=%b inc_pc=%b load_addr=%b pc_addr=%b",
                 $time, rst, halt, ld_pc, inc_pc, load_addr, pc_addr);
    end

    initial begin
        rst       = 0;
        halt      = 0;
        ld_pc     = 0;
        inc_pc    = 0;
        load_addr = 5'b00000;

        // TC1: Reset PC to 0
        #10;
        rst = 1;
        #10;
        rst = 0;

        // TC2: Hold when no control signal is active
        #20;

        // TC3: Increment once
        inc_pc = 1;
        #10;
        inc_pc = 0;

        // TC4: Multiple increments
        #10;
        inc_pc = 1;
        #30;
        inc_pc = 0;

        // TC5: Load external address
        #10;
        load_addr = 5'b10101;
        ld_pc = 1;
        #10;
        ld_pc = 0;

        // TC6: ld_pc and inc_pc active together
        // Expected: load_addr is loaded, not pc_addr + 1
        #10;
        load_addr = 5'b01010;
        ld_pc = 1;
        inc_pc = 1;
        #10;
        ld_pc = 0;
        inc_pc = 0;

        // TC7: Halt while increment is requested
        // Expected: PC holds its previous value
        #10;
        halt = 1;
        inc_pc = 1;
        #20;
        inc_pc = 0;
        halt = 0;

        // TC8: Halt while load is requested
        // Expected: PC holds its previous value
        #10;
        halt = 1;
        ld_pc = 1;
        load_addr = 5'b11100;
        #10;
        halt = 0;
        ld_pc = 0;

        // TC9: Overflow from 11111 to 00000
        #10;
        load_addr = 5'b11111;
        ld_pc = 1;
        #10;
        ld_pc = 0;

        #10;
        inc_pc = 1;
        #10;
        inc_pc = 0;

        // TC10: Reset priority during operation
        #10;
        inc_pc = 1;
        load_addr = 5'b00111;
        ld_pc = 1;
        rst = 1;
        #10;
        rst = 0;
        inc_pc = 0;
        ld_pc = 0;

        // TC11: Increment again after reset
        #10;
        inc_pc = 1;
        #20;
        inc_pc = 0;

        #20;
        $finish;
    end

endmodule