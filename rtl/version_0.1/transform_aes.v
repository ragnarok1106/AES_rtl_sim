/**********************************************************************
					TRANSFORMATION MODULE
	note: All the transformation modules in one
***********************************************************************/
module	transform_aes	(
/*****  INPUT 																			*/
	/*****	DATA SIGNALS																*/
	input wire				clk,
	input wire				rst_n,
	input wire	[127:0]		data_in,
	input wire	[127:0]		key_in,
	input wire	[3:0]		round_in,

/*****	OUTPUT																			*/
	output wire	[127:0]		data_out,
	output wire				sub_ready_out,
	output wire				colmix_ready_out,

	/*****	CONTROL SIGNALS																*/
	input wire				en_de,
	input wire				sub_start_in,
	input wire				colmix_start_in,
	input wire				ark_en
);

//internal wire
wire	[127:0]		colmix_data_in;
wire	[127:0]		addroundkey_in;

top_subbyte	subbyte_t		(
								.clk			(clk),
                                .rst_n			(rst_n),
                                .data_in		(data_out),
                                .start_in		(sub_start_in),
                                .en_de			(en_de),
                                .data_out		(colmix_data_in),
                                .ready_out		(sub_start_in)
							);

columnmix	columnmix_t		(
								.clk			(clk),
                                .rst_n			(rst_n),
                                .data_in		(colmix_data_in),
                                .data_out		(addroundkey_in),
                                .ready_out		(colmix_ready_out),
                                .start_in		(colmix_start_in),
								.en_de			(en_de)		
							);

addroundkey	addroundkey_t	(
								.ori_data_in	(data_in),
                                .new_data_in	(addroundkey_in),
                                .key_in			(key_in),
                                .round_in		(round_in),	
                                .data_out		(data_out),
								.ark_en			()
							);

endmodule
