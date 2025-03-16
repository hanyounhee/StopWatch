module stopwatch_DP(
    input clk,
    input reset,
    input run,
    input clear,
    input [2:0] add,
    output [6:0] msec,
    output [5:0] sec,
    output [5:0] min,
    output [4:0] hour
    );

    wire w_clk_100hz;
    wire w_msec_tick;
    wire w_sec_tick;
    wire w_min_tick;

//msec
    time_counter #(
        .TICK_COUNT(100), 
        .BIT_WIDTH (7)
    ) U_Time_Msec(
        .clk(clk),
        .reset(reset),
        .tick(w_clk_100hz),
        .clear(clear),
        .add(1'b0),
        .o_time(msec),
        .o_tick(w_msec_tick)
    );
//sec
    time_counter #(
        .TICK_COUNT(60), 
        .BIT_WIDTH (6)
    ) U_Time_Sec(
        .clk(clk),
        .reset(reset),
        .tick(w_msec_tick),
        .clear(clear),
        .add(add[0]),
        .o_time(sec),
        .o_tick(w_sec_tick)
    );
//min
    time_counter #(
        .TICK_COUNT(60), 
        .BIT_WIDTH (6)
    ) U_Time_Min(
        .clk(clk),
        .reset(reset),
        .tick(w_sec_tick),
        .clear(clear),
        .add(add[1]),
        .o_time(min),
        .o_tick(w_min_tick)
    );
//hour
    time_counter #(
        .TICK_COUNT(24), 
        .BIT_WIDTH (5)
    ) U_Time_Hour(
        .clk(clk),
        .reset(reset),
        .tick(w_min_tick),
        .clear(clear),
        .add(add[2]),
        .o_time(hour),
        .o_tick()
    );

    clk_div_100 U_Clk_Div(
        .clk(clk),
        .reset(reset),
        .run(run),
        .clear(clear),
        .o_clk(w_clk_100hz)
    );

    
endmodule
