/**********************************************************************
					SUBBTYE MODULE
	note: In this module, 128 bit data are shifted and substituted to
			its appropriate data according to AES standard
***********************************************************************/
module	subbyte (
/*****  INPUT 																			*/
	/*****	DATA SIGNALS																*/
	input wire				clk,
	input wire				rst_n,
	input wire	[127:0]		data_in,
	input wire	[7:0]		sbox_out,	//data that comes from SBOX module

/*****	OUTPUT																			*/
	output reg	[127:0]		data_out,
	output reg	[7:0]		sbox_in,	//data that goes into SBOX module for data lookup
	output reg				sbox_en_de_in,		//1: encryption,	0:decryption
	output reg				ce,
	output reg				re,
	output reg				ready_out,

	/*****	CONTROL SIGNALS																*/
	input wire				start_in,
	input wire				en_de				
);
/*
`define shift_128 \

	nxt_data_out[127:120] =	data_state_t[0]; \
	nxt_data_out[119:112] =	data_state_t[1]; \
    nxt_data_out[111:104] =	data_state_t[2]; \
    nxt_data_out[103:96]  =	data_state_t[3]; \
    nxt_data_out[95:88]   =	data_state_t[5]; \
    nxt_data_out[87:80]   =	data_state_t[6]; \
    nxt_data_out[79:72]   =	data_state_t[7]; \
    nxt_data_out[71:64]   =	data_state_t[4]; \
    nxt_data_out[63:56]   =	data_state_t[10]; \
    nxt_data_out[55:48]   =	data_state_t[11]; \
    nxt_data_out[47:40]   =	data_state_t[8]; \
    nxt_data_out[39:32]   =	data_state_t[9]; \
    nxt_data_out[31:24]   =	data_state_t[15]; \
    nxt_data_out[23:16]   =	data_state_t[12]; \
    nxt_data_out[15:8]    =	data_state_t[13]; \
    nxt_data_out[7:0]     =	data_state_t[14];

`define inverse_shift_128 \
	nxt_data_out[127:120] =	data_state_t[0];	\
    nxt_data_out[119:112] =	data_state_t[1];	\
    nxt_data_out[111:104] =	data_state_t[2];	\
    nxt_data_out[103:96]  =	data_state_t[3];	\
    nxt_data_out[95:88]   =	data_state_t[7];	\
    nxt_data_out[87:80]   =	data_state_t[4];	\
    nxt_data_out[79:72]   =	data_state_t[5];	\
    nxt_data_out[71:64]   =	data_state_t[6];	\
    nxt_data_out[63:56]   =	data_state_t[10];	\
    nxt_data_out[55:48]   =	data_state_t[11];	\
    nxt_data_out[47:40]   =	data_state_t[8];	\
    nxt_data_out[39:32]   =	data_state_t[9];	\
    nxt_data_out[31:24]   =	data_state_t[13];	\
    nxt_data_out[23:16]   =	data_state_t[14];	\
    nxt_data_out[15:8]    =	data_state_t[15];	\
    nxt_data_out[7:0]     =	data_state_t[12];
*/

/***************************************************
		REGISTERS
***************************************************/
reg		[127:0]		nxt_data_out, data_temp;
reg					nxt_ready_out;
reg		[4:0]		ctn, nxt_ctn;

always @ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		data_out 	<=	128'h0;
		data_temp	<=	128'h0;
		ready_out	<=	1'b0;
		ctn			<=	4'h0;
	end

	else begin
		data_out 	<=	nxt_data_out;
		ready_out	<=	nxt_ready_out;
		ctn			<=	nxt_ctn;
	end
end

/***************************************************
		TRANSFORMATION
***************************************************/

always @ (start_in or en_de or ctn or data_in) begin

	ce = 0;
	re = 0;
	sbox_in = 8'h0;
	nxt_data_out = 128'h0;
	nxt_ready_out = 1'b0;
	

	case(ctn)
		0: begin
			if(start_in) begin
				sbox_in = data_in[127:120];
				ce = 1;
				re = 1;
				nxt_ctn = 1;
			end
			else begin
				ce = 0;
				re = 0;
				sbox_in = 0;
				nxt_ctn = 0;
			end
		end
		
		1:	begin
			sbox_in = data_in[119:112];
			data_temp[127:120] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		2:	begin
			sbox_in = data_in[111:104];
			data_temp[119:112] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end
			
		3:	begin
			sbox_in = data_in[103:96];
			data_temp[111:104] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end
			
			
		4:	begin
			sbox_in = data_in[95:88];
			data_temp[103:96] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		5:	begin
			sbox_in = data_in[87:80];
			data_temp[95:88] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end


		6:	begin
			sbox_in = data_in[79:72];
			data_temp[87:80] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		7:	begin
			sbox_in = data_in[71:64];
			data_temp[79:72] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		8:	begin
			sbox_in = data_in[63:56];
			data_temp[71:64] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		9:	begin
			sbox_in = data_in[55:48];
			data_temp[63:56] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		10:	begin
			sbox_in = data_in[47:40];
			data_temp[55:48] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		11:	begin
			sbox_in = data_in[39:32];
			data_temp[47:40] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		12:	begin
			sbox_in = data_in[31:24];
			data_temp[39:32] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end


		13:	begin
			sbox_in = data_in[23:16];
			data_temp[31:24] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end


		14:	begin
			sbox_in = data_in[15:8];
			data_temp[23:16] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		15:	begin
			sbox_in = data_in[7:0];
			data_temp[15:8] = sbox_out;
			ce = 1;
			re = 1;
			nxt_ctn = ctn+1;
		end

		16: begin
			data_temp[7:0] = sbox_out;
			nxt_ctn = 0;
			if(en_de) begin
				nxt_data_out[127:120] =	data_temp[127:120];
				nxt_data_out[119:112] =	data_temp[119:112];
    			nxt_data_out[111:104] =	data_temp[111:104];
    			nxt_data_out[103:96]  =	data_temp[103:96]; 
    			nxt_data_out[95:88]   =	data_temp[87:80];
    			nxt_data_out[87:80]   =	data_temp[79:72];
    			nxt_data_out[79:72]   =	data_temp[71:64];
    			nxt_data_out[71:64]   =	data_temp[95:88];
    			nxt_data_out[63:56]   =	data_temp[47:40];
    			nxt_data_out[55:48]   =	data_temp[39:32];
    			nxt_data_out[47:40]   =	data_temp[63:56];
    			nxt_data_out[39:32]   =	data_temp[55:48];
    			nxt_data_out[31:24]   =	data_temp[23:16];
    			nxt_data_out[23:16]   =	data_temp[15:8] ;
    			nxt_data_out[15:8]    =	data_temp[7:0]  ;
    			nxt_data_out[7:0]     =	data_temp[31:24];
			end
			else begin
				nxt_data_out[127:120] =	data_temp[127:120];
                nxt_data_out[119:112] =	data_temp[119:112];
                nxt_data_out[111:104] =	data_temp[111:104];
                nxt_data_out[103:96]  =	data_temp[103:96];
                nxt_data_out[95:88]   =	data_temp[71:64];
                nxt_data_out[87:80]   =	data_temp[95:88];
                nxt_data_out[79:72]   =	data_temp[87:80];
                nxt_data_out[71:64]   =	data_temp[79:72];
                nxt_data_out[63:56]   =	data_temp[47:40];
                nxt_data_out[55:48]   =	data_temp[39:32];
                nxt_data_out[47:40]   =	data_temp[63:56];
                nxt_data_out[39:32]   =	data_temp[55:48];
                nxt_data_out[31:24]   =	data_temp[7:0];
                nxt_data_out[23:16]   =	data_temp[31:24];
                nxt_data_out[15:8]    =	data_temp[23:16];
                nxt_data_out[7:0]     =	data_temp[15:8]; 
			end
			nxt_ready_out = 1;
		end
		
		default: begin
			data_temp = data_temp;
			nxt_ctn = 0;
		end

	endcase
end


endmodule
