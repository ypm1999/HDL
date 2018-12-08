`include "defines.v"

module EX_MA (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire 					ex_we,
	input wire[`RegAddrBus] 	ex_waddr,
	input wire[`RegBus] 		ex_wdata,
	input wire[4:0] 			stall,

	output reg 					ma_we,
	output reg[`RegAddrBus] 	ma_waddr,
	output reg[`RegBus] 		ma_wdata
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable) begin
			ma_we <= `False_v;
			ma_waddr <= 5'b00000;
			ma_wdata <= `ZeroWord;
		end
		else if (rdy == `True_v) begin
			if(stall[2] == `True_v && stall[3] == `False_v)begin
				ma_we <= `False_v;
				ma_waddr <= 5'b00000;
				ma_wdata <= `ZeroWord;
			end
			else begin
				ma_we <= ex_we;
				ma_waddr <= ex_waddr;
				ma_wdata <= ex_wdata;
			end
		end
	end

endmodule // EX_MEM



module MA (
	input wire 					rst,
	input wire 					rdy,


	input wire 					we_in,
	input wire[`RegAddrBus]		waddr_in,
	input wire[`RegBus]			wdata_in,

	output reg 					ram_re,
	output reg [31:0]			ram_raddr,
	input wire [31:0]			ram_rdata,
	input wire 					ram_rbusy,

	output reg 					ram_we,
	output reg [31:0]			ram_waddr,
	output reg [31:0]			ram_wdata,
	input wire 					ram_wbusy,

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
