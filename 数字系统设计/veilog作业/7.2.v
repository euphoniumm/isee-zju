//结构描述
module JK_trigger(J,K,clk,q);
    input J,K,clk;
    output reg q;
    always @(posedge clk)
    begin
        case({j,k})            
            2'b00:  q=q;
            2'b01:  q=0;
            2'b10:  q=1;
            2'b11:  q=~q;
        endcase
    end
endmodule

//行为描述
module JK_trigger(J,K,clk,q);
    input J,K,clk;
    output q;
    assign q=(J && (~q)) || ((~k) && q);
endmodule