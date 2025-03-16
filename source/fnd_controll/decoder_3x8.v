module decoder_3x8(
    input [2:0] btn,
    output reg [3:0] seg_comm
    );
    
    always @(btn)begin
        case(btn)
            3'b000: seg_comm = 4'b1110;
            3'b001: seg_comm = 4'b1101;
            3'b010: seg_comm = 4'b1011;
            3'b011: seg_comm = 4'b0111;
            3'b100: seg_comm = 4'b1110;
            3'b101: seg_comm = 4'b1101;
            3'b110: seg_comm = 4'b1011;
            3'b111: seg_comm = 4'b0111;
            default: seg_comm = 4'b1111;
        endcase
    end
endmodule
