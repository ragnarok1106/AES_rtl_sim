module	tb_keyexp();

reg				clk;
reg				rst_n;
reg		[127:0] key_in;
reg				start_in;
reg				en_de;
reg		[3:0]	round_in;

// internal wires
wire	[127:0]	key_out;
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
	# 5	key_in = 128'h2b28ab09_7eaef7cf_15d2154f_16a6883c;
	# 10 round_in = 1;
	# 10 start_in = 1;
	# 10 start_in = 0;
	# 1000	$finish;
end

top_keyexp		overall_ke (
							.clk		(clk),
                            .rst_n		(rst_n),
                            .key_in		(key_in),
                            .start_in	(start_in),
	                        .en_de		(en_de),
                            .round_in	(round_in),
                            .key_out	(key_out),
                            .ready_out	(ready_out)
						);

endmodule





