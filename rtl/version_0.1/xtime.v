/**********************************************************************
					XTIME LOGIC
	note: The logic multiplies input byte by {02} and modulus m(x)
			this module is used in mixcolumn transformation
***********************************************************************/
module xtime	(
/*****  INPUT 																			*/
	input wire	[7:0]	byte_in,

/*****  OUTPUT 																			*/
	output wire	[7:0]	byte_out
);

//internal wire

wire	[3:0]	xtime_temp;

assign	xtime_temp[3]	=	byte_in[7];
assign	xtime_temp[2]	=	byte_in[7];
assign	xtime_temp[1]	=	1'b0;
assign	xtime_temp[0]	=	byte_in[7];

assign	byte_out[7:5]	=	byte_in[6:4];
assign	byte_out[4:1]	=	xtime_temp ^ byte_in[3:0];
assign	byte_out[0]		=	byte_in[7];

endmodule
