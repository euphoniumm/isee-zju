module song_reader_controller(clk,reset,note_done,play,new_note);
	input clk, reset, note_done, play;
	output reg new_note;
	parameter RESET=2'd0, NEW_NOTE=2'd1, WAIT=2'd2, NEXT_NOTE=2'd3;
	reg [1:0] state, next_state;
	
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
				new_note=0;
				if(play) next_state=NEW_NOTE;
				else next_state=RESET;
			end
			NEW_NOTE:
			begin
				new_note=1;
				next_state=WAIT;
			end
			WAIT:
			begin
				new_note=0;
				if(!play) next_state=RESET;
				else if(note_done) next_state=NEXT_NOTE;
				else next_state=WAIT;
			end
			NEXT_NOTE:
			begin
				new_note=0;
				next_state=NEW_NOTE;
			end
		endcase
	end
endmodule