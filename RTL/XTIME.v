module XTIME(
//input
	input wire	[7:0]	byte_in,

//output
	output wire	[7:0]	byte_out
);


	assign byte_out[7:5] = byte_in[6:4];
	assign byte_out[4] = byte_in[3] ^ byte_in[7];
	assign byte_out[3] = byte_in[2] ^ byte_in[7];
	assign byte_out[2] = byte_in[1] ^ byte_in[7];
	assign byte_out[1] = byte_in[0];
	assign byte_out[0] = byte_in[7];

endmodule
