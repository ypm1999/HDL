`include "defines.v"

//top control file
//cpu test moudle, to test the correctness of the cpu and rom
module CPU_TEST ();
	reg CLK_50;
	reg rst = `RstEnable;

	//clock is 50HZ, so it will clip for every 10ns
	initial begin
		CLK_50 = 1'b0;
		forever #10 CLK_50 = ~CLK_50;
	end

	//work start at 195ns, stop at 1000ns
	initial begin
		rst = `RstEnable;
		#195 rst = `RstDisable;
		#500 $stop;
	end

	SOPC test_sopc0(
		.clk(CLK_50),
		.rst(rst)
		);

endmodule // CPU_TEST
