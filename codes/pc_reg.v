`include "defines.v"

// PC寄存器模块
module pc_reg(
    input wire clk,
    input wire rst,
    output reg[`InstAddrBus] pc_o           // PC指针
    );

    always @ (posedge clk) begin
        // 复位
        if (rst == `RstEnable) begin
            pc_o <= `CpuResetAddr;
        // 地址加4
        end else begin
            pc_o <= pc_o + 4'h4;
        end
    end

endmodule