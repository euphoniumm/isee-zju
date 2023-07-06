module dds(k,clk,reset,sampling_pulse,sample,new_sample_ready);
	input clk,reset,sampling_pulse;
	input [21:0] k;
	wire [21:0] raw_addr,d;
	wire area;
	wire [21:0] rom_addr;
	wire [15:0] raw_data,data;
	output [15:0] sample;
	output new_sample_ready;
	
// fulladder + D1
	fulladder_n #(.n(22))Adder(.a(k),.b(raw_addr),.ci(0),.s(d),.co());
	dffre #(.n(22))D1(.r(reset),.en(sampling_pulse),.clk(clk),.d(d),.q(raw_addr));

// D2
	dffre #(.n(1))D2(.r(0),.en(1),.clk(clk),.d(raw_addr[21]),.q(area));

// handle the address
/*	always @(*)
		begin
			if(raw_addr[20]==0) rom_addr=raw_addr[19:10];
			else if(raw_addr[20:10]==1024) rom_addr=~raw_addr[19:10]+1;
		end
*/
	assign rom_addr=(raw_addr[20])?((raw_addr[20:10]==1024)?1023:(~raw_addr[19:10]+1)):raw_addr[19:10];
// output raw_data
	sine_rom sine(.clk(clk),.addr(rom_addr),.dout(raw_data));
	
// handle the data
	assign data=((area)?(~raw_data[15:0]+1):raw_data[15:0]);
	
// output
	dffre #(.n(16))D3(.clk(clk),.d(data),.en(sampling_pulse),.r(0),.q(sample));
	dffre #(.n(1))D4(.clk(clk),.d(sampling_pulse),.r(0),.en(1),.q(new_sample_ready));
endmodule