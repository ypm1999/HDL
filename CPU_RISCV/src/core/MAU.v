`include "defines.v"

module EX_MA (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire 					ex_we,
	input wire[`RegAddrBus] 	ex_waddr,
	input wire[`RegBus] 		ex_wdata,
	input wire 					ex_ma_we,
	input wire 					ex_ma_re,
	input wire[ 2:0]			ex_ma_width,
	input wire[31:0]			ex_ma_addr,
	input wire[31:0]			ex_ma_wdata,

	input wire[4:0] 			stall,

	output reg 					ma_we,
	output reg[`RegAddrBus] 	ma_waddr,
	output reg[`RegBus] 		ma_wdata,
	output reg 					ma_ma_we,
	output reg 					ma_ma_re,
	output reg[ 2:0]			ma_ma_width,
	output reg[31:0]			ma_ma_addr,
	output reg[31:0]			ma_ma_wdata
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable) begin
			ma_we <= `False_v;
			ma_waddr <= 5'b00000;
			ma_wdata <= `ZeroWord;
			ma_ma_we <= `False_v;
			ma_ma_re <= `False_v;
			ma_ma_width <= 3'b000;
			ma_ma_addr <= `ZeroWord;
			ma_ma_wdata <= `ZeroWord;
		end
		else if (rdy == `True_v) begin
			ma_ma_we <= `False_v;
			ma_ma_re <= `False_v;
			ma_ma_width <= 3'b000;
			ma_ma_addr <= `ZeroWord;
			ma_ma_wdata <= `ZeroWord;
			if(!stall[3]) begin
				ma_we <= ex_we;
				ma_waddr <= ex_waddr;
				ma_wdata <= ex_wdata;
				ma_ma_we <= ex_ma_we;
				ma_ma_re <= ex_ma_re;
				ma_ma_width <= ex_ma_width;
				ma_ma_addr <= ex_ma_addr;
				ma_ma_wdata <= ex_ma_wdata;
			end
		end
	end

endmodule // EX_MEM



module MA (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire 					we_in,
	input wire[`RegAddrBus]		waddr_in,
	input wire[`RegBus]			wdata_in,

	input wire 					ma_we,
	input wire 					ma_re,
	input wire[ 2:0]			ma_width,
	input wire[31:0]			ma_addr,
	input wire[31:0]			ma_wdata,

	output reg 					ram_re,
	output reg [31:0]			ram_raddr,
	output reg [2:0] 			ram_rwidth,
	input wire [31:0]			ram_rdata,
	input wire 					ram_rbusy,

	output reg 					ram_we,
	output reg [31:0]			ram_waddr,
	output reg [2:0] 			ram_wwidth,
	output reg [31:0]			ram_wdata,
	input wire 					ram_wbusy,

	output reg 					we_out,
	output reg[`RegAddrBus]		waddr_out,
	output reg[`RegBus]			wdata_out,
	output reg 					stall_req
	);

	always @ ( * ) begin
		if (rst)begin
			ram_we <= `False_v;
			ram_re <= `False_v;
			ram_waddr <= `ZeroWord;
			ram_wwidth <= 3'b000;
			ram_rwidth <= 3'b000;
		end
		else if(rdy) begin
			if (ma_we) begin
				ram_we <= `True_v;
				ram_re <= `False_v;
				ram_waddr <= ma_addr;
				ram_wwidth <= ma_width;
				ram_wdata <= ma_wdata;
				stall_req <= `True_v;
			end
			else if (ma_re) begin
				ram_we <= `False_v;
				ram_re <= `True_v;
				ram_raddr <= ma_addr;
				ram_rwidth <= ma_width;
				stall_req <= `True_v;
			end
			else begin
				ram_re <= `False_v;
				ram_we <= `False_v;
			end
		end
	end

	always @ ( negedge clk ) begin
		if (rst == `RstEnable)begin
			we_out <= `False_v;
			waddr_out <= 5'b00000;
			wdata_out <= 32'h00000000;
		end
		else if(rdy == `True_v) begin
			$display("run");
			we_out <= we_in;
			waddr_out <= waddr_in;
			wdata_out <= wdata_in;
			if(stall_req & !(ram_rbusy | ram_wbusy)) begin
				stall_req <= `False_v;
				wdata_out <= ram_rdata;
			end
		end
	end

endmodule // MEM
