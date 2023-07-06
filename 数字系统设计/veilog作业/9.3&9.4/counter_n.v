module counter_n(clk,r,en,q,co);
	parameter n=2;//进制
	parameter counter_bits=1;//位数
	input clk,r,en;
	output co;
	output [counter_bits-1:0] q;
	reg [counter_bits-1:0] q=0;
	always @(posedge clk)
	begin
		if(r) q=0;//置零
		else if(!en) q=q;//保持
		else q=(q+1)%n;//计数
	end
	assign co=(q==(n-1))&&en;
endmodule