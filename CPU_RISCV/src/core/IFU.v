`include "defines.v"
//(* mark_debug="true" *)

module IF (
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				use_npc,
	input wire[31:0]		npc_addr,
	input wire[127:0]		ram_inst,
	input wire 				ram_inst_busy,
	input wire[4:0] 		stall,

	output reg[16:0] 		pc,
	output reg[31:0]		inst,
	output reg 				ram_inst_re,
	output reg[31:0]		ram_inst_addr,

	output reg 				stall_req
	);

	reg [1:0] 			sta;
	reg [136:0]			icache[31:0];

	wire [16:0] npc;
	wire [4:0] line;
	wire [3:0] bb;
	wire [7:0] tag;
	assign npc = use_npc ? npc_addr : pc + 17'h4;
	assign line = npc[8:4];
	assign bb = npc[3:0];
	assign tag = npc[16:9];

	integer i;
	always @ ( posedge clk ) begin
		if (rst) begin
			sta <= 2'b00;
			pc <= -4;
			inst <= `ZeroWord;
			ram_inst_re <= `False_v;
			ram_inst_addr <= 32'hffffffff;
			stall_req <= `False_v;
			for(i = 0; i < 32; i = i + 1)
				icache[i][136] <= `False_v;
		end
		else if(rdy) begin
			case (sta)
				2'b00:begin
					if (!stall[0]) begin
						pc <= npc;
						ram_inst_addr <= {npc[16:4], 4'b0000};
						inst <= icache[line][{bb, 3'b000}+:32];
						if (icache[line][136] && !(icache[line][135:128] ^ tag))begin
							stall_req <= `False_v;
							ram_inst_re <= `False_v;
							sta <= 2'b11;
						end
						else begin
							stall_req <= `True_v;
							ram_inst_re <= `True_v;
							sta <= 2'b10;
						end
					end
				end
				2'b01:begin
					icache[pc[8:4]] <= {1'b1, pc[16:9], ram_inst};
					inst <= ram_inst[{pc[3:0], 3'b000}+:32];
					if (~ram_inst_busy) begin
						stall_req <= `False_v;
						ram_inst_re <= `False_v;
						sta <= 2'b11;
					end
					else begin
						stall_req <= `True_v;
						ram_inst_re <= `True_v;
						sta <= 2'b01;
					end
				end
				2'b10:begin
					stall_req <= `True_v;
					ram_inst_re <= `True_v;
					inst <= `ZeroWord;
					sta <= 2'b01;
				end
				default : begin
					stall_req <= `False_v;
					ram_inst_re <= `False_v;
					if (!stall[0]) begin
						sta <= 2'b00;
						inst <= `ZeroWord;
					end
					else begin
						sta <= 2'b11;
						inst <= inst;
					end
				end
			endcase
		end
	end

endmodule // pc_reg
