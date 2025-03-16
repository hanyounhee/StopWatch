module top_stopwatch(
    input clk,
    input reset,
    input i_btn_run,
    input i_btn_clear,
    input [1:0] i_btn_add,
    input [1:0] i_sw_mode,
    output [3:0] fnd_comm,
    output [7:0] fnd_font,
    output [3:0] led
    );

    wire w_run, w_clear, w_o_run, w_o_clear;

    wire [6:0] stw_msec;
    wire [5:0] stw_sec, stw_min;
    wire [4:0] stw_hour;

    wire [6:0] wt_msec;
    wire [5:0] wt_sec, wt_min;
    wire [4:0] wt_hour;

    wire [6:0] w_msec;
    wire [5:0] w_sec, w_min;
    wire [4:0] w_hour;

    wire [2:0] w_st_add;

    wire w_wt_clear;
    wire w_wt_run;

    wire [1:0] w_add;
    wire [2:0] w_o_add;

//stopwatch-------------------------------------------------------------------------
    btn_debounce U_Btn_RUN(
        .clk(clk),
        .reset(reset),
        .i_btn(i_btn_run),
        .o_btn(w_run)
    );

    btn_debounce U_Btn_CLEAR(
        .clk(clk),
        .reset(reset),
        .i_btn(i_btn_clear),
        .o_btn(w_clear)
    );

    stopwatch_cu U_StopWatch_Control_Unit(
        .clk(clk),
        .reset(reset),
        .cs(~i_sw_mode[1]),
        .i_btn_run(w_run),
        .i_btn_clear(w_clear),
        .o_run(w_o_run),
        .o_clear(w_o_clear),
        .o_add(w_st_add)
    );

    stopwatch_DP U_StopWatch_DP(
        .clk(clk),
        .reset(reset),
        .run(w_o_run),
        .clear(w_o_clear),
        .add(w_st_add),
        .msec(stw_msec),
        .sec(stw_sec),
        .min(stw_min),
        .hour(stw_hour)
    );
//---------------------------------------------------------------------------------

//watch----------------------------------------------------------------------------
    btn_debounce U_Btn_ADD0(//add sec --> up btn
        .clk(clk),
        .reset(reset),
        .i_btn(i_btn_add[0]),
        .o_btn(w_add[0])
    );

    btn_debounce U_Btn_ADD1(//add min --> down btn
        .clk(clk),
        .reset(reset),
        .i_btn(i_btn_add[1]),
        .o_btn(w_add[1])
    );

    // btn_debounce U_Btn_ADD2(//add hour --> left btn
    //     .clk(clk),
    //     .reset(reset),
    //     .i_btn(i_btn_clear),//clear랑 add hour랑 같은 btn 사용함
    //     .o_btn(w_add[2])    //그래서 헷갈리니까 이렇게 btn debounce 하나 더 사용함.
    // );

    watch_cu U_Watch_Control_Unit(
        .clk(clk),
        .reset(reset),
        .cs(i_sw_mode[1]),
        .i_btn_add({w_clear, w_add}),
        .o_run(w_wt_run),
        .o_clear(w_wt_clear),
        .o_add(w_o_add)
    );

    stopwatch_DP U_Watch_DP(
        .clk(clk),
        .reset(reset),
        .run(w_wt_run),
        .clear(w_wt_clear),
        .add(w_o_add),
        .msec(wt_msec),
        .sec(wt_sec),
        .min(wt_min),
        .hour(wt_hour)
    );
//---------------------------------------------------------------------------------


    sw_mode_wt_st U_sw_mode_wt_st(
        .i_sw_mode(i_sw_mode[1]),
        .stw_msec(stw_msec),
        .stw_sec(stw_sec), 
        .stw_min(stw_min),
        .stw_hour(stw_hour),
        .wt_msec(wt_msec),
        .wt_sec(wt_sec), 
        .wt_min(wt_min),
        .wt_hour(wt_hour),
        .w_msec(w_msec),
        .w_sec(w_sec), 
        .w_min(w_min),
        .w_hour(w_hour)
    );

    fnd_control U_Fnd_Cntrl(
        .clk(clk),
        .reset(reset),
        .sw_mode(i_sw_mode[0]),//hour_min, sec_msec
        .msec(w_msec),
        .sec(w_sec),
        .min(w_min),
        .hour(w_hour),
        .fnd_comm(fnd_comm),
        .fnd_font(fnd_font)
    );

    assign led = (i_sw_mode == 2'b00) ? 4'b0001 : (i_sw_mode == 2'b01) ? 4'b0010 : (i_sw_mode == 2'b10) ? 4'b0100 : 4'b1000;

endmodule
