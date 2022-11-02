`include "defines.v"

// ����ģ��
// ������߼���·
module id(

	input wire rst,

    // from if_id
    input wire[`InstBus] inst_i,             // ָ������
    input wire[`InstAddrBus] inst_addr_i,    // ָ���ַ

    // from regs
    input wire[`RegBus] reg1_rdata_i,        // ͨ�üĴ���1��������
    input wire[`RegBus] reg2_rdata_i,        // ͨ�üĴ���2��������

    // to regs
    output reg[`RegAddrBus] reg1_raddr_o,    // ��ͨ�üĴ���1��ַ
    output reg[`RegAddrBus] reg2_raddr_o,    // ��ͨ�üĴ���2��ַ

    // to ex
    output reg[`MemAddrBus] op1_o,
    output reg[`MemAddrBus] op2_o,
    output reg[`InstBus] inst_o,             // ָ������
    output reg[`InstAddrBus] inst_addr_o,    // ָ���ַ
    output reg[`RegBus] reg1_rdata_o,        // ͨ�üĴ���1����
    output reg[`RegBus] reg2_rdata_o,        // ͨ�üĴ���2����
    output reg reg_we_o,                     // дͨ�üĴ�����־
    output reg[`RegAddrBus] reg_waddr_o     // дͨ�üĴ�����ַ
    );

    wire[6:0] opcode = inst_i[6:0];
    wire[2:0] funct3 = inst_i[14:12];
    wire[6:0] funct7 = inst_i[31:25];
    wire[4:0] rd = inst_i[11:7];
    wire[4:0] rs1 = inst_i[19:15];
    wire[4:0] rs2 = inst_i[24:20];


    always @ (*) begin
        inst_o = inst_i;
        inst_addr_o = inst_addr_i;
        reg1_rdata_o = reg1_rdata_i;
        reg2_rdata_o = reg2_rdata_i;

        op1_o = `ZeroWord;
        op2_o = `ZeroWord;


        case (opcode)
            `INST_TYPE_I: begin
                case (funct3)
                     `INST_ORI : begin
                        reg_we_o = `WriteEnable;
                        reg_waddr_o = rd;
                        reg1_raddr_o = rs1;
                        reg2_raddr_o = `ZeroReg;
                        op1_o = reg1_rdata_i;
                        op2_o = {{20{inst_i[31]}}, inst_i[31:20]};
                    end
                    default: begin
                        reg_we_o = `WriteDisable;
                        reg_waddr_o = `ZeroReg;
                        reg1_raddr_o = `ZeroReg;
                        reg2_raddr_o = `ZeroReg;
                    end
                endcase
            end
            default: begin
                reg_we_o = `WriteDisable;
                reg_waddr_o = `ZeroReg;
                reg1_raddr_o = `ZeroReg;
                reg2_raddr_o = `ZeroReg;
            end
        endcase
    end

endmodule