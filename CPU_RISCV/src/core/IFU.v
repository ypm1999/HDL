`include "defines.v"

module IF (
	input wire 				clk,
	(*MARK_DEBUG="TRUE"*) input wire 				rst,
	(*MARK_DEBUG="TRUE"*) input wire 				rdy,

	 input wire 				use_npc,
	input wire[31:0]		npc_addr,
	(*MARK_DEBUG="TRUE"*) input wire[31:0]		ram_inst,
	(*MARK_DEBUG="TRUE"*) input wire 				ram_inst_busy,
	input wire[4:0] 		stall,

	(*MARK_DEBUG="TRUE"*)output reg[31:0] 		pc,
	(*MARK_DEBUG="TRUE"*)output reg[31:0]		inst,
	(*MARK_DEBUG="TRUE"*)output reg				bj_stall,
	(*MARK_DEBUG="TRUE"*)output reg 				ram_inst_re,
	(*MARK_DEBUG="TRUE"*)output reg[31:0]		ram_inst_addr,

	(*MARK_DEBUG="TRUE"*)output reg 				stall_req
	);
	(*MARK_DEBUG="TRUE"*)reg 		 	try_stall, rst_stall;
	wire[31:0]		pcp4;
	assign pcp4 = pc + 4;

	always @ ( posedge clk ) begin
		if (rst)begin
			ram_inst_re <= `False_v;
			try_stall <= `False_v;
			bj_stall <= `False_v;
		end
		else if(rdy & ~stall[0]) begin
			if (inst[6] & ~bj_stall)begin
				ram_inst_re <= `False_v;
				bj_stall <= `True_v;
			end
			else if (use_npc) begin
				ram_inst_re <= `True_v;
				try_stall <= ~try_stall;
				bj_stall <= `False_v;
			end
			else begin
				ram_inst_re <= `True_v;
				try_stall <= ~try_stall;
				bj_stall <= `False_v;
			end
		end
		else begin
			ram_inst_re <= ram_inst_re;
			try_stall <= try_stall;
			bj_stall <= bj_stall;
		end
	end

	always @ ( posedge clk ) begin
		if (rst)begin
			pc <= -4;
			ram_inst_addr <= 32'hffffffff;
		end
		else if(rdy & ~stall[0] & (~inst[6] | bj_stall)) begin
			if (use_npc) begin
				pc <= npc_addr;
				ram_inst_addr <= npc_addr;
			end
			else begin
				pc <= pcp4;
				ram_inst_addr <= pcp4;
			end
		end
		else begin
			pc <= pc;
			ram_inst_addr <= ram_inst_addr;
		end
	end

	always @ ( rst or ram_inst_busy ) begin
			if (rst) begin
				rst_stall <= `False_v;
				inst <= `ZeroWord;
			end
			else if(rdy) begin
				if (ram_inst_re & !ram_inst_busy)begin
					rst_stall <= ~rst_stall;
					inst <= ram_inst;
				end
				else begin
					rst_stall <= rst_stall;
					inst <= `ZeroWord;
				end
			end
		end

		always @ ( * ) begin
			if (rst)
				stall_req <= `False_v;
			else if (rdy) begin
				stall_req <= (try_stall ^ rst_stall);
			end
		end

endmodule // pc_reg
