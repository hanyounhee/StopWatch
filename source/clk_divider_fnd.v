module clk_divider_fnd #(parameter FCOUNT = 250_000)(
    input clk,
    input reset,
    output o_clk
    );
    
    // parameter FCOUNT = 500_000;//200hz-->7-segment

    reg [$clog2(FCOUNT):0] r_counter;
    reg r_o_clk;


    assign o_clk = r_o_clk;
    
    always @(posedge clk, posedge reset) 
    begin
        if(reset)
        begin
            r_counter <= 0;
            r_o_clk <= 0;
        end

        else
        begin
            if(r_counter == FCOUNT - 1)// 100Mhz를 200hz로 변환
            begin //clk divide 계산
                r_counter <= 0;
                r_o_clk <= 1;
            end//-__________-__________-__________이런식의 duty 비가 안좋은 클락생성됨 --> interupt에서 응용하기 좋은 클락임

            else
            begin
                r_counter <= r_counter + 1;
                r_o_clk <= 0; //r_clk을 0으로 유지
            end
        end
    end
endmodule
