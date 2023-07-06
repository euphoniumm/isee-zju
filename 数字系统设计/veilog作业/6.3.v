module register(in,out,clk);
    parameter n=4;//数据位宽
    input clk;
    input [0:n-1] in;
    output [0:n-1] out;
    always @(posedge clk)
        begin
            out={out[0],out[1:n-1]};
        end
endmodule