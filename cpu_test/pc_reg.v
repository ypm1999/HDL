`include "defines.v"

module pc_reg (
	input wire 			clk,
	input wire 			rst,

	output reg[`RegBus] pc,
	output reg 			ce;
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)
			ce <= `ClipDisable;
		else
			ce <= `ClipEnable;
	end

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)
			pc <= `ZeroWord;
		else
			pc <= 4'h4
	end

endmodule // pc_reg
