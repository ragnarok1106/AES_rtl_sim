/**********************************************************************
					BTYE MIX COLUMN MODULE
	note: Takes in four bytes and output a new byte according to the
			standard's mixcolumn operation
***********************************************************************/
module	bytemixcol	(
/*****	INPUT															*/
	input wire	[7:0]	a,
	input wire	[7:0]	b,
	input wire	[7:0]	c,
	input wire	[7:0]	d,

/*****	OUTPUT															*/
	output wire	[7:0]	en_new_out,
	output wire	[7:0]	de_new_out
);

//internal wires

wire	[7:0]	w1, w2, w3, w4, w5, w6, w7, w8;

xtime	xtime1	(
					.byte_in (w1),
					.byte_out (w4)
				);
xtime	xtime2	(
					.byte_in (w3),
				 	.byte_out (w5)
				);
xtime	xtime3	(	
					.byte_in (w6),
					.byte_out (w7)
				);
xtime	xtime4	(
					.byte_in (w7),
				 	.byte_out (w8)
				);

assign	w1 = a^b;
assign	w2 = a^c;
assign	w3 = c^d;
assign	w6 = w2^w4^w5;

assign	en_new_out = b^w3^w4;
assign	de_new_out = b^w3^w4^w8;

endmodule




