/**********************************************************************
					COLUMNMIX MODULE
	note: In this module, 128 bit data are divded into word size then
			each word goes through a specific transformation stated in
			the standard
***********************************************************************/
module	columnmix (
/*****  INPUT 															*/
	/*****	DATA SIGNALS												*/
	input wire				clk,
	input wire				rst_n,
	input wire	[127:0]		data_in,

/*****  OUTPUT 															*/
	output reg	[127:0]		data_out,
	output reg				ready_out,

	/*****	CONTROL SIGNALS												*/
	input wire				start_in,
	input wire				en_de		
);


/***************************************************
		INTERNAL WIRES
***************************************************/

wire	[31:0]	en_col_out, de_col_out;
wire	[31:0]	new_col_final;
wire	[31:0]	wm_in;

/***************************************************
		REGISTERS
***************************************************/
reg		[127:0]		nxt_data_out;
reg		[1:0]		ctn, nxt_ctn;
reg					nxt_ready_out;
reg		[31:0]		old_col_in;


wordmixcol	wordmixcol1 (
							.col_in		(wm_in),
							.en_new_out	(en_col_out),
							.de_new_out	(de_col_out)
						);

assign	new_col_final = (en_de)	?	en_col_out : de_col_out;
assign	wm_in		  = old_col_in;


always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_out	<=	128'h0;
		ctn			<=	2'h0;
		ready_out	<=	1'b0;
		nxt_data_out<=	128'h0;
	end
	
	else begin
		data_out	<=	nxt_data_out;
		ctn			<=	nxt_ctn;
		ready_out	<=	nxt_ready_out;
	end
end




/***************************************************
		TRANSFORMATION
***************************************************/

always @ (start_in or en_de or ctn or data_in or new_col_final) begin

	nxt_ready_out	= 1'b0;
	old_col_in		= 32'h0;
		
	case(ctn)
		0: begin
			if(start_in) begin
				old_col_in = {data_in[127:120], data_in[95:88], data_in[63:56], data_in[31:24]};
				nxt_data_out[127:120]	= new_col_final[31:24];
				nxt_data_out[95:88]		= new_col_final[23:16];
				nxt_data_out[63:56]		= new_col_final[15:8];
				nxt_data_out[31:24]		= new_col_final[7:0];
				nxt_ctn = 1;
			end
		end

		1: begin
				old_col_in = {data_in[119:112], data_in[87:80], data_in[55:48], data_in[23:16]};
				nxt_data_out[119:112]	= new_col_final[31:24];
				nxt_data_out[87:80]     = new_col_final[23:16];
				nxt_data_out[55:48]     = new_col_final[15:8];
				nxt_data_out[23:16]     = new_col_final[7:0];
				nxt_ctn = 2;
		end

		2: begin
				old_col_in = {data_in[111:104], data_in[79:72], data_in[47:40], data_in[15:8]};
				nxt_data_out[111:104]	= new_col_final[31:24];
				nxt_data_out[79:72]     = new_col_final[23:16];
				nxt_data_out[47:40]     = new_col_final[15:8];
				nxt_data_out[15:8]      = new_col_final[7:0];
				nxt_ctn = 3;
		end

		3: begin
				old_col_in = {data_in[103:96], data_in[71:64], data_in[39:32], data_in[7:0]};
				nxt_data_out[103:96]	= new_col_final[31:24];
				nxt_data_out[71:64]     = new_col_final[23:16];
				nxt_data_out[39:32]     = new_col_final[15:8];
				nxt_data_out[7:0]		= new_col_final[7:0];
				nxt_ctn = 0;
				nxt_ready_out = 1;
		end

		default: begin
			nxt_data_out = nxt_data_out;
			nxt_ctn		 = 0;
		end
	endcase
end

endmodule
