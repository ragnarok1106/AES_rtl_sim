module ENC_WORD_MIXCOL(
//input
	input wire	[31:0]	word_in,

//output

	output wire	[31:0]	word_out
);

wire [7:0] S0, S1, S2, S3;


assign	S0 = word_in[31:24];
assign	S1 = word_in[23:16];
assign	S2 = word_in[15:8];
assign	S3 = word_in[7:0];

ENC_BYTE_MIXCOL	NEW_STATE1(
	.S0_in		(S0),
	.S1_in		(S1),
	.S2_in		(S2),
	.S3_in		(S3),
	.SNEW_out	(word_out[31:24])
);

ENC_BYTE_MIXCOL	NEW_STATE2(
	.S0_in		(S1),
	.S1_in		(S2),
	.S2_in		(S3),
	.S3_in		(S0),
	.SNEW_out	(word_out[23:16])
);

ENC_BYTE_MIXCOL	NEW_STATE3(
	.S0_in		(S2),
	.S1_in		(S3),
	.S2_in		(S1),
	.S3_in		(S0),
	.SNEW_out	(word_out[15:8])
);

ENC_BYTE_MIXCOL	NEW_STATE4(
	.S0_in		(S3),
	.S1_in		(S0),
	.S2_in		(S1),
	.S3_in		(S2),
	.SNEW_out	(word_out[7:0])
);

endmodule
