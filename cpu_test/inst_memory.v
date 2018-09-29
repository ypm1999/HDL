`include "defines.v"
module InstRom (
	input wire[`InstBus]	addr,
	input wire 				ce,

	output reg[`InstBus]	inst,
	);
	reg[InstBus] inst_mem[InstMemNum];

	always @ ( * ) begin
		if (ce == `ClipEnable)
			inst <= inst_mem[addr[31:2]];
		else
			inst <= `ZeroWord;
	end

endmodule // InstRom
