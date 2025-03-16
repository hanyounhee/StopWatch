module time_counter #(
    parameter TICK_COUNT = 100, 
    parameter BIT_WIDTH = 7)
    (
    input clk,
    input reset,
    input tick,
    input clear,
    input add,
    output [BIT_WIDTH-1:0] o_time,
    output o_tick
);


    reg [$clog2(TICK_COUNT)-1:0] count_reg;
    reg [$clog2(TICK_COUNT)-1:0] count_next;
    reg tick_reg;
    reg tick_next;

    assign o_time = count_reg;
    assign o_tick = tick_reg;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            count_reg <= 0;
            tick_reg <= 0;
        end
        else begin
            count_reg <= count_next;
            tick_reg <= tick_next;
        end
    end

    always @(*) begin
        count_next = count_reg;
        tick_next = 0;
        if (clear) begin
            count_next = 0;
        end
        else if(tick) begin
            if(count_reg == TICK_COUNT - 1) begin
                count_next = 0;
                tick_next = 1;
            end
            else begin
                count_next = count_reg + 1;
                tick_next = 0;
            end
        end
        else if(add) begin
            if(count_reg == TICK_COUNT - 1) begin
                count_next = 0;
                tick_next = 1;
            end
            else begin
                count_next = count_reg + 1;
                tick_next = 0;
            end
        end
    end
    
endmodule
