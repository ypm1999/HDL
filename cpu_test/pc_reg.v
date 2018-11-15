`include "defines.v"

module pc_reg (
	input wire 				clk,
	input wire 				rst,

	output reg[`RomAddrBus] pc,
	output reg 				ce
	);

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
			pc <= 4'h4;
	end

endmodule // pc_reg
