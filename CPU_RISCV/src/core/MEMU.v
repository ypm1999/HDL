`include "defines.v"


module EX_MEM (
	input wire clk,
	input wire rst,

	input wire 					ex_we,
	input wire[`RegAddrBus] 	ex_waddr,
	input wire[`RegBus] 		ex_wdata,

	output reg 					mem_we,
	output reg[`RegAddrBus] 	mem_waddr,
	output reg[`RegBus] 		mem_wdata
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			mem_we <= `False_v;
			mem_waddr <= 5'b00000;
			mem_wdata <= 32'h00000000;
		end
		else begin
			mem_we <= ex_we;
			mem_waddr <= ex_waddr;
			mem_wdata <= ex_wdata;
		end
	end

endmodule // EX_MEM



module MEM (
	input wire 				rst,

	input wire 				we_in,
	input wire[`RegAddrBus]	waddr_in,
	input wire[`RegBus]		wdata_in,

	output reg 				we_out,
	output reg[`RegAddrBus]	waddr_out,
	output reg[`RegBus]		wdata_out
	);

	always @ ( * ) begin
		if (rst == `RstEnable)begin
			we_out <= `False_v;
			waddr_out <= 5'b00000;
			wdata_out <= 32'h00000000;
		end
		else begin
			we_out <= we_in;
			waddr_out <= waddr_in;
			wdata_out <= wdata_in;
		end
	end

endmodule // MEM
