`include "defines.v"
//(* mark_debug="true" *)

module IF (
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				use_npc,
	input wire[16:0]		npc_addr,
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

	wire [16:0] 		npc = use_npc ? npc_addr : pc + 17'h4;
	wire [5:0] 			line = npc[8:4];
	wire [3:0] 			bb = npc[3:0];
	wire [7:0] 			tag = npc[16:9];
	integer i;

	wire [31:0]			inst_tmp = bb[3] ? (bb[2] ? icache[line][127:96] : icache[line][95:64])
											: (bb[2] ? icache[line][63:32] : icache[line][31:0]);
	wire 				hit = icache[line][136] && !(icache[line][135:128] ^ tag);
	wire 				b_or_l = inst_tmp[6] || !inst_tmp[6:4];

	always @ ( posedge clk ) begin
		if (rst) begin
			sta <= 2'b00;
			ram_inst_re <= `False_v;
			stall_req <= `False_v;
		end
		else if(rdy) begin
			case (sta)
				2'b00:begin
					if (!stall[0]) begin
						if (hit)begin
							stall_req <= `False_v;
							ram_inst_re <= `False_v;
							sta <= b_or_l ? 2'b11 : 2'b00;
						end
						else begin
							stall_req <= `True_v;
							ram_inst_re <= `True_v;
							sta <= 2'b10;
						end
					end
				end
				2'b01:begin
					if (~ram_inst_busy) begin
						stall_req <= `False_v;
						ram_inst_re <= `False_v;
						if (ram_inst[{pc[3:0], 3'b110}] || !ram_inst[{pc[3:0], 3'b100}+:3])
							sta <= 2'b11;
						else
							sta <= 2'b00;
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
					sta <= ram_inst_busy ? 2'b01 : 2'b10;
				end
				default : begin
					stall_req <= `False_v;
					ram_inst_re <= `False_v;
					sta <= stall[0] ? 2'b11 : 2'b00;
				end
			endcase
		end
	end

	always @ ( posedge clk ) begin
		if (rst) begin
			for(i = 0; i < 32; i = i + 1)
				icache[i][136] <= `False_v;
		end
		else if(rdy && sta == 2'b01) begin
			icache[pc[8:4]] <= {1'b1, pc[16:9], ram_inst};
		end
	end

	always @ ( posedge clk ) begin
		if (rst) begin
			pc <= -4;
			ram_inst_addr <= 32'hffffffff;
		end
		else if(rdy) begin
			if (!stall[0] && sta == 2'b00)begin
				pc <= npc;
				ram_inst_addr <= {npc[16:4], 4'b0000};
			end
		end
	end

	always @ ( posedge clk ) begin
		if (rst) begin
			inst <= `ZeroWord;
		end
		else if(rdy) begin
			case (sta)
				2'b00:inst <= stall ? inst : inst_tmp;
				2'b01:inst <= pc[3] ? (pc[2] ? ram_inst[127:96] : ram_inst[95:64])
									: (pc[2] ? ram_inst[63:32] : ram_inst[31:0]);
				2'b10:inst <= `ZeroWord;
				default:inst <= stall[0] ? inst : `ZeroWord;
			endcase
		end
	end

	// always @ ( posedge clk ) begin
	// 	if (rst) begin
	// 		sta <= 2'b00;
	// 		pc <= -4;
	// 		inst <= `ZeroWord;
	// 		ram_inst_re <= `False_v;
	// 		ram_inst_addr <= 32'hffffffff;
	// 		stall_req <= `False_v;
	// 		for(i = 0; i < 32; i = i + 1)
	// 			icache[i][136] <= `False_v;
	// 	end
	// 	else if(rdy) begin
	// 		case (sta)
	// 			2'b00:begin
	// 				if (!stall[0]) begin
	// 					pc <= npc;
	// 					ram_inst_addr <= {npc[16:4], 4'b0000};
	// 					inst <= icache[line][{bb, 3'b000}+:32];
	// 					if (icache[line][136] && !(icache[line][135:128] ^ tag))begin
	// 						stall_req <= `False_v;
	// 						ram_inst_re <= `False_v;
	// 						if (icache[line][{bb, 3'b110}] || icache[line][{bb, 3'b100}+:3] == 3'b000)
	// 							sta <= 2'b11;
	// 						else
	// 							sta <= 2'b00;
	// 					end
	// 					else begin
	// 						stall_req <= `True_v;
	// 						ram_inst_re <= `True_v;
	// 						sta <= 2'b10;
	// 					end
	// 				end
	// 			end
	// 			2'b01:begin
	// 				icache[pc[8:4]] <= {1'b1, pc[16:9], ram_inst};
	// 				inst <= ram_inst[{pc[3:0], 3'b000}+:32];
	// 				if (~ram_inst_busy) begin
	// 					stall_req <= `False_v;
	// 					ram_inst_re <= `False_v;
	// 					sta <= 2'b11;
	// 				end
	// 				else begin
	// 					stall_req <= `True_v;
	// 					ram_inst_re <= `True_v;
	// 					sta <= 2'b01;
	// 				end
	// 			end
	// 			2'b10:begin
	// 				stall_req <= `True_v;
	// 				ram_inst_re <= `True_v;
	// 				inst <= `ZeroWord;
	// 				if (ram_inst_busy)
	// 					sta <= 2'b01;
	// 				else
	// 					sta <= 2'b10;
	// 			end
	// 			default : begin
	// 				stall_req <= `False_v;
	// 				ram_inst_re <= `False_v;
	// 				if (!stall[0]) begin
	// 					sta <= 2'b00;
	// 					inst <= `ZeroWord;
	// 				end
	// 				else begin
	// 					sta <= 2'b11;
	// 					inst <= inst;
	// 				end
	// 			end
	// 		endcase
	// 	end
	// end

endmodule // pc_reg
