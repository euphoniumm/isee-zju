module dffre(r,en,clk,q,d);
	parameter n=1;
	input en,clk,r;
	input [n-1:0] d;
	output [n-1:0] q;
	reg [n-1:0] q;
	always @(posedge clk)
	begin
		if(r==1) q=0;
		else if(en==1) q=d;
	end
endmodule