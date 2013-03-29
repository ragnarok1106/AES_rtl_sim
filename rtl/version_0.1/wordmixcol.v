/**********************************************************************
					WORD MIX COLUMN MODULE
	note: Takes in a word and output a new word according to the
			standard's mixcolumn operation
***********************************************************************/
module	wordmixcol	(
/*****	INPUT															*/
	input wire	[31:0]		col_in,

/*****	OUTPUT															*/
	output wire	[31:0]		en_new_out,
	output wire	[31:0]		de_new_out
);

//internal wires

wire	[7:0]	a, b, c, d;
wire	[7:0]	en_byte1, en_byte2, en_byte3, en_byte4;
wire	[7:0]	de_byte1, de_byte2, de_byte3, de_byte4;

assign	a = col_in[31:24];
assign	b = col_in[23:16];
assign	c = col_in[15:8];
assign	d = col_in[7:0];

bytemixcol	bytemixcol1 (.a (a), .b(b), .c(c), .d(d), .en_new_out(en_byte1), .de_new_out(de_byte1));
bytemixcol	bytemixcol2 (.a (b), .b(c), .c(d), .d(a), .en_new_out(en_byte2), .de_new_out(de_byte2));
bytemixcol	bytemixcol3 (.a (c), .b(d), .c(a), .d(b), .en_new_out(en_byte3), .de_new_out(de_byte3));
bytemixcol	bytemixcol4 (.a (d), .b(a), .c(b), .d(c), .en_new_out(en_byte4), .de_new_out(de_byte4));

assign	en_new_out = {en_byte1, en_byte2, en_byte3, en_byte4};
assign	de_new_out = {de_byte1, de_byte2, de_byte3, de_byte4};

endmodule
