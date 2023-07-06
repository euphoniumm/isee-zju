module complement(in,out);
    input [0:7] in;
    output [0:7] out;
    assign out=in[7]?({1,~in[0:6]}+1):(in);
endmodule