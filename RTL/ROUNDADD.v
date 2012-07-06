module ROUNDADD(
//input
	input wire			clk,
	input wire			rst,
	input wire	[127:0]	data_in,
	input wire	[127:0]	key_in,
	input wire	[127:0] ksch_key_in,
	//CONTROL SIGNALS INPUT
	input wire			start_in,
	input wire			round_in,

//output
	output reg	[127:0]	data_out,
	output reg 			ready_out,
	output reg			done_out
);

	reg [127:0]			next_data_out;
	reg					next_ready_out;
	reg					next_done_out;

always @ (posedge clk or negedge rst) begin

	if (!rst) begin
		ready_out = 0;
		data_out = 0;
		done_out = 0;
	end

	else begin
		ready_out = next_ready_out;
		data_out = next_data_out;
		done_out = next_done_out;
	end
end


always @ (start_in or round_in or data_in or key_in) begin

	next_ready_out = 0;
	next_done_out = 0;
	
	case (round_in)
		0: begin
			if(start_in) begin
				next_data_out = data_in ^ key_in;
				next_ready_out = 1;
			end
		end
		10: begin
			if (start_in) begin
				next_data_out = data_in ^ ksch_key_in;
				next_ready_out = 1;
				next_done_out = 1;
			end
		end

		default: begin
			if (start_in) begin
				next_data_out = data_in ^ ksch_key_in;
				next_ready_out = 1;
			end
		end
		
	endcase
end

endmodule
