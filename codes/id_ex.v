`include "defines.v"

// ����������ִ��ģ�鴫��
module id_ex(
    input wire clk,
    input wire rst,

    input wire[`InstBus] inst_i,            // ָ������
    input wire[`InstAddrBus] inst_addr_i,   // ָ���ַ
    input wire reg_we_i,                    // дͨ�üĴ�����־
    input wire[`RegAddrBus] reg_waddr_i,    // дͨ�üĴ�����ַ
    input wire[`RegBus] reg1_rdata_i,       // ͨ�üĴ���1������
    input wire[`RegBus] reg2_rdata_i,       // ͨ�üĴ���2������
    input wire[`MemAddrBus] op1_i,
    input wire[`MemAddrBus] op2_i,

    output wire[`InstBus] inst_o,            // ָ������
    output wire[`InstAddrBus] inst_addr_o,   // ָ���ַ
    output wire reg_we_o,                    // дͨ�üĴ�����־
    output wire[`RegAddrBus] reg_waddr_o,    // дͨ�üĴ�����ַ
    output wire[`RegBus] reg1_rdata_o,       // ͨ�üĴ���1������
    output wire[`RegBus] reg2_rdata_o,       // ͨ�üĴ���2������
    output wire[`MemAddrBus] op1_o,
    output wire[`MemAddrBus] op2_o
    );


    wire[`InstBus] inst;
    gen_pipe_dff #(32) inst_ff(clk, rst, 1'b0, `INST_NOP, inst_i, inst);
    assign inst_o = inst;

    wire[`InstAddrBus] inst_addr;
    gen_pipe_dff #(32) inst_addr_ff(clk, rst,  1'b0, `ZeroWord, inst_addr_i, inst_addr);
    assign inst_addr_o = inst_addr;

    wire reg_we;
    gen_pipe_dff #(1) reg_we_ff(clk, rst,  1'b0, `WriteDisable, reg_we_i, reg_we);
    assign reg_we_o = reg_we;

    wire[`RegAddrBus] reg_waddr;
    gen_pipe_dff #(5) reg_waddr_ff(clk, rst,  1'b0, `ZeroReg, reg_waddr_i, reg_waddr);
    assign reg_waddr_o = reg_waddr;

    wire[`RegBus] reg1_rdata;
    gen_pipe_dff #(32) reg1_rdata_ff(clk, rst,  1'b0, `ZeroWord, reg1_rdata_i, reg1_rdata);
    assign reg1_rdata_o = reg1_rdata;

    wire[`RegBus] reg2_rdata;
    gen_pipe_dff #(32) reg2_rdata_ff(clk, rst,  1'b0, `ZeroWord, reg2_rdata_i, reg2_rdata);
    assign reg2_rdata_o = reg2_rdata;

    wire[`MemAddrBus] op1;
    gen_pipe_dff #(32) op1_ff(clk, rst,  1'b0, `ZeroWord, op1_i, op1);
    assign op1_o = op1;

    wire[`MemAddrBus] op2;
    gen_pipe_dff #(32) op2_ff(clk, rst,  1'b0, `ZeroWord, op2_i, op2);
    assign op2_o = op2;

endmodule