`include "defines.v"

module MA_WB (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire 					ma_we,
	input wire[`RegAddrBus] 	ma_waddr,
	input wire[`RegBus] 		ma_wdata,
	input wire[4:0] 			stall,

	output reg 					wb_we,
	output reg[`RegAddrBus] 	wb_waddr,
	output reg[`RegBus] 		wb_wdata
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			wb_we <= `False_v;
			wb_waddr <= 5'b00000;
			wb_wdata <= `ZeroWord;
		end
		else if(rdy == `True_v) begin
			if(stall[3] == `True_v && stall[4] == `False_v)begin
				wb_we <= `False_v;
				wb_waddr <= 5'b00000;
				wb_wdata <= `ZeroWord;
			end
			else begin
				wb_we <= ma_we;
				wb_waddr <= ma_waddr;
				wb_wdata <= ma_wdata;
			end
		end
	end

endmodule // MEM_WB



module WB (
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

endmodule // WB
