`include "defines.v"

module IF (
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				use_npc,
	input wire[31:0]		npc_addr,
	input wire[4:0] 		stall,

	output reg[`RomAddrBus] pc,
	output reg 				if_inst_re,

	output reg 				stall_req
	);
	reg start;

	initial begin
		pc <= 0;
		start <= `False_v;
	end

	always @ ( posedge clk ) begin
		if (rst != `RstDisable)begin
			pc <= `ZeroWord;
			if_inst_re <= `False_v;
		end
		else if(rdy == `True_v && stall[0] == `False_v) begin
			if (use_npc == `True_v)
				pc <= npc_addr;
			else if (start == `True_v)
				pc <= pc + 4'h4;
			else start <= `True_v;
			if_inst_re <= `True_v;
		end
		else if_inst_re <= `False_v;
	end

endmodule // pc_reg
