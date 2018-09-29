/* ACM Class System (I) 2018 Fall Assignment 1 
 *
 * Part I: Write an adder in Verilog
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */
module adder_1(a, b, c_in, ans, c_out);
	input a, b, c_in;
	output ans, c_out;
	wire S1, A1, A2;
	xor x1 (S1, a, b);
	xor x2 (ans, S1, c_in);
	and a1 (A1, a, b);
	and a2 (A2, c_in, S1);
	or o1 (c_out, A1, A2);
endmodule



 module adder_4(a, b, c_in, ans, c_out);
	input [3:0] a, b;
	input c_in;
	output [3:0] ans;
	output c_out;
	wire [2:0] c_tmp;
	adder_1 add1 (a[0], b[0], c_in, ans[0], c_tmp[0]);
	adder_1 add2 (a[1], b[1], c_tmp[0], ans[1], c_tmp[1]);
	adder_1 add3 (a[2], b[2], c_tmp[1], ans[2], c_tmp[2]);
	adder_1 add4 (a[3], b[3], c_tmp[2], ans[3], c_out);
endmodule


module adder(
	// TODO: Write the ports of this module here
	//
	// Hint: 
	//   The module needs 4 ports, 
	//     the first 2 ports are 16-bit unsigned numbers as the inputs of the adder
	//     the third port is a 16-bit unsigned number as the output
	//	   the forth port is a one bit port as the carry flag
	// 
	a, b, ans, c_out
);
	// TODO: Implement this module here
	input [15:0] a, b;
	output [15:0] ans;
	output c_out;
	wire [3:0] c_tmp;
	wire c_in;
	assign c_in = 0;
	adder_4 add1 (a[3:0], b[3:0], c_in, ans[3:0], c_tmp[0]);
	adder_4 add2 (a[7:4], b[7:4], c_tmp[0], ans[7:4], c_tmp[1]);
	adder_4 add3 (a[11:8], b[11:8], c_tmp[1], ans[11:8], c_tmp[2]);
	adder_4 add4 (a[15:12], b[15:12], c_tmp[2], ans[15:12], c_out);

endmodule