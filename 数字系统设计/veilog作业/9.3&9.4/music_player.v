module music_player(clk,reset,play_pause,next,NewFrame,sample,play,song);
	parameter sim=0;
	input clk,reset,play_pause,next,NewFrame;
	output play;
	output[15:0] sample;
	output[1:0] song;
	wire song_done,reset_play,note_done,new_note,ready,beat;
	wire[5:0] note,duration;
	
	
	mcu mcu_inst(.play_pause(play_pause),.next(next),.song_done(song_done),.clk(clk),.reset(reset),
	.play(play),.reset_play(reset_play),.song(song));
	
	song_reader song_reader_inst(.clk(clk),.reset(reset_play),.play(play),.song(song),.note_done(note_done),
	.song_done(song_done),.new_note(new_note),.note(note),.duration(duration));
	
	note_player note_player_inst(.sampling_pulse(ready),.play_enable(play),.reset(reset_play),
	.note_to_load(note),.clk(clk),.load_new_note(new_note),.beat(beat),.duration_to_load(duration),
	.sample(sample),.note_done(note_done),.sample_ready());

	sys sys_inst(.in(NewFrame),.clk(clk),.out(ready));

	counter_n #(.counter_bits(sim?6:10),.n(sim?64:1000))counter_n_inst(.r(0),.en(ready),.clk(clk),.q(),.co(beat));
endmodule