`include "defines.v"

module RegFile(
	input wire 				clk,
	input wire 				rst,

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

	initial begin
		registers[0] <= 0;

	end

	always @ ( posedge clk ) begin
		if (rst == `RstDisable)
			if (we == `WriteEnable && waddr != 5'b00000)begin
				registers[waddr] <= wdata;
				$display("waddr %d, wdata %h\n", waddr, wdata);
			end
	end

	always @ ( * ) begin
		if (rst == `RstEnable)
			rdata1 <= `ZeroWord;
		else begin
			if (re1 == `ReadEnable)begin
				$display("raddr1 %d, rdata1 %h\n", raddr1, registers[raddr1]);
				if (we == `WriteEnable && waddr == raddr1)
					rdata1 <= wdata;
				else
					rdata1 <= registers[raddr1];
			end
			else
				rdata1 <= `ZeroWord;
		end
	end

	always @ ( * ) begin
		if (rst == `RstEnable)
			rdata2 <= `ZeroWord;
		else begin
			if (re2 == `ReadEnable)begin
				$display("raddr2 %d, rdata2 %h", raddr2, registers[raddr2]);
				if (we == `WriteEnable && waddr == raddr2)
					rdata2 <= wdata;
				else
					rdata2 <= registers[raddr2];
			end
			else
				rdata2 <= `ZeroWord;
		end
	end

endmodule // RegFile
