/**********************************************************************
					KEYEXPANSION MODULE
	note: takes in 128 bit key and expand it according to the AES
			standard
***********************************************************************/
module	keyexp	(
/*****  INPUT 																			*/
	/*****	DATA SIGNALS																*/
	input wire				clk,
	input wire				rst_n,
	input wire	[127:0]		key_in,
	input wire	[7:0]		sbox_out,	//data that comes from SBOX module
	input wire	[3:0]		round_in,	//indicating which round the AES is in
/*****	OUTPUT																			*/
	output reg	[127:0]		key_out,
	output reg	[7:0]		sbox_in,	//data that goes into SBOX module for data lookup
	output reg				sbox_en_de_in,		//1: encryption,	0:decryption
	output reg				ce,
	output reg				re,
	output reg				ready_out,

	/*****	CONTROL SIGNALS																*/
	input wire				start_in,
	input wire				en_de			
);

/***************************************************
		REGISTERS
***************************************************/
reg		[127:0]		nxt_key_out, key_temp;
reg					nxt_ready_out;
reg		[2:0]		ctn, nxt_ctn;
reg		[7:0]		rcon;
reg		[31:0]		col_t;

always @ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		key_out 		<=	128'h0;
		ready_out		<=	1'b0;
		ctn				<=	4'h0;
		col_t			<=	32'h0;
	end

	else begin
		key_out			<=	nxt_key_out;
		ready_out		<=	nxt_ready_out;
		ctn				<=	nxt_ctn;
	end
end

/***************************************************
		RCON
***************************************************/
always @ (round_in) begin
	case (round_in)
		1: rcon = (8'h1);
		2: rcon = (8'h2);
		3: rcon = (8'h4);
		4: rcon = (8'h8);
		5: rcon = (8'h10);
		6: rcon = (8'h20);
		7: rcon = (8'h40);
		8: rcon = (8'h80);
		9: rcon = (8'h1b);
		10: rcon = (8'h36);
		default: rcon = 0;
	endcase
end

always @ (start_in or en_de or ctn or key_in or col_t or key_temp) begin

	ce = 0;
	re = 0;
	sbox_in = 8'h0;
	nxt_key_out = 128'h0;
	nxt_ready_out = 1'b0;

	case (ctn)
		0: begin
			if(start_in) begin
				sbox_in = key_in[103:96];
				ce = 1;
				re = 1;
				nxt_ctn = 1;
			end
			else begin
				ce = 1;
				re = 1;
				sbox_in = 0;
				nxt_ctn = 0;
			end
		end

		1: begin
			sbox_in = key_in[71:64];
			col_t[7:0] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = 2;
		end

		2: begin
			sbox_in = key_in[39:32];
			col_t[31:24] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = 3;
		end

		3: begin
			sbox_in = key_in[7:0];
			col_t[23:16] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = 4;
		end

		4: begin
			col_t[15:8] = sbox_out;
			//first column of new key
			key_temp[127:120]	=	col_t[31:24] ^ rcon ^ key_in[127:120];
			key_temp[95:88]		=	col_t[23:16] ^ key_in[95:88];
			key_temp[63:56]		=	col_t[15:8]	 ^ key_in[63:56];
			key_temp[31:24]		=	col_t[7:0]	 ^ key_in[31:24];

			//second column of new key
			key_temp[119:112]	=	key_temp[127:120] ^ key_in[119:112];
			key_temp[87:80]		=	key_temp[95:88]	  ^ key_in[87:80];
			key_temp[55:48]		=	key_temp[63:56]	  ^ key_in[55:48];
			key_temp[23:16]		=	key_temp[31:24]	  ^ key_in[23:16];

			//third column of new key
			key_temp[111:104]	=	key_temp[119:112] ^ key_in[111:104];
			key_temp[79:72]		=	key_temp[87:80]	  ^ key_in[79:72]; 
			key_temp[47:40]		=	key_temp[55:48]	  ^ key_in[47:40];	 
			key_temp[15:8]		=	key_temp[23:16]	  ^ key_in[15:8];	 
			
			//fourth column of new key
			key_temp[103:96]	=	key_temp[111:104] ^ key_in[103:96];
			key_temp[71:64]		=	key_temp[79:72]	  ^ key_in[71:64];	   
			key_temp[39:32]		=	key_temp[47:40]	  ^ key_in[39:32];	   
			key_temp[7:0]		=	key_temp[15:8]	  ^ key_in[7:0];
			
			//
			nxt_ready_out = 1;
			nxt_ctn		  = 0;
			nxt_key_out	  = key_temp;
		end
	endcase

end

endmodule

