module ENC_BYTE_MIXCOL(
//inputs
	input wire	[7:0]	S0_in,
	input wire	[7:0]	S1_in,
	input wire	[7:0]	S2_in,
	input wire	[7:0]	S3_in,
	//input wire		decrypt_in,
//output
	output wire [7:0]	SNEW_out
);

	wire	[7:0]	S0_xtime;
	wire	[7:0]	S1_xtime;

	XTIME xtime1(
		.byte_in	(S0_in),
		.byte_out	(S0_xtime)
	);

	XTIME xtime2(
		.byte_in	(S1_in),
		.byte_out	(S1_xtime)
	);
		
assign SNEW_out = S0_xtime ^ S1_xtime ^ S1_in ^ S2_in ^ S3_in;



endmodule

