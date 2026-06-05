`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:59:37 PM
// Design Name: 
// Module Name: address_mux
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


module address_mux #(
    parameter ADDR_WIDTH = 5  // Độ rộng địa chỉ mặc định là 5 bit
) (
    input       [ADDR_WIDTH-1:0]    pc_addr, // Địa chỉ từ Program Counter
    input       [ADDR_WIDTH-1:0]    ir_addr, // Địa chỉ từ Instruction Register
    input                           sel,     // Tín hiệu điều khiển chọn
    output reg  [ADDR_WIDTH-1:0]    mem_addr // Địa chỉ xuất ra cho Memory
);

    always @(*) begin
        case (sel)
            1'b1: mem_addr = pc_addr;    // Chọn địa chỉ từ PC (nạp lệnh)
            1'b0: mem_addr = ir_addr;    // Chọn địa chỉ từ IR (thực thi lệnh)
            default: mem_addr = pc_addr;
        endcase
    end

endmodule
