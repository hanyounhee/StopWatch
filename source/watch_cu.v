module watch_cu(
    input clk,
    input reset,
    input cs,
    input [2:0] i_btn_add,
    output o_run,
    output o_clear,
    output  [2:0] o_add
    );

    reg [2:0] r_add;

    assign o_run = 1'b1;
    assign o_clear = 1'b0;

    assign o_add = r_add;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_add <= 0;
        end
        else if(cs)begin
            r_add <= i_btn_add;
        end
        else begin
            r_add <= 0;
        end
    end

endmodule
