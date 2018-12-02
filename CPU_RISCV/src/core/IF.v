`include "defines.v"

module IF (
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				use_npc,
	input wire[31:0]		npc_addr,

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
		else begin

			pc <= pc + 4'h4;
	end

endmodule // pc_reg
