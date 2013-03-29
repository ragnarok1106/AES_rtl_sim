module tb_subbyte ();

reg				clk;
reg				rst_n;
reg		[127:0] data_in;
reg				start_in;
reg				en_de;

// internal wires
wire	[127:0]	data_out;
wire			ready_out;


// dump variable
 parameter   DUMP_FILE   =   "tb.vcd";
 
 initial begin
     $display("Dump variables..");
     $dumpvars("AC");
     $dumpfile(DUMP_FILE);
     $shm_open("tb.shm");
     $shm_probe("AC");
 end          


initial begin
		start_in = 0;
		en_de = 1;
		clk = 0; 
		rst_n = 1;
		forever #5 clk = ~clk;
end

initial begin
	# 5	rst_n = 0;
	# 5	rst_n = 1;
	# 5	data_in = 127'h11223344_00000000_00000000_12345678;
	# 10 start_in = 1;
	# 10 start_in = 0;
	# 1000	$finish;
end





top_subbyte		overall_sub (
								.clk		(clk),
                                .rst_n		(rst_n),
                                .data_in	(data_in),
                                .start_in	(start_in),
                                .en_de		(en_de),
                                .data_out	(data_out),
                                .ready_out	(ready_out)
							);

endmodule
