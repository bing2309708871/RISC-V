`include "defines.v"

// 执行模块
// 纯组合逻辑电路
module ex(
    input wire rst,

    // from id
    input wire[`InstBus] inst_i,            // 指令内容
    input wire[`InstAddrBus] inst_addr_i,   // 指令地址
    input wire reg_we_i,                    // 是否写通用寄存器
    input wire[`RegAddrBus] reg_waddr_i,    // 写通用寄存器地址
    input wire[`RegBus] reg1_rdata_i,       // 通用寄存器1输入数据
    input wire[`RegBus] reg2_rdata_i,       // 通用寄存器2输入数据
    input wire[`MemAddrBus] op1_i,
    input wire[`MemAddrBus] op2_i,

    // from mem
    input wire[`MemBus] mem_rdata_i,        // 内存输入数据
    
    // to mem
    output reg[`MemBus] mem_wdata_o,        // 写内存数据
    output reg[`MemAddrBus] mem_raddr_o,    // 读内存地址
    output reg[`MemAddrBus] mem_waddr_o,    // 写内存地址
    output wire mem_we_o,                   // 是否要写内存
    output wire mem_req_o,                  // 请求访问内存标志
    
    // to regs
    output wire[`RegBus] reg_wdata_o,       // 写寄存器数据
    output wire reg_we_o,                   // 是否要写通用寄存器
    output wire[`RegAddrBus] reg_waddr_o   // 写通用寄存器地址
    );

    wire[6:0] opcode;
    wire[2:0] funct3;
    wire[6:0] funct7;
    wire[4:0] rd;
    wire[4:0] uimm;
    reg[`RegBus] reg_wdata;
    reg reg_we;
    reg[`RegAddrBus] reg_waddr;
    reg mem_we;
    reg mem_req;

    assign opcode = inst_i[6:0];
    assign funct3 = inst_i[14:12];
    assign funct7 = inst_i[31:25];
    assign rd = inst_i[11:7];
    assign uimm = inst_i[19:15];
    
    assign reg_wdata_o = reg_wdata;
    assign reg_we_o = reg_we;
    assign reg_waddr_o = reg_waddr;
    
    assign mem_we_o =  mem_we;
    assign mem_req_o =  mem_req;

    
    // 执行
    always @ (*) begin
        reg_we = reg_we_i;
        reg_waddr = reg_waddr_i;
        mem_req = `BUS_NREQ;
        case (opcode)
            `INST_TYPE_I: begin
                case (funct3)
                    `INST_ORI: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = op1_i | op2_i;
                    end
                    default: begin
                        mem_wdata_o = `ZeroWord;
                        mem_raddr_o = `ZeroWord;
                        mem_waddr_o = `ZeroWord;
                        mem_we = `WriteDisable;
                        reg_wdata = `ZeroWord;
                    end
                endcase
            end
            default: begin
                reg_wdata = `ZeroWord;
            end
        endcase
    end

endmodule