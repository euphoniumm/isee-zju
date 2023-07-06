module counter_8(clk,r,q);
    parameter counter_bits=8,n=256;
    input clk,r;
    output reg [0:7] q;
    always @(posedge clk)
        begin
            if(r) q=0;
            else q=(q+1)%n;
        end
endmodule