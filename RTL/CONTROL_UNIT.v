module CONTROL_UNIT (
//INPUT
	input wire			clk,
	input wire			rst,
	input wire			load_in,
	//COMPLETE SIGNAL FROM EACH ROUND TRANSFORMATION UNIT
	input wire			ss_ready_in,
	input wire			mc_ready_in,
	input wire			ark_ready_in,

//OUTPUT
	//START SIGNAL TO EACH ROUND TRANSFORAMTION UNIT
	output reg			round_out,
	output reg			ss_start_out,
	output reg			mc_start_out,
	output reg			ark_start_out,

	//MUX SIGNALS
	output reg			key_sel,
	output reg	[2:0]	ark_in_sel
);

	reg		[3:0]		next_round_out;
	reg					state, next_state;

always @( posedge clk or negedge rst) begin

	if(!rst) begin
		round_out = 0;
		state = 0;
		key_sel = 0;
		ark_in_sel = 0;
	end

	else begin
		round_out = next_round_out;
		state = next_state;
	end

end


always @( state or round_out or load_in or ss_ready_in or mc_ready_in or ark_ready_in) begin

	ss_start_out = ark_ready_in;
	mc_start_out = ss_ready_in;
	ark_start_out = mc_ready_in;
	
	case (state)
		0: begin
			if (load_in) begin
				next_state = 1;
				next_round_out = 0;
				ark_in_sel = 3'b001;
				ark_start_out = 1;
			end
		end

		1: begin
		//COUNTER
			if (round_out == 10 && ark_start_out) begin
				next_round_out = 0;
				next_state = 0;
			end
			else if (ark_start_out) begin
				next_round_out = round_out + 1;
			end

		//MUX CONTROL
			//KEY_IN MUX
			if (round_out == 0 || round_out == 1) begin
				key_sel = 0;
			end
			else begin
				key_sel = 1;
			end

			//ARK_IN MUX
			if (round_out == 10) begin
				ark_in_sel = 3'b010;
			end
			else begin
				ark_in_sel = 3'b100;
			end

			
		end
				
	endcase
end	

endmodule		
