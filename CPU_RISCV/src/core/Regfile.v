`include "defines.v"

module RegFile(
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				we,
	input wire[`RegAddrBus]	waddr,
	input wire[`RegBus] 	wdata,

	input wire 				re1,
	input wire[`RegAddrBus] raddr1,
	output reg[`RegBus] 	rdata1,

	input wire             	re2,
	input wire[`RegAddrBus] raddr2,
	output reg[`RegBus] 	rdata2
	);

	reg[`RegBus] registers[0:`RegNum - 1];


	always @ ( posedge clk ) begin
		if ((~rst & rdy) & we & (waddr != 5'b00000))begin
			registers[waddr] <= wdata;
		end
	end

	wire [31:0] reg1 = registers[raddr1],
				reg2 = registers[raddr2];


	always @ ( * ) begin
		if ((rst | ~rdy) | (!re1 | !raddr1))
			rdata1 <= `ZeroWord;
		else begin
			rdata1 <= (we && !(waddr ^ raddr1)) ? wdata : reg1;
		end
	end

	always @ ( * ) begin
		if ((rst | ~rdy) | (!re2 | !raddr2))
			rdata2 <= `ZeroWord;
		else begin
			rdata2 <= (we && !(waddr ^ raddr2)) ? wdata : reg2;
		end
	end

endmodule // RegFile
