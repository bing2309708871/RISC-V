`include "defines.v"

// PC�Ĵ���ģ��
module pc_reg(
    input wire clk,
    input wire rst,
    output reg[`InstAddrBus] pc_o           // PCָ��
    );

    always @ (posedge clk) begin
        // ��λ
        if (rst == `RstEnable) begin
            pc_o <= `CpuResetAddr;
        // ��ַ��4
        end else begin
            pc_o <= pc_o + 4'h4;
        end
    end

endmodule