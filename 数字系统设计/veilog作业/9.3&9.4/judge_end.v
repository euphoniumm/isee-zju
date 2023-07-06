module judge_end(in,clk,out);
	input in,clk;
	output out;
	wire q;
	dffre #(.n(1)) D(.clk(clk),.q(q),.d(in),.en(1),.r(0));
	assign out=in&&~q;
endmodule



/*状态机写法
module judge_end(clk,co,duration,out);
	parameter PAUSE=1'd0,CONTIUE=1'd1;
	input co,clk;
	input [5:0] duration;
	output reg out;
	reg[1:0] state,next_state;
	
	always @(posedge clk)
	begin
		if(CONTIUE) state=CONTIUE;
		else state=next_state;
	end
	
	always @(*)
	begin
		case(state)
			CONTIUE://输出0
			begin
				out=0;
				if(co||(!duration)) next_state=PAUSE;//当co=1或duration=0时，下一个状态为PASUE
				else next_state=CONTIUE;
			end
			PAUSE://输出1
			begin
				out=1;
				//if(co||(!duration)) next_state=PAUSE;//当co=1或duration=0时，下一个状态为PASUE
				//else 
				next_state=CONTIUE;
			end
		endcase
	end
endmodule
*/