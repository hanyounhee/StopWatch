module fnd_control(
    input clk,
    input reset,
    input sw_mode,
    input [6:0] msec,
    input [5:0] sec,
    input [5:0] min,
    input [4:0] hour,
    output [3:0] fnd_comm,
    output [7:0] fnd_font
    );

    wire w_clk_200hz;
    
    wire [3:0] w_digit_msec_1;
    wire [3:0] w_digit_msec_10;

    wire [3:0] w_digit_sec_1;
    wire [3:0] w_digit_sec_10;

    wire [3:0] w_digit_min_1;
    wire [3:0] w_digit_min_10;

    wire [3:0] w_digit_hour_1;
    wire [3:0] w_digit_hour_10;

    wire [2:0] w_sel;

    wire [3:0] w_bcd;
    wire [3:0] w_min_hour;
    wire [3:0] w_msec_sec;
    wire [3:0] w_dot;



    clk_divider_fnd U_clk_div_200hz(
        .clk(clk),
        .reset(reset),
        .o_clk(w_clk_200hz)
    );

    counter_8 U_counter_8(
        .clk(w_clk_200hz),
        .reset(reset),
        .o_sel(w_sel)
    );

    decoder_3x8 U_dec(
        .btn(w_sel),
        .seg_comm(fnd_comm)
    );
    
    digit_split #(.BIT_WIDTH(7))
    U_digit_split_msec(
        .bcd(msec),//msec
        .digit_1(w_digit_msec_1),
        .digit_10(w_digit_msec_10)
    );

    digit_split #(.BIT_WIDTH(6))
    U_digit_split_sec(
        .bcd(sec),//sec
        .digit_1(w_digit_sec_1),
        .digit_10(w_digit_sec_10)
    );

    digit_split #(.BIT_WIDTH(6))
    U_digit_split_min(
        .bcd(min),//min
        .digit_1(w_digit_min_1),
        .digit_10(w_digit_min_10)
    );

    digit_split #(.BIT_WIDTH(5))
    U_digit_split_hour(
        .bcd(hour),//hour
        .digit_1(w_digit_hour_1),
        .digit_10(w_digit_hour_10)
    ); 

    assign w_dot = (w_digit_msec_10<5)? 4'hE : 4'hf;

    mux_8x1 U_mux_8x1_min_hour(
        .selection(w_sel),
        .digit_1(w_digit_min_1),//min
        .digit_10(w_digit_min_10),//min
        .digit_100(w_digit_hour_1),//hour
        .digit_1000(w_digit_hour_10),//hour
        .x4(4'hf),
        .x5(4'hf),
        .x6(w_dot),
        .x7(4'hf),
        .bcd(w_min_hour)
    );

    mux_8x1 U_mux_8x1_msec_sec(
        .selection(w_sel),
        .digit_1(w_digit_msec_1),//msec
        .digit_10(w_digit_msec_10),//msec
        .digit_100(w_digit_sec_1),//sec
        .digit_1000(w_digit_sec_10),//sec
        .x4(4'hf),
        .x5(4'hf),
        .x6(w_dot),
        .x7(4'hf),
        .bcd(w_msec_sec)
    );

    assign w_bcd = sw_mode ? w_min_hour : w_msec_sec;

    bcd_to_seg U_btc(
        .bcd(w_bcd),
        .seg(fnd_font)
    );
endmodule

