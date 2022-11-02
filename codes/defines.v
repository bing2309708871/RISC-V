
`define CpuResetAddr 32'h0

`define RstEnable 1'b0
`define RstDisable 1'b1
`define ZeroWord 32'h0
`define ZeroReg 5'h0
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define True 1'b1
`define False 1'b0

`define Stop 1'b1
`define NoStop 1'b0
`define BUS_ACK 1'b1
`define BUS_NACK 1'b0
`define BUS_REQ 1'b1
`define BUS_NREQ 1'b0


// I type inst
`define INST_TYPE_I 7'b0010011
`define INST_ORI    3'b110


`define INST_NOP    32'h00000001


`define RomNum 4096  // rom depth(how many words)
`define MemNum 4096  // memory depth(how many words)
`define MemBus 31:0
`define MemAddrBus 31:0

`define InstBus 31:0
`define InstAddrBus 31:0

// common regs
`define RegAddrBus 4:0
`define RegBus 31:0
`define DoubleRegBus 63:0
`define RegWidth 32
`define RegNum 32        // reg num
`define RegNumLog2 5
