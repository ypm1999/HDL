`include "defines.v"

module IF (
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				use_npc,
	input wire[31:0]		npc_addr,
	input wire[31:0]		ram_inst,
	input wire 				ram_inst_busy,
	input wire[4:0] 		stall,

	output reg[31:0] 		pc,
	output reg[31:0]		inst,
	output reg 				ram_inst_re,
	output reg[31:0]		ram_inst_raddr,

	output reg 				stall_req
	);
	reg bj_stall, reset_bj;


	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			pc <= -4;
			ram_inst_re <= `False_v;
			ram_inst_raddr <= 32'hffffffff;
		end
		else if(rdy == `True_v) begin
			if (stall[0] == `False_v) begin
				if (ram_inst_re)
					ram_inst_re <= `False_v;
				else if (use_npc) begin
					pc <= npc_addr;
					ram_inst_raddr <= npc_addr;
					ram_inst_re <= `True_v;
				end
				else begin
					pc <= pc + 4;
					ram_inst_raddr <= pc + 4;
					ram_inst_re <= `True_v;
				end
			end
		end
	end

	always @ ( * ) begin
			if (rst == `RstEnable)begin
				stall_req <= `False_v;
				inst <= `ZeroWord;
			end
			else if(rdy == `True_v) begin
				if (ram_inst_busy)begin
					stall_req = `True_v;
					inst <= `ZeroWord;
				end
				else begin
					stall_req <= `False_v;
					ram_inst_re <= `False_v;
					inst <= ram_inst;
				end
			end
		end

	// always @ ( * ) begin
	// 	if (inst[6:4] == 3'b110 || !reset_bj)
	// 		bj_stall <= `True_v;
	// 	else
	// 		bj_stall <= `False_v;
	// end

endmodule // pc_reg
