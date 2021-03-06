`include "defines.v"


module Memory_Ctrl (
	input  wire                 clk,
    input  wire                 rst,
	input  wire					rdy,

	input wire 					inst_re,		//instruction read enable
	input wire [31:0]			inst_addr,		//instruction read address
	output reg [127:0]			inst_data,		//instruction data read from ram
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

	//reg [31:0]	rdata;
	reg [ 4:0] 	now, cnt;
	reg [ 1:0] 	sta;
	//wait command
	//run read
	//run write
	//stall

	always @ ( posedge clk ) begin
		if (rst)begin
			ram_a <= `ZeroWord;
			ram_dout <= 8'h00;
			mem_rdata <= `ZeroWord;
			inst_data <= `ZeroWord;
		end
		else if (rdy) begin
			case (sta)
				2'b00: begin
					ram_dout <= mem_wdata[7:0];
					ram_a <= (mem_we | mem_re) ? mem_addr : inst_addr;
					if (mem_re)
						mem_rdata <= `ZeroWord;
					else
						inst_data <= `ZeroWord;
				end
				2'b01: begin
					if (now + 5'b00001 < cnt)
						ram_a <= ram_a + 1;
					if (inst_busy)
						inst_data[{now - 5'b00001, 3'b000}+:8] <= now ? ram_din : 8'h00;
					else
						mem_rdata[{now[2:0] - 3'b001, 3'b000}+:8] <= now ? ram_din : 8'h00;
				end
				2'b10: begin
					if (now[2:0] != cnt[2:0]) begin
						ram_dout <= mem_wdata[{now[2:0], 3'b000}+:8];
						ram_a <= ram_a + 1;
					end
				end
				default: begin
					ram_a <= `ZeroWord;
					ram_dout <= 8'h00;
					mem_rdata <= `ZeroWord;
					inst_data <= `ZeroWord;
				end
			endcase
		end
	end




		always @ ( posedge clk ) begin
			if (rst)begin
				sta <= 2'b00;
				now <= 5'b00000;
				cnt <= 5'b00000;
				mem_busy <= `False_v;
				inst_busy <= `False_v;
				ram_wr <= 1'b0;
			end
			else if (rdy) begin
				case (sta)
					2'b00: begin
						if (mem_we)begin
							ram_wr <= 1'b1;
							now[2:0] <= 3'b001;
							mem_busy <= `True_v;
							sta <= 2'b10;
							cnt[2:0] <= {mem_width[1:0], ~(mem_width[0] | mem_width[1])};
						end
						else if (mem_re) begin
							ram_wr <= 1'b0;
							now <= 5'b00000;
							mem_busy <= `True_v;
							sta <= 2'b01;
							case (mem_width[1:0])
								2'b00: cnt <= 5'b00001;
								2'b01: cnt <= 5'b00010;
								2'b10: cnt <= 5'b00100;
								default: cnt <= 5'b00000;
							endcase
						end
						else if (inst_re) begin
							ram_wr <= 1'b0;
							now <= 5'b00000;
							inst_busy <= `True_v;
							sta <= 2'b01;
							cnt <= 5'b10000;
						end
						else begin
							ram_wr <= 1'b0;
							mem_busy <= `False_v;
							inst_busy <= `False_v;
							sta <= 2'b00;
							now <= 5'b00000;
							cnt <= 5'b00000;
						end
					end
					2'b01: begin
						if (now == cnt) begin
							now <= 5'b00000;
							cnt <= 5'b00000;
							if (inst_busy)
								inst_busy <= `False_v;
							else
								mem_busy <= `False_v;
							sta <= 2'b11;
						end
						else begin
							now = now + 5'b00001;
							mem_busy <= mem_busy;
							inst_busy <= inst_busy;
							sta <= 2'b01;
						end
					end
					2'b10: begin
						if (now[2:0] == cnt[2:0]) begin
							now[2:0] = 3'b000;
							mem_busy <= `False_v;
							sta <= 2'b11;
						end
						else begin
							now[2:0] = now[2:0] + 3'b001;
							mem_busy <= `True_v;
							sta <= 2'b10;
						end
					end
					default: begin
						sta <= 2'b00;
						now <= 5'b00000;
						cnt <= 5'b00000;
						mem_busy <= `False_v;
						inst_busy <= `False_v;
						ram_wr <= 1'b0;
					end
				endcase
			end
		end


	//
	// always @ ( posedge clk ) begin
	// 	if (rst)begin
	// 		sta <= 2'b00;
	// 		now <= 5'b00000;
	// 		cnt <= 5'b00000;
	// 		mem_busy <= `False_v;
	// 		inst_busy <= `False_v;
	// 		ram_wr <= 1'b0;
	// 		ram_a <= `ZeroWord;
	// 		ram_dout <= `ZeroWord;
	// 	end
	// 	else if (rdy) begin
	// 		case (sta)
	// 			2'b00: begin
	// 				ram_dout <= mem_wdata[7:0];
	// 				if (mem_we)begin
	// 					ram_a <= mem_addr;
	// 					ram_wr <= 1'b1;
	// 					now[2:0] <= 3'b001;
	// 					mem_busy <= `True_v;
	// 					sta <= 2'b10;
	// 					cnt[2:0] <= {mem_width[1:0], ~(mem_width[0] | mem_width[1])};
	// 				end
	// 				else if (mem_re) begin
	// 					mem_rdata <= `ZeroWord;
	// 					ram_a <= mem_addr;
	// 					ram_wr <= 1'b0;
	// 					now <= 5'b00000;
	// 					mem_busy <= `True_v;
	// 					sta <= 2'b01;
	// 					case (mem_width[1:0])
	// 						2'b00: cnt <= 5'b00001;
	// 						2'b01: cnt <= 5'b00010;
	// 						2'b10: cnt <= 5'b00100;
	// 						default: cnt <= 5'b00000;
	// 					endcase
	// 				end
	// 				else if (inst_re) begin
	// 					inst_data <= `ZeroWord;
	// 					ram_a <= inst_addr;
	// 					ram_wr <= 1'b0;
	// 					now <= 5'b00000;
	// 					inst_busy <= `True_v;
	// 					sta <= 2'b01;
	// 					cnt <= 5'b10000;
	// 				end
	// 				else begin
	// 					ram_wr <= 1'b0;
	// 					mem_busy <= `False_v;
	// 					inst_busy <= `False_v;
	// 					sta <= 2'b00;
	// 					now <= 5'b00000;
	// 					cnt <= 5'b00000;
	// 				end
	// 			end
	// 			2'b01: begin
	// 				if (now + 5'b00001 < cnt)
	// 					ram_a <= ram_a + 1;
	// 				if (now)
	// 					if (inst_busy)
	// 						inst_data[{now - 5'b00001, 3'b000}+:8] <= ram_din;
	// 					else
	// 						mem_rdata[{now[2:0] - 3'b001, 3'b000}+:8] <= ram_din;
	// 				if (now == cnt) begin
	// 					now <= 5'b00000;
	// 					cnt <= 5'b00000;
	// 					if (inst_busy)
	// 						inst_busy <= `False_v;
	// 					else
	// 						mem_busy <= `False_v;
	// 					sta <= 2'b11;
	// 				end
	// 				else begin
	// 					now = now + 5'b00001;
	// 					mem_busy <= mem_busy;
	// 					inst_busy <= inst_busy;
	// 					sta <= 2'b01;
	// 				end
	// 			end
	// 			2'b10: begin
	// 				if (now[2:0] == cnt[2:0]) begin
	// 					now[2:0] = 3'b000;
	// 					mem_busy <= `False_v;
	// 					sta <= 2'b11;
	// 				end
	// 				else begin
	// 					ram_dout <= mem_wdata[{now[2:0], 3'b000}+:8];
	// 					ram_a <= ram_a + 1;
	// 					now[2:0] = now[2:0] + 3'b001;
	// 					mem_busy <= `True_v;
	// 					sta <= 2'b10;
	// 				end
	// 			end
	// 			default: begin
	// 				sta <= 2'b00;
	// 				now <= 5'b00000;
	// 				cnt <= 5'b00000;
	// 				mem_busy <= `False_v;
	// 				inst_busy <= `False_v;
	// 				ram_wr <= 1'b0;
	// 				ram_a <= `ZeroWord;
	// 				ram_dout <= `ZeroWord;
	// 			end
	// 		endcase
	// 	end
	// end

endmodule // Memory_ctrl
