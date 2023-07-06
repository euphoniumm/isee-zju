module song_reader(song,clk,reset,note_done,play,song_done,new_note,note,duration);
	input clk,reset,play,note_done;
	input [1:0] song;
	output song_done,new_note;
	output [5:0] note,duration;
	wire [4:0] q;
	wire [1:0] song;
	wire [6:0] addr;
	wire counter_co;
	//控制器
	song_reader_controller song_reader_controller_inst(.clk(clk),.reset(reset),.note_done(note_done),.play(play),.new_note(new_note));
	//地址计数器
	counter_n #(.counter_bits(5),.n(32)) song_reader_counter_32(.clk(clk),.r(reset),.en(note_done),.q(q),.co(counter_co));
	//song_rom
	song_rom song_rom_inst(.clk(clk),.addr({song,q}),.dout({note,duration}));
	//结束判断
	judge_end judge_end_inst(.clk(clk),.in(counter_co||(!duration)),.out(song_done));
endmodule