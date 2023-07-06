module note_player_controller(clk,reset,play_enable,load_new_note,load,time_clear,time_done,note_done);
	parameter RESET=2'd0,WAIT=2'd1,DONE=2'd2,LOAD=2'd3;
	input clk,reset,play_enable,load_new_note,time_done;
	output reg load,time_clear,note_done;
	reg [1:0]state,next_state;
	
	always @(posedge clk)
	begin
		if(reset) state=RESET;
		else state=next_state;
	end
	
	always @(*)
	begin
		case(state)
			RESET:
			begin
				time_clear=1;
				load=0;
				note_done=0;
				next_state=WAIT;
			end
			WAIT:
			begin
				time_clear=0;
				load=0;
				note_done=0;
				if(!play_enable) next_state=RESET;
				else if(time_done) next_state=DONE;
				else if(load_new_note) next_state=LOAD;
				else next_state=WAIT;
			end
			DONE:
			begin
				time_clear=1;
				load=0;
				note_done=1;
				next_state=WAIT;
			end
			LOAD:
			begin
				time_clear=1;
				load=1;
				note_done=0;
				next_state=WAIT;
			end
		endcase
	end
endmodule