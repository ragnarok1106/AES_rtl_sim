
/**********************************************************************
					ADD ROUNDKEY LOGIC
	note: takes in key expanded new key value and XOR with transformed
			data
***********************************************************************/
module	addroundkey	(
/*****  INPUT 																			*/
	/*****	DATA SIGNALS																*/
	input wire	[127:0]		ori_data_in,
	input wire	[127:0]		new_data_in,
	input wire	[127:0]		key_in,
	input wire	[3:0]		round_in,	//indicating which round the AES is in

/*****	OUTPUT																			*/
	output wire	[127:0]		data_out,	

	/*****	CONTROL SIGNALS																*/
	input wire				ark_en
);

//internal wires
wire	[127:0]	 	data_temp

	assign data_temp = 	(round_in == 0)	?	ori_data_in ^ key_in : new_data_in ^ key_in;
	assign data_out	 =	(ark_en == 1)	?	data_temp : 128'h0;

endmodule

