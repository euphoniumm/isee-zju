module note_player(sampling_pulse, play_enable, reset, note_to_load, clk, load_new_note, beat, duration_to_load, sample, note_done,sample_ready);
	input sampling_pulse, play_enable, reset, clk, load_new_note, beat;
	input [5:0]note_to_load, duration_to_load;
	output note_done,sample_ready;
	output [15:0]sample;
	wire load,time_clear,time_done;
	wire [5:0]addr;
	wire [19:0]dout;
	
	//触发器
	dffre #(.n(6)) note_player_D(.r(~play_enable||reset),.d(note_to_load),.clk(clk),.en(load),.q(addr));
	//控制器
	note_player_controller note_player_controller_inst(.clk(clk),.reset(reset),.play_enable(play_enable),.load_new_note(load_new_note),.load(load),.time_clear(time_clear),.time_done(time_done),.note_done(note_done));
	//FreROM
	frequency_rom frequency_rom_inst(.clk(clk),.addr(addr),.dout(dout));
	//音符节拍定时器
	counter_np #(.counter_bits(6)) note_player_counter_inst(.clk(clk),.en(beat),.r(time_clear),.n(duration_to_load),.co(time_done),.q());
	//DDS
	dds dds_inst(.sampling_pulse(sampling_pulse),.clk(clk),.k({2'b00,dout}),.reset(reset),.sample(sample),.new_sample_ready(sample_ready));
endmodule