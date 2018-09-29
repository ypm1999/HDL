`include "defines.v"

module regfile (
	input wire 				clk,
	input wire 				rst,

	input wire 				we,
	input wire[`RegAddrBus]	waddr,
	input wire[`RegBus] 	wdata,

	input wire 				re1,
	input wire[`RegAddrBus] raddr1,
	output reg[`RegBus] 	rdata1,

	input wire re2,
	input wire[`RegAddrBus] raddr2,
	output reg[`RegBus] 	rdata2,
	);

	reg[`RegBus] registers[0:`RegNum - 1]

	always @ ( posedge clk ) begin
		if (rst == `RstDisable)
			if (we == `WriteEnable && waddr != `RegNumLog2'h0)
				regs[waddr] <= wdata;
	end

	always @ ( * ) begin
		if (rst == `RstEnable)
			rdata1 <= `ZeroWord;
		else begin
			if (re1 == `ReadEnable && raddr1 != `RegNumLog2'h0)
				if (we == `WriteEnable && waddr == raddr1)
					rdata1 <= wdata;
				else
					rdata1 <= regs[raddr1];
			else
				rdata1 <= `ZeroWord;
		end
	end

	always @ ( * ) begin
		if (rst == `RstEnable)
			rdata2 <= `ZeroWord;
		else begin
			if (re2 == `ReadEnable && raddr2 != `RegNumLog2'h0)
				if (we == `WriteEnable && waddr == raddr2)
					rdata2 <= wdata;
				else
					rdata2 <= regs[raddr2];
			else
				rdata2 <= `ZeroWord;
		end
	end

endmodule // regfile


module IF_ID (
	input wire 					clk,
	input wire 					rst,

	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus] 		if_inst,

	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst,
	);

	always @ ( posedge clk ) begin
		if (rst == RstEnable)
			id_pc <= `ZeroWord;
		else
			id_pc <= if_pc;
	end

	always @ ( posedge clk ) begin
		if (rst == RstEnable)
			id_inst <= `ZeroWord;
		else
			id_inst <= if_inst;
	end

endmodule // IF_ID

module ID_EX ();

endmodule // ID_EX
