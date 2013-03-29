module SUBBYTE(
//input
	input wire 			clk,
	input wire 			rst,
	//input wire			decrypt_in,
	input wire 			start_in,
	input wire [7:0]	sbox_data_in,
	input wire [127:0]  data_in,
//output
	output reg [7:0]	sbox_data_out,
	output reg [127:0]  data_out,
	output reg			ready_out,
	output reg			ce,
	output reg			re
);

//internal registers

reg [127:0]	data_reg;
reg [127:0]	next_data_reg;
reg [5:0]	state;
reg [5:0]	next_state;
reg 		next_ready_out;

reg [7:0] 	data_state[15:0];
reg [7:0]	data_state_t[15:0];
reg [127:0] part_sub_data;

`define state_to_128bit\
	part_sub_data[127:120] = data_state_t[0];\
    part_sub_data[119:112] = data_state_t[1];\
    part_sub_data[111:104] = data_state_t[2];\
    part_sub_data[103:96]  = data_state_t[3];\
    part_sub_data[95:88]   = data_state_t[4];\
    part_sub_data[87:80]   = data_state_t[5];\
    part_sub_data[79:72]   = data_state_t[6];\
    part_sub_data[71:64]   = data_state_t[7];\
    part_sub_data[63:56]   = data_state_t[8];\
    part_sub_data[55:48]   = data_state_t[9];\
    part_sub_data[47:40]   = data_state_t[10];\
    part_sub_data[39:32]   = data_state_t[11];\
    part_sub_data[31:24]   = data_state_t[12];\
    part_sub_data[23:16]   = data_state_t[13];\
    part_sub_data[15:8]    = data_state_t[14];\
    part_sub_data[7:0]     = data_state_t[15];



always @ (posedge clk or negedge rst) begin

	if (!rst) begin
		data_reg = 0;
		state = 0;
		ready_out = 0;
		end
	
	else begin
		data_reg = (next_data_reg);
		state = (next_state);
		ready_out = (next_ready_out);
		end

end //always end
		


always @ (sbox_data_in or /*decrypt_in*/ start_in or state or data_reg or data_in) begin

	data_state[0] = data_in[127:120];
	data_state[1] = data_in[119:112];
	data_state[2] = data_in[111:104];
	data_state[3] = data_in[103:96];
	data_state[4] = data_in[95:88];
	data_state[5] = data_in[87:80];
	data_state[6] = data_in[79:72];
	data_state[7] = data_in[71:64];
	data_state[8] = data_in[63:56];
	data_state[9] = data_in[55:48];
	data_state[10] = data_in[47:40];
	data_state[11] = data_in[39:32];
	data_state[12] = data_in[31:24];
	data_state[13] = data_in[23:16];
	data_state[14] = data_in[15:8];
	data_state[15] = data_in[7:0];

	data_state_t[0] = data_reg[127:120];
	data_state_t[1] = data_reg[119:112];
	data_state_t[2] = data_reg[111:104];
	data_state_t[3] = data_reg[103:96];
	data_state_t[4] = data_reg[95:88];
	data_state_t[5] = data_reg[87:80]; 
	data_state_t[6] = data_reg[79:72];
	data_state_t[7] = data_reg[71:64];
	data_state_t[8] = data_reg[63:56];   	
	data_state_t[9] = data_reg[55:48];
	data_state_t[10] = data_reg[47:40];
	data_state_t[11] = data_reg[39:32];
	data_state_t[12] = data_reg[31:24];
	data_state_t[13] = data_reg[23:16];
	data_state_t[14] = data_reg[15:8];
	data_state_t[15] = data_reg[7:0];

	next_ready_out = 0;
	data_out = data_reg;
	ce = 1;
	re = 1;

	case(state)
		0: begin
			if(start_in) begin
				sbox_data_out = data_state[0];
				next_state = 1;
				ce = 0;
				re = 0;
			end
			
		end

		16: begin
			data_state_t[15] = sbox_data_in;
			
			part_sub_data[127:120] = data_state_t[0]; 		
            part_sub_data[119:112] = data_state_t[1]; 
            part_sub_data[111:104] = data_state_t[2]; 
            part_sub_data[103:96]  = data_state_t[3]; 
            part_sub_data[95:88]   = data_state_t[5]; 
	        part_sub_data[87:80]   = data_state_t[6]; 
            part_sub_data[79:72]   = data_state_t[7]; 
            part_sub_data[71:64]   = data_state_t[4]; 
            part_sub_data[63:56]   = data_state_t[10]; 
            part_sub_data[55:48]   = data_state_t[11]; 
            part_sub_data[47:40]   = data_state_t[8];
            part_sub_data[39:32]   = data_state_t[9];
            part_sub_data[31:24]   = data_state_t[15];
            part_sub_data[23:16]   = data_state_t[12];
            part_sub_data[15:8]    = data_state_t[13];
            part_sub_data[7:0]     = data_state_t[14];
			
			next_data_reg = part_sub_data;
			next_state = 0;
			next_ready_out = 1;

		end

		default: begin
			sbox_data_out = data_state[state];
			data_state_t[state-1] = sbox_data_in;
			`state_to_128bit
			next_data_reg = part_sub_data;
			next_state = state+1;
			ce = 0;
			re = 0;		
		end


	endcase

end

endmodule
