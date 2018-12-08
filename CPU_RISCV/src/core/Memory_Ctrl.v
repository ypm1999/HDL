`include "defines.v"

module Memory_Accesser (
	input  wire                 clk,
	input  wire                 rst,
	input  wire					rdy,

	input wire [ 7:0]			mem_din,		// data input bus
    output reg [ 7:0]          	mem_dout,		// data output bus
    output reg [31:0]          	mem_a,			// address bus (only 17:0 is used)
    output reg                 	mem_wr,			// write/read signal (1 for write)

	input wire 					re, 			// read enable
	input wire 					we,				// write enable
	input wire [31:0]			mem_addr,		//address of read or write
	input wire [31:0]			mem_wdata,		//data for writing to ram
	output reg [31:0]			mem_rdata,		//data read from ram

	output reg 					busy			//working busy singal
	);

	reg 		rbusy, wbusy;
	reg[2:0] 	rcnt, wcnt;

	//intial read data
	always @ ( * ) begin
		if (rst == `True_v)begin
			mem_rdata <= `ZeroWord;
			rbusy <= `False_v;
			busy <= `False_v;
			rcnt <= 3'b111;
		end
		else if (rdy == `True_v && re == `True_v)begin
			rbusy <= `True_v;
			busy <= `True_v;
			rcnt <= 3'b000;
			mem_a <= mem_addr;
			mem_wr <= 1'b0;
		end
	end

	//get data from ram
	always @ ( negedge clk ) begin
		if (rst == `True_v)begin
			mem_rdata <= `ZeroWord;
			busy <= `False_v;
		end
		else if(rdy == `True_v && rbusy == `True_v) begin
			if(rcnt[0] == 1'b1)begin
				case (rcnt[2:1])
					2'b11: begin
						mem_rdata[31:24] <= mem_din;
						rbusy <=`False_v;
						busy <= `False_v;
					end
					2'b10: mem_rdata[23:16] <= mem_din;
					2'b01: mem_rdata[15:8] <= mem_din;
					2'b00: mem_rdata[7:0] <= mem_din;
				endcase
			end
			else  begin
				if (rcnt != 3'b000)
					mem_a <= mem_a + 1;
			end
			rcnt <= rcnt + 3'b001;
		end
	end

	always @ ( * ) begin
		if (rst == `True_v)begin
			wbusy <= `False_v;
			busy <= `False_v;
			wcnt <= 3'b111;
		end
		else if (rdy == `True_v && we == `True_v)begin
			wbusy <= `True_v;
			busy <= `True_v;
			wcnt <= 2'b001;
			mem_dout <= mem_wdata[7:0];
			mem_a <= mem_addr;
			mem_wr <= 1'b1;
		end
	end

	always @ ( posedge clk ) begin
		if (rst == `True_v)begin
			wbusy <= `False_v;
			busy <= `False_v;
			wcnt <= 3'b111;
			mem_dout <= 2'h00;
		end
		else if(rdy == `True_v && wbusy == `True_v)begin
			case (wcnt[2:1])
				2'b11: begin
					wbusy <= `False_v;
					busy <= `False_v;
					mem_dout <= mem_wdata[31:24];
				end
				2'b10: begin
					mem_dout <= mem_wdata[23:16];
					mem_a <= mem_a + 1;
				end
				2'b01: begin
					mem_dout <= mem_wdata[15:8];
					mem_a <= mem_a + 1;
				end
				2'b00: 	mem_a <= mem_a + 1;
			endcase
			wcnt[2:1] <= wcnt[2:1] + 2'b01;
		end
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
	output reg [31:0]			mem_rdata,		//mem data read from ram
	output reg 					mem_rbusy,		//mem reading busy signal

	input wire 					mem_we,			//mem write enable
	input wire [31:0]			mem_waddr,		//mem write address
	input wire [31:0]			mem_wdata,		//mem data write to ram
	output reg 					mem_wbusy,		//mem writing busy signal

	input wire 					ram_busy,		//following is wires to ram
	input wire [31:0] 			ram_rdata,

	output reg 					ram_we,
	output reg 					ram_re,
	output reg [31:0]			ram_addr,
	output reg [31:0]			ram_wdata
	);

	reg [31:0] raddr_inst, raddr_mem, waddr_mem, wdata_mem;
	reg inst_rwait, mem_rwait, mem_wwait, inst_rwork, mem_rwork, mem_wwork;

	// initial begin
	// 	inst_rwait <= `False_v;
	// 	mem_rwait <= `False_v;
	// 	mem_wwait <= `False_v;
	// 	inst_rwork <= `False_v;
	// 	mem_rwork <= `False_v;
	// 	mem_wwork <= `False_v;
	// 	raddr_inst <=`ZeroWord;
	// 	raddr_mem <=`ZeroWord;
	// 	waddr_mem <=`ZeroWord;
	// 	wdata_mem <=`ZeroWord;
	// end

	always @ ( * ) begin
		if (rst == `True_v)begin
			inst_rwait <= `False_v;
			inst_rbusy <= `False_v;
			mem_rwait <= `False_v;
			mem_rbusy <= `False_v;
			mem_wwait <= `False_v;
			mem_wbusy <= `False_v;
			raddr_inst <= 8'hffffffff;
			raddr_mem <= 8'hffffffff;
			waddr_mem <= 8'hffffffff;
			wdata_mem <= `ZeroWord;
		end
		else if (rdy == `True_v) begin
			inst_rwait <= `False_v;
			mem_wwait <= `False_v;
			mem_rwait <= `False_v;
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
				inst_rwait <= `True_v;
				inst_rbusy <= `True_v;
				raddr_inst <= inst_raddr;
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

	always @ ( negedge ram_busy ) begin
		if (rst == `True_v)begin
			inst_rwork <= `False_v;
			inst_rbusy <= `False_v;
			// $display("inst_rbusy <= false  because rst at %t", $time);
			mem_rwork <= `False_v;
			mem_rbusy <= `False_v;
			mem_wwork <= `False_v;
			mem_wbusy <= `False_v;
		end
		else if (rdy == `True_v && ram_busy == `False_v)begin
			if (inst_rwork == `True_v) begin
				inst_rdata <= ram_rdata;
				inst_rwork <= `False_v;
				// $display("inst_rbusy <= false at %t", $time);
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


endmodule // Memory_ctrl
