`include "defines.v"

module pc_reg (
	input wire clk,
	input wire rst,

	output reg[`RegBus] pc,
	output reg ce;
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable) begin
			ce <= `ClipDisable;
		end else begin
			if
		end
	end
endmodule // pc_reg
