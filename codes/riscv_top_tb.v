`timescale 1ns / 1ps

`include "defines.v"

// testbench module
module riscv_soc_tb;
    reg clk;
    reg rst;

	always #10 clk = ~clk;     // 50MHz
    
    initial begin
        clk = 0;
        rst = `RstEnable;
        $display("test running...");
        #30
        rst = #1 `RstDisable;
        #500
        $display("Time Out.");
        $finish;
    end

    // read mem data
    initial begin
        $readmemh ("D:/vivado/examples/RISCV_by_me/RISCV_by_me.srcs/OR.txt", riscv_soc_top_0.u_rom._rom);
    end

    // generate wave file, used by gtkwave
    initial begin
        $dumpfile("riscv_soc_tb.vcd");
        $dumpvars(0, riscv_soc_tb);
    end

    riscv_soc_top riscv_soc_top_0(
        .clk(clk),
        .rst(rst)
    );

endmodule
