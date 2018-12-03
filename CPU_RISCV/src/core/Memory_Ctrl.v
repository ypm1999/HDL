`include "defines.v"

module Memory_Accesser (
	input  wire                 clk,
	input  wire                 rst,
	input  wire					rdy,

	input wire [ 7:0]			mem_din,		// data input bus
    output reg [ 7:0]          	mem_dout,		// data output bus
    output reg [31:0]          	mem_a,			// address bus (only 17:0 is used)
    output reg                 	mem_wr,			// write/read signal (1 for write)

	input wire 					re,
	input wire 					we,
	input wire [31:0]			mem_addr,
	input wire [31:0]			mem_wdata,
	output reg [31:0]			mem_rdata,

	output reg 					busy
	);

	reg 		rbusy, wbusy, wstart;
	reg[1:0] 	rcnt, wcnt;

	initial begin
		rbusy <= `False_v;
		wbusy <= `False_v;
		busy <= `False_v;
		rcnt <= 2'b11;
		wcnt <= 2'b11;
	end

	//intial read data
	always @ ( * ) begin
		if (rst == `True_v)begin
			mem_rdata <= `ZeroWord;
			busy <= `False_v;
		end
		else if (rdy == `True_v && re == `True_v)begin
			rbusy <= `True_v;
			busy <= `True_v;
			rcnt <= 2'b00;
			mem_a <= mem_addr;
			mem_wr <= 1'b0;
		end
	end

	//get data from ram
	always @ ( mem_dout ) begin
		if (rst == `True_v)begin
			mem_rdata <= `ZeroWord;
			busy <= `False_v;
		end
		else if(rdy == `True_v && rbusy == `True_v) begin
			case (rcnt)
				2'b11: mem_rdata[31:24] <= mem_din;
				2'b10: mem_rdata[23:16] <= mem_din;
				2'b01: mem_rdata[15:8] <= mem_din;
				2'b00: mem_rdata[7:0] <= mem_din;
			endcase
			if(rcnt == 2'b11)begin //4Byte read finished
				rbusy <=`False_v;
				busy <= `False_v;
			end
			else begin
				rcnt <= rcnt + 2'b01;
				mem_a <= mem_a + 1;
			end
		end
	end

	always @ ( * ) begin
		if (rst == `True_v)begin
			busy <= `False_v;
		end
		else if (rdy == `True_v && we == `True_v)begin
			wbusy <= `True_v;
			busy <= `True_v;
			wstart <= `False_v;
			wcnt <= 2'b00;
			mem_a <= mem_addr;
			mem_wr <= 1'b1;
		end
	end

	always @ ( negedge clk ) begin
		if (rst == `True_v)begin
			busy <= `False_v;
		end
		else if(rdy == `True_v && wbusy == `True_v)
			if(wstart == `True_v)begin
				case (wcnt)
					2'b11: mem_dout <= mem_wdata[31:24];
					2'b10: mem_dout <= mem_wdata[23:16];
					2'b01: mem_dout <= mem_wdata[15:8];
					2'b00: mem_dout <= mem_wdata[7:0];
				endcase
				if(wcnt == 2'b11)begin
					rbusy <=`False_v;
					busy <= `False_v;
				end
				else begin
					wcnt <= wcnt + 2'b01;
					mem_a <= mem_a + 1;
				end
			end
			else wstart <= `True_v;
	end


endmodule // Memory_Accesser

module Memory_Ctrl (
	input  wire                 clk,
    input  wire                 rst,
	input  wire					rdy,

	input wire 					inst_re,
	input wire [31:0]			inst_raddr,
	output reg [31:0]			inst_rdata,
	output reg 					inst_rbusy,

	input wire 					mem_re,
	input wire [31:0]			mem_raddr,
	output reg [31:0]			mem_rdata,
	output reg 					mem_rbusy,

	input wire 					mem_we,
	input wire [31:0]			mem_waddr,
	input wire [31:0]			mem_wdata,
	output reg 					mem_wbusy,

	input wire 					ram_busy,
	input wire [31:0] 			ram_rdata,

	output reg 					ram_we,
	output reg 					ram_re,
	output reg [31:0]			ram_addr,
	output reg [31:0]			ram_wdata
	);

	reg [31:0] raddr_inst, raddr_mem, waddr_mem, wdata_mem;
	reg inst_rwait, mem_rwait, mem_wwait, inst_rwork, mem_rwork, mem_wwork;

	initial begin
		inst_rwait <= `False_v;
		mem_rwait <= `False_v;
		mem_wwait <= `False_v;
		inst_rwork <= `False_v;
		mem_rwork <= `False_v;
		mem_wwork <= `False_v;
		raddr_inst <=`ZeroWord;
		raddr_mem <=`ZeroWord;
		waddr_mem <=`ZeroWord;
		wdata_mem <=`ZeroWord;
	end

	always @ ( * ) begin
		if (rst == `True_v)begin
			inst_rwait <= `False_v;
			mem_rwait <= `False_v;
			mem_wwait <= `False_v;
			inst_rbusy <= `False_v;
			mem_rbusy <= `False_v;
			mem_wbusy <= `False_v;
			raddr_inst <=`ZeroWord;
			raddr_mem <=`ZeroWord;
			waddr_mem <=`ZeroWord;
			wdata_mem <=`ZeroWord;
		end
		else if (rdy == `True_v && ram_busy == `False_v) begin
			if (mem_we == `True_v)begin
				wdata_mem <= mem_wdata;
				waddr_mem <= mem_waddr;
				mem_wwait <= `True_v;
				mem_wbusy <= `True_v;
			end
			if (mem_re == `True_v)begin
				raddr_mem <= mem_raddr;
				mem_rwait <= `True_v;
				mem_rbusy <= `True_v;
			end
			if (inst_re == `True_v)begin
				raddr_inst <= inst_raddr;
				inst_rwait <= `True_v;
				inst_rbusy <= `True_v;
			end
		end
	end

	always @ ( * ) begin
		if (rst == `True_v)begin
			inst_rwork <= `False_v;
			mem_rwork <= `False_v;
			mem_wwork <= `False_v;
			inst_rbusy <= `False_v;
			mem_rbusy <= `False_v;
			mem_wbusy <= `False_v;
		end
		else if (rdy == `True_v && ram_busy == `False_v)begin
			if (inst_rwork == `True_v) begin
				inst_rdata <= ram_rdata;
				inst_rwork <= `False_v;
				inst_rbusy <= `False_v;
			end
			else if (mem_rwork == `True_v) begin
				mem_rdata <= ram_rdata;
				mem_rwork <= `False_v;
				mem_rbusy <= `False_v;
			end
			else if (mem_wwork == `True_v)begin
				mem_wwork <= `False_v;
				mem_wbusy <= `False_v;
			end
		end
	end

	always @ ( * ) begin
		if (rst == `True_v)begin
			ram_we <= `False_v;
			ram_re <= `False_v;
			ram_addr <= `ZeroWord;
			ram_wdata <= `ZeroWord;
		end
		else if (rdy == `True_v)begin
			if ((mem_wwait == `True_v && ram_busy == `False_v)
				|| (mem_wwork == `True_v && ram_busy == `True_v)) begin
				ram_addr <= mem_waddr;
				ram_wdata <= mem_wdata;
				mem_wwait = `False_v;
				mem_wwork = `True_v;
			end
			else if ((mem_rwait == `True_v && ram_busy == `False_v)
				|| (mem_rwork == `True_v && ram_busy == `True_v)) begin
				ram_addr <= mem_raddr;
				mem_rwait = `False_v;
				mem_wwait = `True_v;
			end
			else if ((inst_rwait == `True_v && ram_busy == `False_v)
				|| (inst_rwork == `True_v && ram_busy == `True_v)) begin
				ram_re <= `True_v;
				ram_addr <= raddr_inst;
				inst_rwait <= `False_v;
				inst_rwork = `True_v;
			end
		end
	end


endmodule // Memory_ctrl
