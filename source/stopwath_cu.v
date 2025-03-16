module stopwatch_cu(
    input clk,
    input reset,
    input cs,
    input i_btn_run,
    input i_btn_clear,
    output reg o_run,
    output reg o_clear,
    output [2:0] o_add
    );

    // fsm 구조로 controll unit을 설계
    parameter STOP = 2'b00;
    parameter RUN = 2'b01;
    parameter CLEAR = 2'b10;

    reg [1:0] state;
    reg [1:0] next;

    assign o_add = 3'b000;

    // state register
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state <= STOP;
        end
        else if(cs) begin
            state <= next;
        end
    end

    // next
    always @(*) begin
        next = state;
        case (state)
            STOP: begin
                if(i_btn_run) next = RUN;
                else if (i_btn_clear) next = CLEAR;
            end
            RUN: begin
                if(i_btn_run) next = STOP;
            end
            CLEAR: begin
                next = STOP;//if(i_btn_clear) next = STOP;
            end
        endcase
    end

    // output
    always @(*) begin
        o_run = 0;
        o_clear = 0;
        case (state)
            STOP: begin
                o_run = 0;
                o_clear = 0;
            end 
            RUN: begin
                o_run = 1;
                o_clear = 0;
            end
            CLEAR: begin
                o_clear = 1;
            end
        endcase
    end
endmodule
