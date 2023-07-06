module ex8_3(clk,rst_n,lamb);
input clk;
input rst_n;
output reg [7:0] lamb;

reg [3:0] state;

parameter s0=4'b0000,
          s1=4'b0001,
          s2=4'b0011,
          s3=4'b0010,
          s4=4'b0110,
          s5=4'b0111,
          s6=4'b0101,
          s7=4'b0100,
          s8=4'b1100,
          s9=4'b1101,
          s10=4'b1111,
          s11=4'b1110;

always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
    begin
      state<=s0;
      lamb<=8'b0000_0000; // all off
    end
  else
    begin
      case(state)
        s0:begin                 // 1 mode
             state<=s1;
             lamb<=8'b0000_0000; // all off
           end
        s1:begin
             state<=s2;
             lamb<=8'b1111_1111; // all on
           end
        s2:begin                 // 2 mode
             state<=s3;
             lamb<=8'b1000_0000; // 1st on(from left to right)
           end
        s3:begin
             state<=s4;
             lamb<=8'b0100_0000; // 2nd on
           end
        s4:begin
             state<=s5;
             lamb<=8'b0010_0000; // 3rd on(from left to right)
           end
        s5:begin
             state<=s6;
             lamb<=8'b0001_0000; // 4th on
           end
        s6:begin
             state<=s7;
             lamb<=8'b0000_1000; // 5th on
           end
        s7:begin
             state<=s8;
             lamb<=8'b0000_0100; // 6th on
           end
        s8:begin
             state<=s9;
             lamb<=8'b0000_0010; // 7th on
           end
        s9:begin
             state<=s10;
             lamb<=8'b0000_0001; // 8th on
           end
        s10:begin                // 3 mode
             state<=s11;
             lamb<=8'b0101_0101; // 4 on 4 off
           end
        s11:begin
             state<=s0;
             lamb<=8'b1010_1010; // 4 on 4 off
           end
        default:begin
                  state<=s0;
                  lamb<=8'b0000_0000;
                end
      endcase
    end
end

endmodule