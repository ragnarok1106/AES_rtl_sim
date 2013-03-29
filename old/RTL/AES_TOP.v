module AES_TOP (
//INPUT
	input wire				clk,
	input wire				rst,
	input wire				load_in,
	input wire	[127:0]		plain_text_in,
	input wire	[127:0]		key_in,
	
//OUTPUT
	output reg				ready_out,
	output reg	[127:0]		cipher_out
);

//INTERNAL WIRES
	//DATA WIRES
	wire		[127:0]		KS_IN;
	wire		[127:0]		KS_OUT;
	wire		[127:0]		SS_OUT;
	wire		[127:0]		MC_OUT;
	wire		[127:0]		ARK_IN;
	wire		[127:0]		ARK_OUT;
	wire		[7:0]		SBOX_SS_IN;
	wire		[7:0]		SBOX_SS_OUT;
	wire		[7:0]		SBOX_KS_IN;
	wire		[7:0]		SBOX_KS_OUT;
	wire					ARK_FINISH_OUT;
	
	//CONTORL WIRES
	wire		[3:0]		ROUND_IN;
	wire					SS_START_IN;
	wire					MC_START_IN;
	wire					KS_START_IN;
	wire					ARK_START_IN;
	wire					SS_READY_OUT;
	wire					MC_READY_OUT;
	wire					KS_READY_OUT;
	wire					ARK_READY_OUT;
	wire					ARK_DONE_OUT;
	wire					KS_SEL;
	wire		[2:0]		ARK_IN_SEL;

assign	KS_IN = (KS_SEL) ? KS_OUT : key_in;
		/********************************************
		*	KS_SEL = 0	 input original key//		*
		*			 1	 newly generated key from	*
		*			 	 key schedule//				*
		********************************************/

MUX3to1	#(128)	ARK_OP_MUX (
							.DI0		(plain_text_in),
							.DI1		(SS_OUT),
							.DI2		(MC_OUT),
							.SEL		(ARK_IN_SEL),
							.DO			(ARK_IN)
						);
		/********************************************
		*	KS_SEL = 001	output from plaintext	*
		*			 010	output from SS			*
		*			 100	output from	MC			*
		********************************************/

SUBBYTE		ss_unit (
						.clk			(clk),
						.rst			(rst),
						.start_in		(SS_START_IN),
						.sbox_data_in	(SBOX_SS_IN),
						.data_in		(ARK_OUT),
						.sbox_data_out	(SBOX_SS_OUT),
						.data_out		(SS_OUT),
						.ready_out		(SS_READY_OUT),
						.ce				(SS_CE),
						.re				(SS_RE)
					);
						
SBOX_ROM	sbrom1(
						.clk 		(clk),
						.addr 		(SBOX_SS_OUT),
						.chip_en 	(SS_CE),
						.read_en 	(SS_RE),
						.data 		(SBOX_SS_IN)
				);
KEY_SCHEDULE	ks_unit (
							.clk			(clk),
							.rst			(rst),
							.start_in		(KS_START_IN),
							.round_in		(ROUND_IN),
							.last_key_in	(KS_IN),
							.sbox_data_in	(SBOX_KS_IN),
							.new_key_out	(KS_OUT),
							.ready_out		(KS_READY_OUT),
							.sbox_data_out	(SBOX_KS_OUT),
							.ce				(KS_CE),
							.re				(KS_RE)
						);

SBOX_ROM	sbrom2(
						.clk 		(clk),
						.addr 		(SBOX_KS_OUT),
						.chip_en 	(KS_CE),
						.read_en 	(KS_RE),
						.data 		(SBOX_KS_IN)
				);

MIXCOL		mc_unit(
						.clk		(clk),
						.rst		(rst),
						.data_in	(SS_OUT),
						.start_in	(MC_START_IN),
						.data_out	(MC_OUT),
						.ready_out	(MC_READY_OUT)
				);

ROUNDADD	ark_unit(
						.clk			(clk),
						.rst			(rst),
						.data_in		(ARK_IN),
						.key_in			(key_in),
						.ksch_key_in	(KS_OUT),
						.start_in		(ARK_START_IN),
						.round_in		(ROUND_IN),
						.data_out		(ARK_OUT),
						.ready_out		(ARK_READY_OUT),
						.done_out		(ARK_DONE_OUT)
					);

CONTROL_UNIT	ctrl_unit(
							.clk			(clk),
							.rst			(rst),
							.load_in		(load_in),
							.ss_ready_in	(SS_READY_OUT),
							.mc_ready_in	(MC_READY_OUT),
							.ks_ready_in	(KS_READY_OUT),
							.ark_ready_in	(ARK_READY_OUT),
							.round_out		(ROUND_IN),
							.ss_start_out	(SS_START_IN),
							.mc_start_out	(MC_START_IN),
							.ark_start_out	(ARK_START_IN),
							.ks_start_out	(KS_START_IN),
							.key_sel		(KS_SEL),
							.ark_in_sel		(ARK_IN_SEL)
						);



always @ (ARK_DONE_OUT) begin
	if (ARK_DONE_OUT) begin
		cipher_out = ARK_OUT;
		ready_out = ARK_DONE_OUT;
	end
	else begin
		cipher_out = 128'b0;
		ready_out = 0;
	end
end



endmodule
