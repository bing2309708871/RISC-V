`include "defines.v"

// riscv�������˶���ģ��
module riscv(

    input wire clk,
    input wire rst,

    output wire[`MemAddrBus] bus_ex_addr_o,    // ����д����ĵ�ַ
    input wire[`MemBus] bus_ex_data_i,         // �������ȡ������
    output wire[`MemBus] bus_ex_data_o,        // д�����������
    output wire bus_ex_req_o,                  // ������������
    output wire bus_ex_we_o,                   // д�����־

    output wire[`MemAddrBus] bus_pc_addr_o,    // ȡָ��ַ
    input wire[`MemBus] bus_pc_data_i         // ȡ����ָ������
    );

    // pc_regģ������ź�
	wire[`InstAddrBus] pc_pc_o;

    // if_idģ������ź�
	wire[`InstBus] if_inst_o;
    wire[`InstAddrBus] if_inst_addr_o;

    // idģ������ź�
    wire[`RegAddrBus] id_reg1_raddr_o;
    wire[`RegAddrBus] id_reg2_raddr_o;
    wire[`InstBus] id_inst_o;
    wire[`InstAddrBus] id_inst_addr_o;
    wire[`RegBus] id_reg1_rdata_o;
    wire[`RegBus] id_reg2_rdata_o;
    wire id_reg_we_o;
    wire[`RegAddrBus] id_reg_waddr_o;
    wire[`MemAddrBus] id_op1_o;
    wire[`MemAddrBus] id_op2_o;


    // id_exģ������ź�
    wire[`InstBus] ie_inst_o;
    wire[`InstAddrBus] ie_inst_addr_o;
    wire ie_reg_we_o;
    wire[`RegAddrBus] ie_reg_waddr_o;
    wire[`RegBus] ie_reg1_rdata_o;
    wire[`RegBus] ie_reg2_rdata_o;

    wire[`MemAddrBus] ie_op1_o;
    wire[`MemAddrBus] ie_op2_o;

    // exģ������ź�
    wire[`MemBus] ex_mem_wdata_o;
    wire[`MemAddrBus] ex_mem_raddr_o;
    wire[`MemAddrBus] ex_mem_waddr_o;
    wire ex_mem_we_o;
    wire ex_mem_req_o;
    wire[`RegBus] ex_reg_wdata_o;
    wire ex_reg_we_o;
    wire[`RegAddrBus] ex_reg_waddr_o;


    // regsģ������ź�
    wire[`RegBus] regs_rdata1_o;
    wire[`RegBus] regs_rdata2_o;


    assign bus_ex_addr_o = (ex_mem_we_o == `WriteEnable)? ex_mem_waddr_o: ex_mem_raddr_o;
    assign bus_ex_data_o = ex_mem_wdata_o;
    assign bus_ex_req_o = ex_mem_req_o;
    assign bus_ex_we_o = ex_mem_we_o;

    assign bus_pc_addr_o = pc_pc_o;


    // pc_regģ������
    pc_reg u_pc_reg(
        .clk(clk),
        .rst(rst),
        .pc_o(pc_pc_o)
    );


    // regsģ������
    regs u_regs(
        .clk(clk),
        .rst(rst),
        .we_i(ex_reg_we_o),
        .waddr_i(ex_reg_waddr_o),
        .wdata_i(ex_reg_wdata_o),
        .raddr1_i(id_reg1_raddr_o),
        .rdata1_o(regs_rdata1_o),
        .raddr2_i(id_reg2_raddr_o),
        .rdata2_o(regs_rdata2_o)
    );


    // if_idģ������
    if_id u_if_id(
        .clk(clk),
        .rst(rst),
        .inst_i(bus_pc_data_i),
        .inst_addr_i(pc_pc_o),
        .inst_o(if_inst_o),
        .inst_addr_o(if_inst_addr_o)
    );

    // idģ������
    id u_id(
        .rst(rst),
        .inst_i(if_inst_o),
        .inst_addr_i(if_inst_addr_o),
        .reg1_rdata_i(regs_rdata1_o),
        .reg2_rdata_i(regs_rdata2_o),
        .reg1_raddr_o(id_reg1_raddr_o),
        .reg2_raddr_o(id_reg2_raddr_o),
        .inst_o(id_inst_o),
        .inst_addr_o(id_inst_addr_o),
        .reg1_rdata_o(id_reg1_rdata_o),
        .reg2_rdata_o(id_reg2_rdata_o),
        .reg_we_o(id_reg_we_o),
        .reg_waddr_o(id_reg_waddr_o),
        .op1_o(id_op1_o),
        .op2_o(id_op2_o)
    );

    // id_exģ������
    id_ex u_id_ex(
        .clk(clk),
        .rst(rst),
        .inst_i(id_inst_o),
        .inst_addr_i(id_inst_addr_o),
        .reg_we_i(id_reg_we_o),
        .reg_waddr_i(id_reg_waddr_o),
        .reg1_rdata_i(id_reg1_rdata_o),
        .reg2_rdata_i(id_reg2_rdata_o),
        .inst_o(ie_inst_o),
        .inst_addr_o(ie_inst_addr_o),
        .reg_we_o(ie_reg_we_o),
        .reg_waddr_o(ie_reg_waddr_o),
        .reg1_rdata_o(ie_reg1_rdata_o),
        .reg2_rdata_o(ie_reg2_rdata_o),
        .op1_i(id_op1_o),
        .op2_i(id_op2_o),
        .op1_o(ie_op1_o),
        .op2_o(ie_op2_o)
    );

    // exģ������
    ex u_ex(
        .rst(rst),
        .inst_i(ie_inst_o),
        .inst_addr_i(ie_inst_addr_o),
        .reg_we_i(ie_reg_we_o),
        .reg_waddr_i(ie_reg_waddr_o),
        .reg1_rdata_i(ie_reg1_rdata_o),
        .reg2_rdata_i(ie_reg2_rdata_o),
        .op1_i(ie_op1_o),
        .op2_i(ie_op2_o),
        .mem_rdata_i(bus_ex_data_i),
        .mem_wdata_o(ex_mem_wdata_o),
        .mem_raddr_o(ex_mem_raddr_o),
        .mem_waddr_o(ex_mem_waddr_o),
        .mem_we_o(ex_mem_we_o),
        .mem_req_o(ex_mem_req_o),
        .reg_wdata_o(ex_reg_wdata_o),
        .reg_we_o(ex_reg_we_o),
        .reg_waddr_o(ex_reg_waddr_o)
    );


endmodule
