//四位串并转换器
module serial_pal(clk,en,reset,in,out);
input cin,clk,en,reset;
output[3:0] out;
reg[3:0] out;
always @ (posedge clk or negedge reset)
    begin
    if(!reset) 
        cout<=4'b0;
    else if(en)
        cout<={cout[2:0],cin};
    else 
        cout<=cout;
    end
endmodule
//四位并串转换器
module pal_serial(clk,reset,en,in,out);
    input clk,reset,en;
    input[3:0] in;
    output out;
    reg [3:0] tmp;
    always@(posedge clk)
    begin
        if(!reset)
            tmp<=4'h0;
        else if(en)
            tmp[3:0]<=in[3:0];
        else
            tmp[3:0]<={tmp[2:0],1'b0};
    end
    assign out=tmp[3];
endmodule