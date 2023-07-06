//比较器
module comp(a,b,agb,aeb,alb);
	parameter n;
	input [n-1:0] a,b;
	output agb;
	output aeb;
	output alb;
	reg agb,aeb,alb;
always @(a or b)
	begin 
		if(a>b) begin agb=1;aeb=0;alb=0;end
		if(a==b) begin agb=0;aeb=1;alb=0;end
		if(a<b) begin agb=0;aeb=0;alb=1;end
	end
endmodule
//全加器
module fulladder_n(a,b,s,ci,co);
	parameter n=4;
	input [n-1:0] a,b;
	output [n-1:0] s;
	input ci;
	output wire co;
	integer i;
	reg [n-1:0] s;
	reg [n:0] c;
	assign co=c[n];
	always @(*)
	begin
		c[0]=ci;
		for(i=0;i<=n-1;i=i+1)
			begin
				s[i]=a[i]^b[i]^c[i];
				c[i+1]=a[i]&&b[i] || a[i]&&c[i] || b[i]&&c[i];
			end
	end
endmodule
//数据选择器
module mux_4to1(in1,in2,in3,in0,sel,out);
	input in1,in2,in3,in0;
	input [0:1] sel;
	output out;
	assign out=sel[1]?(sel[0]?in3:in2):(sel[0]?in1:in0);
endmodule
//计数器
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
//D触发器
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