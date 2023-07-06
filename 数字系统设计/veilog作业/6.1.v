module mux_4to1(in1,in2,in3,in0,sel,out);
	input in1,in2,in3,in0;
	input [0:1] sel;
	output out;
	assign out=sel[1]?(sel[0]?in3:in2):(sel[0]?in1:in0);
endmodule