module mux_4x1(
    input [1:0] selection,
    input [3:0] digit_1,
    input [3:0] digit_10,
    input [3:0] digit_100,
    input [3:0] digit_1000,
    output [3:0] bcd
    );

    reg [3:0] r_bcd;

    assign bcd = r_bcd;

    always @(selection, digit_1, digit_10, digit_100, digit_1000) begin
        case (selection)
            3'b000: r_bcd = digit_1;
            3'b001: r_bcd = digit_10;
            3'b010: r_bcd = digit_100;
            3'b011: r_bcd = digit_1000;
            default: r_bcd = 4'bxxxx;
        endcase
    end
endmodule

module mux_8x1(
    input [2:0] selection,
    input [3:0] digit_1,
    input [3:0] digit_10,
    input [3:0] digit_100,
    input [3:0] digit_1000,
    input [3:0] x4,
    input [3:0] x5,
    input [3:0] x6,
    input [3:0] x7,
    output [3:0] bcd
    );

    reg [3:0] r_bcd;

    assign bcd = r_bcd;

    always @(*) begin
        case (selection)
            3'b000: r_bcd = digit_1;
            3'b001: r_bcd = digit_10;
            3'b010: r_bcd = digit_100;
            3'b011: r_bcd = digit_1000;
            3'b100: r_bcd = x4;
            3'b101: r_bcd = x5;
            3'b110: r_bcd = x6;
            3'b111: r_bcd = x7;
            default: r_bcd = 4'hf;
        endcase
    end
endmodule
