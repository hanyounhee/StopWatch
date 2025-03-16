module digit_split #(parameter BIT_WIDTH = 7)(
    input [BIT_WIDTH-1:0] bcd,
    output [3:0] digit_1,
    output [3:0] digit_10
    );

    assign digit_1 = bcd % 10;
    assign digit_10 = bcd / 10 % 10;

endmodule
