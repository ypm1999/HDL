`include "defines.v"

module Memory_Accesser (
	input  wire                 clk,
	input  wire                 rst,
	input  wire					rdy,

	input wire [ 7:0]			mem_din,		// data input bus
    output reg [ 7:0]          	mem_dout,		// data output bus
    output reg [31:0]          	mem_a,			// address bus (only 17:0 is used)
    output reg                 	mem_wr,			// write/read signal (1 for write)

	input wire 					clr,
	input wire 					re, 			// read enable
	input wire 					we,				// write enable
	input wire [ 2:0]			width,
	input wire [31:0]			mem_addr,		//address of read or write
	input wire [31:0]			mem_wdata,		//data for writing to ram
	output reg [31:0]			mem_rdata,		//data read from ram

	output reg 					busy			//working busy singal
	);

	reg[31:0]	waddr, raddr;
	reg 		rbusy, wbusy;
	reg[2:0] 	rcnt;
	reg[1:0] 	wcnt;

	always @ ( * ) begin
		if (rst == `True_v)
			mem_a <= `ZeroWord;
		else if (rdy) begin
			if ( wbusy )
				mem_a <= waddr;
			else
				mem_a <= raddr;
		end
	end

	always @ ( * ) begin
		if (rst == `True_v)
			mem_wr <= 1'b0;
		else if (rdy) begin
			if (wbusy)
				mem_wr <= 1'b1;
			else
				mem_wr <= 1'b0;
		end
	end

	//get data from ram
	always @ ( negedge clk ) begin
		if (rst == `True_v)begin
			mem_rdata <= `ZeroWord;
			rbusy <= `False_v;
			rcnt <= 3'b000;
			raddr <= `ZeroWord;
		end
		else if(rdy == `True_v) begin
			if(re == `True_v && (rbusy == `False_v || clr == `True_v))begin
				rbusy <= `True_v;
				raddr <= mem_addr - 1;
				mem_rdata <= `ZeroWord;
				rcnt <= 3'b000;
			end
			else if (rbusy) begin
				if(rcnt[0] == 1'b1)begin
					case (rcnt[2:1])
						2'b11: begin
							rbusy <= `False_v;
							mem_rdata[31:24] <= mem_din;
						end
						2'b10:begin
							if (width == 3'b011)
							   rbusy <= `False_v;
							mem_rdata[23:16] <= mem_din;
					   	end
						2'b01: begin
							if (width == 3'b011)
							   rbusy <= `False_v;
							mem_rdata[15:8] <= mem_din;
					   	end
						2'b00: begin
							if (width == 3'b011)
							   rbusy <= `False_v;
							mem_rdata[7:0] <= mem_din;
					   	end
					endcase
				end
				else
					raddr <= raddr + 1;

				rcnt <= rcnt + 3'b001;
			end
		end
	end


	always @ ( posedge clk ) begin
		if (rst == `True_v)begin
			wbusy <= `False_v;
			wcnt <= 2'b00;
			mem_dout <= 2'h00;
			waddr <= `ZeroWord;
		end
		else if(rdy == `True_v)begin
			if(we == `True_v && (wbusy == `False_v || clr == `True_v))begin
				wbusy <= `True_v;
				waddr <= mem_addr;
				mem_dout <= mem_wdata[7:0];
				wcnt <= 2'b00;
			end
			else if (wbusy == `True_v)
				case (wcnt)
					2'b11: begin
						wbusy <= `False_v;
					end
					2'b10: begin
						if (width == 3'b011)
							wbusy <= `False_v;
						else
							mem_dout <= mem_wdata[31:24];
					end
					2'b01: begin
						if (width == 3'b010)
							wbusy <= `False_v;
						else
							mem_dout <= mem_wdata[23:16];
					end
					2'b00: begin
						if (width == 3'b001)
							wbusy <= `False_v;
						else
							mem_dout <= mem_wdata[15:8];
					end
				endcase
			waddr <= waddr + 1;
			wcnt <= wcnt + 2'b01;
		end
	end

	always @ ( * ) begin
		if(rst == `True_v)
			busy <= `False_v;
		else if(rdy == `True_v)
			busy <= rbusy | wbusy;
	end


endmodule // Memory_Accesser

module Memory_Ctrl (
	input  wire                 clk,
    input  wire                 rst,
	input  wire					rdy,

	input wire 					inst_re,		//instruction read enable
	input wire [31:0]			inst_raddr,		//instruction read address
	output reg [31:0]			inst_rdata,		//instruction data read from ram
	output reg 					inst_rbusy,		//instruction reading busy signal

	input wire 					mem_re,			//mem read enable
	input wire [31:0]			mem_raddr,		//mem read address
	input wire [2:0] 			mem_rwidth,
	output reg [31:0]			mem_rdata,		//mem data read from ram
	output reg 					mem_rbusy,		//mem reading busy signal

	input wire 					mem_we,			//mem write enable
	input wire [31:0]			mem_waddr,		//mem write address
	input wire [2:0] 			mem_wwidth,
	input wire [31:0]			mem_wdata,		//mem data write to ram
	output reg 					mem_wbusy,		//mem writing busy signal

	input wire 					ram_busy,		//following is wires to ram
	input wire [31:0] 			ram_rdata,

	output reg 					ram_clr,
	output reg 					ram_we,
	output reg 					ram_re,
	output reg [2:0]			ram_width,
	output reg [31:0]			ram_addr,
	output reg [31:0]			ram_wdata
	);

	reg [31:0] 	raddr_inst, raddr_mem, waddr_mem, wdata_mem;
	reg [ 2:0] 	wwidth_mem, rwidth_mem;
	reg 		mem_wdone, mem_rdone, inst_rdone;


	always @ ( * ) begin
		if (rst == `True_v)begin
			raddr_inst <= 8'hffff;
			raddr_mem <= 8'hffff;
			waddr_mem <= 8'hffff;
			wdata_mem <= `ZeroWord;
		end
		else if (rdy == `True_v) begin
			if (mem_we == `True_v)begin
				wdata_mem <= mem_wdata;
				waddr_mem <= mem_waddr;
				wwidth_mem <= mem_wwidth;
			end
			else begin
				waddr_mem <= 8'hffff;
				wdata_mem <= `ZeroWord;
				wwidth_mem <= 3'b000;
			end

			if (mem_re == `True_v)begin
				raddr_mem <= mem_raddr;
				rwidth_mem <= mem_rwidth;
			end
			else begin
				raddr_mem <= 8'hffff;
				rwidth_mem <= 3'b000;
			end

			if (inst_re == `True_v)
				raddr_inst <= inst_raddr;
			else
				raddr_inst <= 8'hffff;
		end
	end

	//always @ ( posedge clk, negedge ram_busy ) begin
	always @ ( posedge clk ) begin
		if (rst == `True_v)begin
			ram_we <= `False_v;
			ram_re <= `False_v;
			ram_addr <= `ZeroWord;
			ram_wdata <= `ZeroWord;
			mem_rbusy <= `False_v;
			mem_wbusy <= `False_v;
			inst_rbusy <= `False_v;
			mem_rdata <= `ZeroWord;
			inst_rdata <= `ZeroWord;
		end
		else if (rdy == `True_v && !ram_busy)begin
			ram_we <= `False_v;
			ram_re <= `False_v;
			mem_rdata <= `ZeroWord;
			inst_rdata <= `ZeroWord;
			if(mem_wbusy)begin
				mem_wbusy <= `False_v;
			end
			else if (mem_rbusy) begin
				mem_rdata <= ram_rdata;
				mem_rbusy <= `False_v;
			end
			else if (inst_rbusy) begin
				inst_rdata <= ram_rdata;
				// $display("inst_rbusy <= false at %t", $time);
				inst_rbusy <= `False_v;
			end
			if (waddr_mem != 8'hffff)begin
				ram_we <= `True_v;
				ram_addr <= waddr_mem;
				ram_wdata <= wdata_mem;
				ram_width <= wwidth_mem;
				mem_wbusy <= `True_v;
			end
			else if (raddr_mem != 8'hffff)begin
				ram_re <= `True_v;
				mem_rbusy <= `True_v;
				ram_addr <= raddr_mem;
				ram_width <= rwidth_mem;
			end
			else if (raddr_inst != 8'hffff)begin
				ram_re <= `True_v;
				inst_rbusy <= `True_v;
				ram_addr <= raddr_inst;
				ram_width <= 3'b100;
			end
		end
	end


endmodule // Memory_ctrl
