module mcu_controller(play_pause,next,song_done,clk,reset,play,reset_play,NextSong);
	input play_pause,next,song_done,clk,reset;
	output reg play,reset_play,NextSong;
	parameter RESET=2'd0,PAUSE=2'd1,PLAY=2'd2,NEXT=2'd3;
	reg[1:0] state,next_state;
	
	always @(posedge clk)
	begin
		if(reset) state=RESET;
		else state=next_state;
	end
	
	always @(*)//状态控制
	begin
		case(state)
			RESET:
			begin
				{play,NextSong,reset_play}=3'b001;
				next_state=PAUSE;
			end
			PAUSE:
			begin
				{play,NextSong,reset_play}=3'b000;
				if(play_pause) next_state=PLAY;
				else if(next) next_state=NEXT;
				else next_state=PAUSE;
			end
			PLAY:
			begin
				{play,NextSong,reset_play}=3'b100;
				if(play_pause) next_state=PAUSE;
				else if(next) next_state=NEXT;
				else if(song_done) next_state=RESET;
				else next_state=PLAY;
			end
			NEXT:
			begin
				{play,NextSong,reset_play}=3'b011;
				next_state=PLAY;
			end
		endcase
	end
endmodule