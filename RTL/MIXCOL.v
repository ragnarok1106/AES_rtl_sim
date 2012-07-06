module MIXCOL(
//input
	input wire			clk,
	input wire			rst,
	input wire	[127:0]	data_in,
	input wire			start_in,
	//input wire			decrypt_in,

//output
	output reg	[127:0]	data_out,
	output reg			ready_out
);

reg	[3:0]	state, next_state;
reg [127:0]	next_data_out;
reg			next_ready_out;

reg	 [31:0] mix_word_in;
wire [31:0] mix_word_out;


ENC_WORD_MIXCOL	NEW_COL1(
	.word_in	(mix_word_in),
	.word_out	(mix_word_out)
);



always @ (posedge clk or negedge rst) begin

	if (!rst) begin
		data_out = 0;
		ready_out = 0;
		state = 0;
	end

	else begin
		data_out = next_data_out;
		ready_out = next_ready_out;
		state = next_state;
	end
end		//always end


always @ (start_in or state or data_in or data_out) begin

	next_ready_out = 0;
	mix_word_in = 0;
	case (state)
		0: begin
			if(start_in) begin
				mix_word_in[31:24] = data_in[127:120];
				mix_word_in[23:16] = data_in[95:88];
				mix_word_in[15:8] =  data_in[63:56];
				mix_word_in[7:0] = 	 data_in[31:24];
				next_data_out[127:120] =  mix_word_out[31:24];				
				next_data_out[95:88] = 	 mix_word_out[23:16];
                next_data_out[63:56] = 	 mix_word_out[15:8];
                next_data_out[31:24] = 	 mix_word_out[7:0];
				next_state = 1;
			end
		end

		1: begin
			mix_word_in[31:24] = data_in[119:112];
			mix_word_in[23:16] = data_in[87:80];
			mix_word_in[15:8] =  data_in[55:48];
			mix_word_in[7:0] =	 data_in[23:16];
			next_data_out[119:112] =  mix_word_out[31:24];				
			next_data_out[87:80] = 	 mix_word_out[23:16];
            next_data_out[55:48] = 	 mix_word_out[15:8];
            next_data_out[23:16] = 	 mix_word_out[7:0];
			next_state = 2;
		end

		2: begin
			mix_word_in[31:24] = data_in[111:104];
			mix_word_in[23:16] = data_in[79:72];
			mix_word_in[15:8] =  data_in[47:40];
			mix_word_in[7:0] =	 data_in[15:8];
			next_data_out[111:104] =  mix_word_out[31:24];				
			next_data_out[79:72] = 	 mix_word_out[23:16];
            next_data_out[47:40] = 	 mix_word_out[15:8];
            next_data_out[15:8]  = 	 mix_word_out[7:0];
			next_state = 2;
		end

		3: begin
			mix_word_in[31:24] = data_in[103:96];
			mix_word_in[23:16] = data_in[71:64];
			mix_word_in[15:8] =  data_in[39:32];
			mix_word_in[7:0] =	 data_in[7:0];
			next_data_out[103:96] =  mix_word_out[31:24];				
			next_data_out[71:64] = 	 mix_word_out[23:16];
            next_data_out[39:32] = 	 mix_word_out[15:8];
            next_data_out[7:0]   = 	 mix_word_out[7:0];
			next_state = 0;
			next_ready_out = 1;
		end
		
		default: begin
		end

	endcase
end

endmodule

