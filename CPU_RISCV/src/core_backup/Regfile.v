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
		if (~rst & rdy & we & (waddr != 5'b00000))begin
			//$display("p_write:%h <= %d", waddr, wdata);
			registers[waddr] <= wdata;
		end
	end

	always @ ( * ) begin
		if (rst)
			rdata1 <= `ZeroWord;
		else if(rdy) begin
			if (re1  && raddr1 != 5'b00000)begin
				if (we && waddr == raddr1)
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
		else if(rdy) begin
			if (re2 && raddr2 != 5'b00000) begin
				if (we&& waddr == raddr2)
					rdata2 <= wdata;
				else
					rdata2 <= registers[raddr2];
			end
			else
				rdata2 <= `ZeroWord;
		end
	end

endmodule // RegFile
