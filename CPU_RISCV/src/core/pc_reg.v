`include "defines.v"

module pc_reg (
	input wire 				clk,
	input wire 				rst,

	output reg[`RomAddrBus] pc,
	output reg 				ce
	);

	initial begin
		pc <= 0;
	end

	always @ ( posedge clk ) begin
		if (rst != `RstDisable)
			ce <= `ClipDisable;
		else
			ce <= `ClipEnable;
	end

	always @ ( posedge clk ) begin
		if (rst != `RstDisable)
			pc <= `ZeroWord;
		else
			pc <= pc + 4'h4;
	end

endmodule // pc_reg