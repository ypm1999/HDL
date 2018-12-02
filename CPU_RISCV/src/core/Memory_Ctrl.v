`include "defines.v"


module Memory_Accesser (
	input  wire                 clk,
	input  wire                 rst,
	input  wire					rdy,

	input  wire [ 7:0]          mem_din,		// data input bus
    output reg  [ 7:0]          mem_dout,		// data output bus
    output reg  [31:0]          mem_a,			// address bus (only 17:0 is used)
    output reg                  mem_wr,			// write/read signal (1 for write)

	input wire 					re,
	input wire [31:0]			mem_raddr,
	input wire [31:0]			mem_rdata,

	input wire 					we,
	input wire [31:0]			mem_waddr,
	input wire [31:0]			mem_wdata,

	output reg 					busy
	);

	reg 		rbusy, wbusy, wstart;
	reg[2:0] 	rcnt, wcnt;
	initial begin
		rbusy <= 1'b0;
		wbusy <= 1'b0;
		busy <= 0;
		rcnt <= 2'b11;
		wcnt <= 2'b11;
	end

	//intial read data
	always @ ( * ) begin
		if (rst == `True_v)begin
			mem_rdata <= `ZeroWord;
			busy <= 1'b0;
		end
		else if (rdy && re == `True_v)begin
			rbusy <= `True_v;
			busy <= `True_v;
			rcnt <= 2'b00;
			mem_a <= mem_raddr;
			mem_wr <= 1'b0;
		end
	end

	//get data from ram
	always @ ( mem_dout ) begin
		if (rst == `True_v)begin
			mem_rdata <= `ZeroWord;
			busy <= 1'b0;
		end
		else if(rdy && rbusy == `True_v) begin
			mem_rdata[{rcnt, 3'b111}:{rcnt, 3'b000}] <= mem_dout;// merge data form lowest byte
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
			busy <= 1'b0;
		end
		else if (rdy && we == `True_v)begin
			wbusy <= `True_v;
			busy <= `True_v;
			wstart <= `False_v;
			wcnt <= 2'b00;
			mem_a <= mem_waddr;
			mem_wr <= 1'b1;
		end
	end

	always @ ( negedge clk ) begin
		if (rst == `True_v)begin
			busy <= 1'b0;
		end
		else if(rdy && wbusy == `True_v)
			if(wstart == `True_v)begin
				mem_din <= mem_wdata[{wcnt, 3'b111}:{wcnt, 3'b000}];
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
	output reg 					inst_busy,

	input wire 					re,
	input wire [31:0]			mem_raddr,
	output reg [31:0]			mem_rdata,
	output reg 					mem_rbusy,

	input wire 					we,
	input wire [31:0]			mem_waddr,
	input wire [31:0]			mem_wdata,
	output reg 					mem_wbusy
	);

	reg [31:0] raddr_inst, raddr_mem, waddr_mem, wdata_mem;

	always @ ( * ) begin
		if (rst == `True_v)begin
		end
		else if (rdy && mem_access_busy == `False_v) begin
			if (we == `True_v)
		end
	end








endmodule // Memory_ctrl
