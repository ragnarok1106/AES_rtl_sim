module		top_subbyte (
	//input
	input wire				clk,
	input wire				rst_n,
	input wire	[127:0]		data_in,
	input wire				start_in,
	input wire				en_de,
	
	//output
	output wire	[127:0]		data_out,
	output wire				ready_out
);

//internal wires

	wire	[7:0]	sbox_in;
	wire	[7:0]	sbox_out;
	wire			ce,re;
	
subbyte		aes_subbyte (
							.clk			(clk),
                            .rst_n			(rst_n),
                            .data_in		(data_in),
                            .sbox_out		(sbox_out),	
                            .data_out		(data_out),
                            .sbox_in		(sbox_in),	
                            .sbox_en_de_in	(),	
                            .ce				(ce),
                            .re				(re),
                            .ready_out		(ready_out),
                                            
                            				
                            .start_in		(start_in),
                            .en_de			(en_de)
						);

sbox_rom	aes_sbox	(
							.clk			(clk),
							.addr			(sbox_in),
							.chip_en		(ce),
							.read_en		(re),
							.data			(sbox_out)
						);

endmodule
