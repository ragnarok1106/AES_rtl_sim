module AES_TB;

reg				clk;
reg				rst;

reg	[383:0]		tb;
reg				kld;
reg	[127:0]		plain, cipher_cmp;
reg [127:0]		key;
wire [127:0]	cipher_out;
wire			done;


// Dump variables
	parameter	DUMP_FILE	=	"tb.vcd";

	initial	begin
		$display("Dump variables..");
		$dumpvars("AC");
		$dumpfile(DUMP_FILE);
		$shm_open("tb.shm");
		$shm_probe("AC");
	end

	always #5 clk = ~clk;

	initial begin
		kld		=	1'b0;
		rst		=	1'b0;
		clk		=	1'b0;
		repeat(4)   @(posedge clk);

		$display("");
		$display("");
		$display("Started random test ...");

		tb = 384'h0000_0000_0000_0000_0000_0000_0000_0000___f344_81ec_3cc6_27ba_cd5d_c3fb_08f2_73e6___0336_763e_966d_9259_5a56_7cc9_ce53_7f5e;
	    key     = tb[383:256];
		plain   = tb[255:128];
		cipher_cmp    = tb[127:0];
		
		@(posedge clk);
		#1;
		rst = 1;
		kld = 1;
		@(posedge clk);
		#1;
		kld = 0;

		#2000 $finish;

	end


AES_TOP		aes_core (
						.clk			(clk),
						.rst			(rst),
						.load_in		(kld),
						.plain_text_in	(plain),
						.key_in			(key),
						.ready_out		(done),
						.cipher_out		(cipher_out)
);


endmodule
