module sw_mode_wt_st (
    input i_sw_mode,
    input [6:0] stw_msec,
    input [5:0] stw_sec, 
    input [5:0] stw_min,
    input [4:0] stw_hour,
    input [6:0] wt_msec,
    input [5:0] wt_sec, 
    input [5:0] wt_min,
    input [4:0] wt_hour,
    output [6:0] w_msec,
    output [5:0] w_sec, 
    output [5:0] w_min,
    output [4:0] w_hour
);

    assign w_msec = i_sw_mode ? wt_msec : stw_msec;
    assign w_sec = i_sw_mode ? wt_sec : stw_sec;
    assign w_min = i_sw_mode ? wt_min : stw_min;
    assign w_hour = i_sw_mode ? wt_hour + 5'd12 : stw_hour;

endmodule
