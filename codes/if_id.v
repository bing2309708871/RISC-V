`include "defines.v"

// ��ָ��������ģ�鴫��
module if_id(
    input wire clk,
    input wire rst,
    input wire[`InstBus] inst_i,            // ָ������
    input wire[`InstAddrBus] inst_addr_i,   // ָ���ַ

    output wire[`InstBus] inst_o,           // ָ������
    output wire[`InstAddrBus] inst_addr_o   // ָ���ַ
    );

    wire[`InstBus] inst;
    gen_pipe_dff #(32) inst_ff(clk, rst, 1'b0, `INST_NOP, inst_i, inst);
    assign inst_o = inst;

    wire[`InstAddrBus] inst_addr;
    gen_pipe_dff #(32) inst_addr_ff(clk, rst, 1'b0, `ZeroWord, inst_addr_i, inst_addr);
    assign inst_addr_o = inst_addr;

endmodule