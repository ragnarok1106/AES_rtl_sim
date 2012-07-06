module KEY_SCHEDULE (
//input
	input wire		  	clk,
	input wire		  	rst,
	input wire		  	start_in,
	input wire	[3:0]	round_in,
	input wire	[127:0]	last_key_in,
	input wire	[7:0]	sbox_data_in,
	//input wire		decrpyt_in,	
//output
	output reg	[127:0]	new_key_out,
	output reg			ready_out,
	output reg  [7:0]	sbox_data_out
);

reg	[7:0]	rcon;
reg	[2:0]	state, next_state;
reg [31:0]	col, next_col;
reg [127:0]	next_data_out;
reg 		next_ready_out;
reg [127:0] key_var, new_key_var;
reg			ce;
reg			re;


SBOX_ROM sbrom_key(
.clk		(clk),
.addr		(sbox_data_out),
.chip_en	(ce),
.read_en	(re),
.data		(sbox_data_in)
);


//RCON
always @ (round_in) begin
	case (round_in)
		1: begin
			rcon = 1;
		end

		2: begin
			rcon = 2;
		end

		3: begin
			rcon = 4;
		end

		4: begin
			rcon = 8;
		end

		5: begin
			rcon = 'h10;
		end

		6: begin
			rcon = 'h20;
		end

		7: begin
			rcon = 'h40;
		end

		8: begin
			rcon = 'h80;
		end

		9: begin
			rcon = 'h1B;
		end

		10: begin
			rcon = 'h36;
		end

		default: begin
			rcon = 0;
		end

	endcase
end

always @ (posedge clk or negedge rst) begin
	if(!rst) begin
		state = 0;
		col = 0;
		new_key_out = 0;
		ready_out = 0;
	end

	else begin
		state = next_state;
		col = next_col;
		new_key_out = next_data_out;
		ready_out = next_ready_out;
	end
end

always @ (start_in or sbox_data_in or col or state or rcon or last_key_in) begin

	next_ready_out = 0;
	ce = 1;
	re = 1;
	key_var = last_key_in;

	case (state)
		0: begin
			if (start_in) begin
				sbox_data_out = key_var[103:96];
				ce = 0;
				re = 0;
				next_state = 1;
			end			
		end

		1: begin
			next_col[7:0] = sbox_data_in;
			sbox_data_out = key_var[71:64];
			ce = 0;
			re = 0;
			next_state = 2;
		end

		2: begin
			next_col[31:24] = sbox_data_in;
			sbox_data_out = key_var[39:32];
			ce = 0;
			re = 0;
			next_state = 3;
		end

		3: begin
			next_col[23:16] = sbox_data_in;
			sbox_data_out = key_var[7:0];
			ce = 0;
			re = 0;
			next_state = 4;	
		end

		4: begin
			next_col[15:8] = sbox_data_in;
			{new_key_var[127:120], new_key_var[95:88], new_key_var[63:56], new_key_var[31:24]} = col ^ {key_var[127:120], key_var[95:88], key_var[63:56], key_var[31:24]} ^ {rcon, 24'd0};
			{new_key_var[119:112], new_key_var[87:80], new_key_var[55:48], new_key_var[23:16]} = {new_key_var[127:120], new_key_var[95:88], new_key_var[63:56], new_key_var[31:24]} ^ 
																									{key_var[119:112], key_var[87:80], key_var[55:48], key_var[23:16]};
			{new_key_var[111:104], new_key_var[87:80], new_key_var[55:48], new_key_var[23:16]} = {new_key_var[119:112], new_key_var[87:80], new_key_var[55:48], new_key_var[23:16]} ^ 
																									{key_var[111:104], key_var[87:80], key_var[55:48], key_var[23:16]};
			{new_key_var[103:96], new_key_var[71:64], new_key_var[39:32], new_key_var[7:0]} = {new_key_var[111:104], new_key_var[87:80], new_key_var[55:48], new_key_var[23:16]} ^ 
																								{key_var[103:96], key_var[71:64], key_var[39:32], key_var[7:0]};
			next_ready_out = 1;
			next_data_out = new_key_var;
			next_state = 0;
		end

		default: begin
			next_state = 0;
		end
	endcase
end

endmodule

