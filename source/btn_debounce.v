module btn_debounce(
    clk,
    reset,
    i_btn,
    o_btn
    );

    input clk;
    input reset;
    input i_btn;
    output o_btn;


    reg [7:0] q_reg;
    reg [7:0] q_next;
    reg r_edge_detect;

    wire btn_debounce;

    // 1kHz clk, state-----------------------------------------------------------
    // 100Mhz로 btn신호 감지하기에는 너무 빠르니까(btn신호 자글자글한데 100M로 detect하면 0이나 1만 주구장창 나오겠지)
    // 그래서 1khz클락으로 detect하려고 클락 만들어주는 거임(counter_tick_v처럼 fsm으로 만들어 준거임)
    reg [$clog2(100_000)-1:0] counter_reg;
    reg [$clog2(100_000)-1:0] counter_next;
    reg r_1khz;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;//
            r_1khz <= 0;
        end
        else begin
            // counter_reg <= counter_next;
            if(counter_reg == 100_000 - 1)begin // 1khz == 100_000_000 / 100_000
                counter_reg <= 0;
                r_1khz <= 1'b1;
            end 
            else begin // 1khz tick
                counter_reg <= counter_reg + 1;
                r_1khz <= 1'b0;
            end
        end
    end
    
    // // next
    // always @(*) begin
    //     counter_next = counter_reg;
    //     r_1khz = 1'b0;
    //     if(counter_reg == 100_000 - 1)begin // 1khz == 100_000_000 / 100_000
    //         counter_next = 0;
    //         r_1khz = 1'b1;
    //     end 
    //     else begin // 1khz tick
    //         counter_next = counter_reg + 1;
    //         r_1khz = 1'b0;
    //     end
    // end
    //--------------------------------------------------------------------------------


    // 여기서부터 찐 debounce 회로----------------------------------------------------------------
    // 강의자료 참고 
    //state logic, shift register
    always @(posedge r_1khz, posedge reset) begin
        if(reset)begin
            q_reg <= 0;
        end
        else begin
            q_reg <= q_next;
        end
    end

    //next logic
    always @(i_btn, r_1khz, q_reg) begin // event i_btn, r_1khz
        //q_reg 현재의 상위 7비트를 다음 하위 7비트에 넣고,
        //최상에는 i_btn을 넣어라
        q_next =  {i_btn, q_reg[7:1]}; //8 shift의 동작 설명
    end

    //8 input AND gate
    assign btn_debounce = &q_reg;

    //edge detector, 100Mhz
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_edge_detect <= 0;
        end
        else begin
            r_edge_detect <= btn_debounce;
        end
    end

    //최종 출력 
    assign o_btn = btn_debounce & (~r_edge_detect);
    //--------------------------------------------------------------------------------

endmodule
