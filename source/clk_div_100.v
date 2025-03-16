module clk_div_100 (
    input clk,
    input reset,
    input run,
    input clear,
    output o_clk
);
    parameter FCOUNT = 1_000_000;

    reg [$clog2(FCOUNT)-1:0] count_reg, count_next;
    reg clk_reg, clk_next;//출력을 f/f으로 내보내기 위해

    assign o_clk = clk_reg;//최종출력

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            count_reg <= 0;
            clk_reg <= 0;
        end
        else begin
            count_reg <= count_next;
            clk_reg <= clk_next;
        end
    end

    always @(*) begin
        count_next = count_reg;
        clk_next = 0;
        if(run) begin
            if(count_reg == (FCOUNT - 1)) begin
                count_next = 0;
                clk_next = 1'b1;
            end
            else begin
                count_next = count_reg + 1;
                clk_next = 1'b0;
            end
        end
        else if(clear) begin
            count_next = 0;
            clk_next = 0;
        end
    end
endmodule
