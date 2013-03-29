module	top_keyexp (	
	//input
	input wire				clk,
	input wire				rst_n,
	input wire	[127:0]		key_in,
	input wire				start_in,
	input wire				en_de,
	input wire	[3:0]		round_in,
	
	//output
	output wire	[127:0]		key_out,
	output wire				ready_out
);

//internal wires

	wire	[7:0]	sbox_in;
	wire	[7:0]	sbox_out;
	wire			ce,re;

keyexp	aes_keyexp (
					.clk			(clk),
                    .rst_n			(rst_n),
                    .key_in			(key_in),
                    .sbox_out		(sbox_out),
                    .round_in		(round_in),
                    .key_out		(key_out),
                    .sbox_in		(sbox_in),
                    .sbox_en_de_in	(),	
                    .ce				(ce),
                    .re				(re),
                    .ready_out		(ready_out),
                    .start_in		(start_in),
                    .en_de			(en_de)
				);			

sbox_rom	aes_sbox2	(
							.clk			(clk),
							.addr			(sbox_in),
							.chip_en		(ce),
							.read_en		(re),
							.data			(sbox_out)
						);


endmodule
