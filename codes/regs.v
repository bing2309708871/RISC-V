`include "defines.v"

// ͨ�üĴ���ģ��
module regs(
    input wire clk,
    input wire rst,

    // from ex
    input wire we_i,                      // д�Ĵ�����־
    input wire[`RegAddrBus] waddr_i,      // д�Ĵ�����ַ
    input wire[`RegBus] wdata_i,          // д�Ĵ�������

    // from id
    input wire[`RegAddrBus] raddr1_i,     // ���Ĵ���1��ַ
    input wire[`RegAddrBus] raddr2_i,     // ���Ĵ���2��ַ

    // to id
    output reg[`RegBus] rdata1_o,         // ���Ĵ���1����
    output reg[`RegBus] rdata2_o         // ���Ĵ���2����
    );

    reg[`RegBus] regs[0:`RegNum - 1];

    // д�Ĵ���
    always @ (posedge clk) begin
        if (rst == `RstDisable) begin
            if ((we_i == `WriteEnable) && (waddr_i != `ZeroReg)) begin
                regs[waddr_i] <= wdata_i;
            end
        end
    end

    // ���Ĵ���1
    always @ (*) begin
        if (raddr1_i == `ZeroReg) begin
            rdata1_o = `ZeroWord;
        // �������ַ����д��ַ����������д��������ֱ�ӷ���д����
        end else if (raddr1_i == waddr_i && we_i == `WriteEnable) begin
            rdata1_o = wdata_i;
        end else begin
            rdata1_o = regs[raddr1_i];
        end
    end

    // ���Ĵ���2
    always @ (*) begin
        if (raddr2_i == `ZeroReg) begin
            rdata2_o = `ZeroWord;
        // �������ַ����д��ַ����������д��������ֱ�ӷ���д����
        end else if (raddr2_i == waddr_i && we_i == `WriteEnable) begin
            rdata2_o = wdata_i;
        end else begin
            rdata2_o = regs[raddr2_i];
        end
    end

endmodule