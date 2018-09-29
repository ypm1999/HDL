
//  module adder_4(a, b, c_in, ans, c_out);
// 	input [3:0] a, b;
// 	input c_in;
// 	output [3:0] ans;
// 	output c_out;
// 	wire [3:0] c, p, g;

// 	assign p = a ^ b;
// 	assign g = a & b;
// 	assign c[0] = c_in;
// 	assign c[1] = g[0] | (p[0] & c[0]);
// 	assign c[2] = g[1] | (p[1] & (g[0] | (p[0] & c[0])));
// 	assign c[3] = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & c[0])))));
// 	assign c_out = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & c[0])))))));
// 	assign ans = p ^ c;
// endmodule

// module adder(a, b, ans, c_out);
// 	input [15:0] a, b;
// 	output [15:0] ans;
// 	output c_out;
// 	wire [3:0] c_tmp;
// 	wire c_in;
// 	assign c_in = 0;
// 	adder_4 add1 (a[3:0], b[3:0], c_in, ans[3:0], c_tmp[0]);
// 	adder_4 add2 (a[7:4], b[7:4], c_tmp[0], ans[7:4], c_tmp[1]);
// 	adder_4 add3 (a[11:8], b[11:8], c_tmp[1], ans[11:8], c_tmp[2]);
// 	adder_4 add4 (a[15:12], b[15:12], c_tmp[2], ans[15:12], c_out);

// endmodule


 module adder_4(p, g, c_in, ans);
	input [3:0] p, g;
	input c_in;
	output [3:0] ans;
	wire [3:0] c;

	assign c[0] = c_in;
	assign c[1] = g[0] | (p[0] & c[0]);
	assign c[2] = g[1] | (p[1] & (g[0] | (p[0] & c[0])));
	assign c[3] = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & c[0])))));
	assign ans = p ^ c;
endmodule


module adder(a, b, ans, c_out);
	// TODO: Implement this module here
	input [15:0] a, b;
	output [15:0] ans;
	output c_out;
	wire [3:0] c, gg, pp;
	wire [15:0] p, g, s;
	assign p = a | b;
	assign s = a ^ b;
	assign g = a & b;
	assign pp[0] = &p[3:0];
	assign pp[1] = &p[7:4];
	assign pp[2] = &p[11:8];
	assign pp[3] = &p[15:12];
	assign gg[0] = g[3] | (p[3] & g[2]) | (p[2] & p[3] & g[1]) | (&p[3:1] & g[0]);
	assign gg[1] = g[7] | (p[7] & g[6]) | (p[6] & p[7] & g[5]) | (&p[7:5] & g[4]);
	assign gg[2] = g[11] | (p[11] & g[10]) | (p[10] & p[11] & g[9]) | (&p[11:9]  & g[8]);
	assign gg[3] = g[15] | (p[15] & g[14]) | (p[14] & p[15] & g[13]) | (&p[15:13] & g[12]);
	assign c[0] = 0;
	assign c[1] = gg[0];
	assign c[2] = gg[1] | (pp[1] & (gg[0] | pp[0]));
	assign c[3] = gg[2] | (pp[2] & (gg[1] | (pp[1] & (gg[0] | pp[0]))));
	assign c_out = gg[3] | (pp[3] & (gg[2] | (pp[2] & (gg[1] | (pp[1] & (gg[0] | pp[0]))))));

	adder_4 add1 (s[3:0], g[3:0], c[0], ans[3:0]);
	adder_4 add2 (s[7:4], g[7:4], c[1], ans[7:4]);
	adder_4 add3 (s[11:8], g[11:8], c[2], ans[11:8]);
	adder_4 add4 (s[15:12], g[15:12], c[3], ans[15:12]);

endmodule