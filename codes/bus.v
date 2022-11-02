`include "defines.v"

// RIB����ģ��
module bus(

    input wire clk,
    input wire rst,

    // master 0 interface
    input wire[`MemAddrBus] m0_addr_i,     // ���豸0����д��ַ
    input wire[`MemBus] m0_data_i,         // ���豸0д����
    output reg[`MemBus] m0_data_o,         // ���豸0��ȡ��������
    input wire m0_req_i,                   // ���豸0���������־
    input wire m0_we_i,                    // ���豸0д��־
    
    // master 1 interface
    input wire[`MemAddrBus] m1_addr_i,     // ���豸1����д��ַ
    input wire[`MemBus] m1_data_i,         // ���豸1д����
    output reg[`MemBus] m1_data_o,         // ���豸1��ȡ��������
    input wire m1_req_i,                   // ���豸1���������־
    input wire m1_we_i,                    // ���豸1д��־

    // slave 0 interface
    output reg[`MemAddrBus] s0_addr_o,     // ���豸0����д��ַ
    output reg[`MemBus] s0_data_o,         // ���豸0д����
    input wire[`MemBus] s0_data_i,         // ���豸0��ȡ��������
    output reg s0_we_o,                    // ���豸0д��־
    
    // slave 1 interface
    output reg[`MemAddrBus] s1_addr_o,     // ���豸1����д��ַ
    output reg[`MemBus] s1_data_o,         // ���豸1д����
    input wire[`MemBus] s1_data_i,         // ���豸1��ȡ��������
    output reg s1_we_o                     // ���豸1д��־
    );


    // ���ʵ�ַ�����4λ����Ҫ���ʵ�����һ�����豸
    // ������֧��16�����豸
    parameter [3:0]slave_0 = 4'b0000;
    parameter [3:0]slave_1 = 4'b0001;
    parameter [1:0]grant0 = 2'h0;
    parameter [1:0]grant1 = 2'h1;

    wire[3:0] req;
    reg[1:0] grant;
    
    // ���豸�����ź�
    assign req = {m1_req_i,m0_req_i};

    // �ٲ��߼�
    // �̶����ȼ��ٲû���
    always @ (*) begin
        if (req[0]) begin
            grant = grant0;
        end else begin
            grant = grant1;
        end
    end

    // �����ٲý����ѡ��(����)��Ӧ�Ĵ��豸
    always @ (*) begin
        m0_data_o = `ZeroWord;
        m1_data_o = `INST_NOP;
        s0_addr_o = `ZeroWord;
        s1_addr_o = `ZeroWord;
        s0_data_o = `ZeroWord;
        s1_data_o = `ZeroWord;
        s0_we_o = `WriteDisable;
        s1_we_o = `WriteDisable;
        case (grant)
            grant0: begin
                case (m0_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m0_we_i;
                        s0_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s0_data_o = m0_data_i;
                        m0_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m0_we_i;
                        s1_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s1_data_o = m0_data_i;
                        m0_data_o = s1_data_i;
                    end
                    default: begin
                    end
                endcase
            end
            grant1: begin
                case (m1_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m1_we_i;
                        s0_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s0_data_o = m1_data_i;
                        m1_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m1_we_i;
                        s1_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s1_data_o = m1_data_i;
                        m1_data_o = s1_data_i;
                    end
                    default: begin
                    end
                endcase
            end
            default: begin
            end
        endcase
    end

endmodule
