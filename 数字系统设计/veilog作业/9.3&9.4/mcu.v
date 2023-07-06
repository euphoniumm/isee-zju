module mcu(play_pause,next,song_done,reset,clk,song,play,reset_play);
	input play_pause,next,song_done,clk,reset;
	output play,reset_play;
	output [1:0] song;
	wire NextSong;
	//控制器
	mcu_controller mcu_controller_inst(.play_pause(play_pause),.next(next),.song_done(song_done),.reset(reset),.clk(clk),.play(play),.reset_play(reset_play),.NextSong(NextSong));
	//计数器
	counter_n #(.counter_bits(2),.n(4)) mcu_counter_4(.clk(clk),.r(reset),.en(NextSong),.q(song),.co());
endmodule