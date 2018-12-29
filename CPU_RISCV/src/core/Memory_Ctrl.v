`include "defines.v"


module Memory_Ctrl (
	input  wire                 clk,
    input  wire                 rst,
	input  wire					rdy,

	input wire 					inst_re,		//instruction read enable
	input wire [31:0]			inst_addr,		//instruction read address
	output reg [31:0]			inst_data,		//instruction data read from ram
	output reg 					inst_busy,		//instruction reading busy signal

	input wire 					mem_we,
	input wire 					mem_re,			//mem read enable
	input wire [31:0]			mem_addr,		//mem read address
	input wire [2:0] 			mem_width,
	input wire [31:0]			mem_wdata,
	output reg [31:0]			mem_rdata,		//mem data read from ram
	output reg 					mem_busy,		//mem reading busy signal


	input  wire[ 7:0]          ram_din,		// data input bus
    output reg [ 7:0]          ram_dout,		// data output bus
    output reg [31:0]          ram_a,			// address bus (only 17:0 is used)
    output reg                 ram_wr			// write/read signal (1 for write)
	);

	reg [31:0]	rdata;
	reg [ 2:0] 	now, cnt;
	reg [ 1:0] 	sta;
	reg 		unsign;
	//wait command
	//run read
	//run write
	//stall

	always @ ( posedge clk, posedge rst ) begin
		if (rst)begin
			sta <= 2'b00;
			now <= 3'b000;
			cnt <= 3'b000;
			mem_busy <= `False_v;
			inst_busy <= `False_v;
			unsign <= `False_v;
			ram_wr <= 1'b0;
			ram_a <= `ZeroWord;
			ram_dout <= `ZeroWord;
			rdata <= `ZeroWord;
		end
		else if (rdy) begin
			case (sta)
				2'b00: begin
					unsign <= mem_width[2];
					ram_dout <= mem_wdata[7:0];
					rdata <= `ZeroWord;
					if (mem_we)begin
						ram_a <= mem_addr;
						ram_wr <= 1'b1;
						now <= 3'b001;
						case (mem_width[1:0])
							2'b01, 2'b10: begin
								mem_busy <= `True_v;
								sta <= 2'b10;
								cnt <= {1'b0, mem_width[1:0]} | 3'b001;
							end
							default: begin
								mem_busy <= `False_v;
								sta <= 2'b00;
								cnt <= 3'b000;
							end
						endcase
					end
					else if (mem_re) begin
						ram_a <= mem_addr;
						ram_wr <= 1'b0;
						now <= 3'b000;
						mem_busy <= `True_v;
						sta <= 2'b01;
						case (mem_width[1:0])
							2'b00: cnt <= 3'b001;
							2'b01: cnt <= 3'b010;
							2'b10: cnt <= 3'b100;
							default: cnt <= 3'b000;
						endcase
					end
					else if (inst_re) begin
						ram_a <= inst_addr;
						ram_wr <= 1'b0;
						now <= 3'b000;
						inst_busy <= `True_v;
						sta <= 2'b01;
						cnt <= 3'b100;
					end
					else begin
						ram_wr <= 1'b0;
						now <= 3'b000;
						mem_busy <= `False_v;
						inst_busy <= `False_v;
						sta <= 2'b00;
						cnt <= 3'b000;
					end
				end
				2'b01: begin
					ram_a <= ram_a + 1;
					if (now)
						rdata[{now - 3'b001, 3'b000}+:8] <= ram_din;
					else
						rdata <= rdata;
					if (now == cnt) begin
						now = 3'b000;
						mem_busy <= `False_v;
						inst_busy <= `False_v;
						sta <= 2'b11;
					end
					else begin
						now = now + 3'b001;
						mem_busy <= mem_busy;
						inst_busy <= inst_busy;
						sta <= 2'b01;
					end
				end
				2'b10: begin
					ram_dout <= mem_wdata[{now, 3'b000}+:8];
					ram_a <= ram_a + 1;
					if (now == cnt) begin
						now = 3'b000;
						mem_busy <= `False_v;
						sta <= 2'b00;
					end
					else begin
						now = now + 3'b001;
						mem_busy <= `True_v;
						sta <= 2'b10;
					end
				end
				default: begin
					sta <= 2'b00;
					now <= 3'b000;
					cnt <= 3'b000;
					mem_busy <= `False_v;
					inst_busy <= `False_v;
					unsign <= `False_v;
					ram_wr <= 1'b0;
					ram_a <= `ZeroWord;
					ram_dout <= `ZeroWord;
					rdata <= `ZeroWord;
				end
			endcase
		end
	end

	always @ ( * ) begin
		if (rst) begin
			inst_data <= `ZeroWord;
			mem_rdata <= `ZeroWord;
		end
		else if (rdy) begin
			inst_data <= rdata;
			if (unsign) begin
				mem_rdata <= cnt[0] ? {{25{rdata[7]}}, rdata[6:0]} :
									{{17{rdata[15]}},  rdata[14:0]};
			end
			else
				mem_rdata <= rdata;
		end
		else begin
			inst_data <= inst_data;
			mem_rdata <= mem_rdata;
		end
	end

endmodule // Memory_ctrl
