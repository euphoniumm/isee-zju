module sys(in,clk,out);
	input in,clk;
	output out;
	wire q1,q2;
	dffre #(.n(1)) dffre1(.clk(clk),.q(q1),.d(in),.en(1),.r(0));
	dffre #(.n(1)) dffre2(.clk(clk),.q(q2),.d(q1),.en(1),.r(0));
	assign out=q1&&(!q2);
endmodule