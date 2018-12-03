`include "defines.v"


module EX_MEM (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire 					ex_we,
	input wire[`RegAddrBus] 	ex_waddr,
	input wire[`RegBus] 		ex_wdata,
	input wire[4:0] 			stall,

	output reg 					mem_we,
	output reg[`RegAddrBus] 	mem_waddr,
	output reg[`RegBus] 		mem_wdata
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			mem_we <= `False_v;
			mem_waddr <= 5'b00000;
			mem_wdata <= `ZeroWord;
		end
		else if (rdy == `True_v) begin
			if(stall[2] == `True_v && stall[3] == `False_v)begin
				mem_we <= `False_v;
				mem_waddr <= 5'b00000;
				mem_wdata <= `ZeroWord;
			end
			else begin
				mem_we <= ex_we;
				mem_waddr <= ex_waddr;
				mem_wdata <= ex_wdata;
			end
		end
	end

endmodule // EX_MEM



module MEM (
	input wire 					rst,
	input wire 					rdy,

	input wire 					we_in,
	input wire[`RegAddrBus]		waddr_in,
	input wire[`RegBus]			wdata_in,

	output reg 					we_out,
	output reg[`RegAddrBus]		waddr_out,
	output reg[`RegBus]			wdata_out,
	output reg 					stall_req
	);

	always @ ( * ) begin
		if (rst == `RstEnable)begin
			we_out <= `False_v;
			waddr_out <= 5'b00000;
			wdata_out <= 32'h00000000;
		end
		else if(rdy == `True_v) begin
			we_out <= we_in;
			waddr_out <= waddr_in;
			wdata_out <= wdata_in;
		end
	end

endmodule // MEM
