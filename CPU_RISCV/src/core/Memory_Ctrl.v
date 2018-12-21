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
	input wire [ 2:0]			width,
	input wire [31:0]			ram_addr,		//address of read or write
	input wire [31:0]			ram_wdata,		//data for writing to ram
	output reg [31:0]			ram_rdata,		//data read from ram

	output reg 					busy			//working busy singal
	);
	reg [7:0] 			tmp[0:2];
	reg [2:0] 			cnt;
	reg [3:0] 			sta;

	always @ ( posedge clk ) begin
		if (rst) begin
			sta <= 4'b0000;
			cnt <= 3'b000;
			{tmp[0], tmp[1], tmp[2]} <= 24'h000000;
			mem_dout <= 8'h00;
			mem_a <= `ZeroWord;
			mem_wr <= 1'b0;
			ram_rdata <= `ZeroWord;
			busy <= `False_v;
		end
		else if (rdy) begin
			case(sta)
				//wait status
				4'b0000:begin
					mem_wr <= 1'b0;
					if (re) begin
						cnt <= width;
						mem_a <= ram_addr;
						mem_wr <= 1'b0;
						if (width == 3'b100)
							sta <= 4'b0101;
						else
							sta <= width[1:0] + 4'b0001;
						busy <= `True_v;
					end
					else if(we) begin
						cnt <= width;
						mem_a <= ram_addr;
						mem_wr <= 1'b1;
						mem_dout <= ram_wdata[7:0];
						busy <= `True_v;
						if (width[0]) begin
							busy <= `False_v;
						end
						else sta <= 4'b1011;
					end
					else sta <= 4'b0000;
				end
				//read status
				4'b0001:begin
					if (cnt[0]) begin
						if(cnt[2])
							ram_rdata <= {24'h000000, mem_din};
						else
							ram_rdata <= {{25{mem_din[7]}}, mem_din[6:0]};

						busy <= `False_v;
						sta <= 4'b0000;
					end
					else if (cnt[1]) begin
						if(cnt[2])
							ram_rdata <= {16'h0000, mem_din, tmp[2]};
						else
							ram_rdata <= {{17{mem_din[7]}}, mem_din[6:0], tmp[2]};
						busy <= `False_v;
						sta <= 4'b0000;
					end
					else if (cnt[2]) begin
						ram_rdata <= {mem_din, tmp[2], tmp[1], tmp[0]};
						busy <= `False_v;
						sta <= 4'b0000;
					end
					else sta <= 1111;
				end
				4'b0010:begin
					tmp[2] <= mem_din;
					sta <= sta - 4'b0001;
				end
				4'b0011:begin
					mem_a <= mem_a + 1;
					tmp[1] <= mem_din;
					sta <= sta - 4'b0001;
				end
				4'b0100:begin
					mem_a <= mem_a + 1;
					tmp[0] <= mem_din;
					sta <= sta - 4'b0001;
				end
				4'b0101:begin
					mem_a <= mem_a + 1;
					sta <= sta - 4'b0001;
				end
				4'b0110:begin
					mem_a <= mem_a + 1;
					sta <= sta - 4'b0001;
				end
				//write status
				4'b1000:begin
					mem_a <= mem_a + 1;
					mem_dout <= ram_wdata[31:24];
					if (cnt[2]) begin
						busy <= `False_v;
						sta = 4'b0000;
					end
					else
						sta <= 4'b1111;
				end
				4'b1001:begin
					mem_a <= mem_a + 1;
					mem_dout <= ram_wdata[23:16];
					sta <= sta - 4'b0001;
				end

				4'b1011:begin
					mem_a <= mem_a + 1;
					mem_dout <= ram_wdata[15:8];
					if (cnt[1]) begin
						busy <= `False_v;
						sta = 4'b0000;
					end
					else
						sta <= 4'b1001;
				end
			endcase

		end
	end



endmodule // Memory_Accesser

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

	input wire 					ram_busy,		//following is wires to ram
	input wire [31:0] 			ram_rdata,

	output reg 					ram_we,
	output reg 					ram_re,
	output reg [2:0]			ram_width,
	output reg [31:0]			ram_addr,
	output reg [31:0]			ram_wdata
	);

	reg [ 2:0] 	sta;
	reg 		mem_work, inst_work;

	always @ ( posedge clk ) begin
		if (rst == `True_v)begin
			ram_we <= `False_v;
			ram_re <= `False_v;
			ram_addr <= `ZeroWord;
			ram_wdata <= `ZeroWord;
			ram_width <= 3'b000;
			mem_rdata <= `ZeroWord;
			mem_busy <= `False_v;
			inst_data <= `ZeroWord;
			inst_busy <= `False_v;
			sta <= 2'b00;
		end
		else if (rdy == `True_v)begin
			case (sta)
				2'b00: begin
					ram_we <= `False_v;
					ram_re <= `False_v;
					ram_addr <= `ZeroWord;
					ram_wdata <= `ZeroWord;
					ram_width <= 3'b000;
					if(mem_we) begin
						ram_we <= `True_v;
						ram_addr <= mem_addr;
						ram_wdata <= mem_wdata;
						ram_width <= mem_width;
						mem_busy <= `True_v;
						mem_busy <= `True_v;
						sta <= 2'b11;
					end
					else if (mem_re) begin
						ram_re <= `True_v;
						mem_busy <= `True_v;
						ram_addr <= mem_addr;
						ram_width <= mem_width;
						sta <= 2'b11;
					end
					else if (inst_re) begin
						ram_re <= `True_v;
						inst_busy <= `True_v;
						ram_addr <= inst_addr;
						ram_width <= 3'b100;
						sta <= 2'b11;
					end
					else sta <= 2'b00;
				end
				2'b01: sta <= 2'b00;
				2'b10: begin
					ram_we <= `False_v;
					ram_re <= `False_v;
					mem_rdata <= `ZeroWord;
					inst_data <= `ZeroWord;
					if (ram_busy == `False_v) begin
						if (mem_busy == `True_v) begin
							mem_busy <= `False_v;
							if(mem_re == `True_v)
								mem_rdata <= ram_rdata;
						end
						else if(inst_busy == `True_v) begin
							inst_busy <= `False_v;
							inst_data <= ram_rdata;
						end
						sta <= 2'b01;
					end
				end
				2'b11: sta <= 2'b10;
			endcase
		end
	end


endmodule // Memory_ctrl
