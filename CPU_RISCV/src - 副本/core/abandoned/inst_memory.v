`include "defines.v"
module INST_ROM (
	input wire 					rom_ce,
	input wire[`InstAddrBus]	rom_raddr,
	output reg[`InstBus]		rom_rdata
	);

	reg[7:0]	data[0:`InstMemNum];

	integer i;
	initial begin
		$readmemh("E:/code/HDL/cpu_test/test.data", data);
		// for (i = 0; i < 20; i = i + 1) begin
		// 	$display("inst[%d]:%d", i, data[i]);
		// end
	end

	always @ ( * ) begin
		if (rom_ce == `False_v)
			rom_rdata <= `ZeroWord;
		else begin
			rom_rdata <= {data[rom_raddr | 2'b11], data[rom_raddr | 2'b10], data[rom_raddr | 2'b01], data[rom_raddr]};
			// $display("get_rom[%d,%d]:%b", rom_ce, rom_raddr, {data[rom_raddr | 2'b11], data[rom_raddr | 2'b10], data[rom_raddr | 2'b01], data[rom_raddr]});
		end

	end

endmodule // INST_ROM
