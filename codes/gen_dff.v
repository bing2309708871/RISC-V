// 带默认值和控制信号的流水线触发器
module gen_pipe_dff #(parameter DW = 32)(
    input wire clk,
    input wire rst,
    input wire hold_en,
    input wire[DW-1:0] def_val,
    input wire[DW-1:0] din,
    
    output wire[DW-1:0] qout
    );

    reg[DW-1:0] qout_r;

    always @ (posedge clk) begin
        if (!rst | hold_en) begin
            qout_r <= def_val;
        end else begin
            qout_r <= din;
        end
    end

    assign qout = qout_r;

endmodule