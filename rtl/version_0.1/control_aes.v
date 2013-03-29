/**********************************************************************
					TRANSFORMATION MODULE
	note: All the transformation modules in one
***********************************************************************/
module	control_aes	(
/*****  INPUT 																			*/
	input wire			clk,
	input wire			rst_n,
	input wire			sub_ready_in,
	input wire			mixcol_ready_in,
	input wire			keyexp_ready_in,
	input wire			en_de,
	input wire			aes_start_in,

/*****	OUTPUT																			*/
	output reg			sub_start_out,
	output reg			mixcol_start_out,
	output reg			keyexp_ready_out,
	output reg	[3:0]	round,
	output reg			aes_done,
	output reg			ark_en
);

//registers
reg			nxt_sub_so, nxt_mixcol_so, nxt_keyexp_so, nxt_aes_done, nxt_ark_en;
reg	[3:0]	nxt_round;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		sub_start_out 		<= 0;
		mixcol_start_out 	<= 0;
		keyexp_ready_out	<= 0;
		round				<= 0;
		aes_done			<= 0;
		ark_en				<= 0;
	end

	else begin
		sub_start_out		<=nxt_sub_so;
		mixcol_start_out	<=nxt_mixcol_so;
		keyexp_ready_out	<=nxt_keyexp_so;
		round				<=nxt_round;
		aes_done			<=nxt_aes_done;
		ark_en				<=nxt_ark_en;
	end
end

//

always @ (sub_ready_in or mixcol_ready_in or keyexp_ready_in or en_de or aes_start_in or round) begin
	nxt_sub_so = 0;
	nxt_mixcol_so = 0;
	nxt_keyexp_so = 0;
	nxt_aes_done = 0;

	case(round)
		0: begin
			if(aes_start_in) begin
				ark_en = 1;
	

