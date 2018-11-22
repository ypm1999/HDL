`include "defines.v"

//A smallest SOCP of riscv cpu, connect core and instruction rom 
module SOPC (
	input wire clk,
	input wire rst
	);

	wire[`InstAddrBus] 	inst_addr;
	wire[`InstBus]		inst;
	wire 				rom_ce;

	CORE_TOP core0(
		.clk(clk),
		.rst(rst),
		.rom_rdata(inst),
		.rom_raddr(inst_addr),
		.rom_ce(rom_ce)
		);

	INST_ROM inst_rom0(
		.rom_rdata(inst),
		.rom_raddr(inst_addr),
		.rom_ce(rom_ce)
		);

endmodule // SOPC
