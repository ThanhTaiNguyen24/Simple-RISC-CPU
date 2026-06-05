`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 01:03:04 PM
// Design Name: 
// Module Name: top_cpu
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


module top_cpu(
    input wire clk,
    input wire rst
);

wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e; // Tín hiệu từ Controller
wire [4:0] pc_addr;           // Địa chỉ từ Program Counter
wire [7:0] ir_addr;           // [7:5]: Opcode ; [4:0]: // Địa chỉ từ Instruction Register
wire [4:0] mem_addr;          // Lựa chọn giữa PC và IR
wire is_zero;                

wire [7:0] data_bus;          // Bidirectional port
wire [7:0] acc_out;           // Giá trị từ Accumulator
wire [7:0] alu_out;           // Kết quả từ ALU

program_counter PC(
    .clk(clk),
    .rst(rst),
    .inc_pc(inc_pc),
    .ld_pc(ld_pc),
    .halt(halt),
    .load_addr(ir_addr[4:0]),
    .pc_addr(pc_addr[4:0])
);

register ins_reg(
    .clk(clk),
    .rst(rst),
    .ld(ld_ir),
    .data_in(data_bus[7:0]),
    .data_out(ir_addr[7:0])
);

register reg_acc(
    .clk(clk),
    .rst(rst),
    .ld(ld_ac),
    .data_in(alu_out[7:0]),
    .data_out(acc_out[7:0])
);

alu alu (
    .opcode(ir_addr[7:5]),
    .inA(acc_out[7:0]),
    .inB(data_bus[7:0]),
    .out(alu_out[7:0]),
    .is_zero(is_zero)
);

address_mux #(
    .ADDR_WIDTH(5)
) addr_mux(
    .pc_addr(pc_addr[4:0]),
    .ir_addr(ir_addr[4:0]),
    .sel(sel),
    .mem_addr(mem_addr[4:0])
);

memory mem(
    .clk(clk),               
    .addr(mem_addr[4:0]),       
    .rd(rd),               
    .wr(wr),               
    .data(data_bus[7:0])         
);

controller ctrl (
    .clk(clk),
    .rst(rst),
    .opcode(ir_addr[7:5]),
    .is_zero(is_zero),
    .sel(sel),
    .rd(rd),
    .ld_ir(ld_ir),
    .halt(halt),
    .inc_pc(inc_pc),
    .ld_ac(ld_ac),
    .ld_pc(ld_pc),
    .wr(wr),
    .data_e(data_e)
);

tristate_driver acc_driver (
    .enable(data_e && wr),
    .data_in(acc_out),
    .data_bus(data_bus)
);

endmodule
