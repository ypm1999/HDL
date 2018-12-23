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
	output reg				bj_stall,
	output reg 				ram_inst_re,
	output reg[31:0]		ram_inst_addr,

	output reg 				stall_req
	);
	reg 		 	try_stall, rst_stall;
	wire[31:0]		pcp4;
	assign pcp4 = pc + 4;


	always @ ( posedge clk ) begin
		if (rst)begin
			ram_inst_re <= `False_v;
			try_stall <= `False_v;
			bj_stall <= `False_v;
		end
		else if(rdy) begin
			if (~stall[0]) begin
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
		end
	end

	always @ ( posedge clk ) begin
		if (rst)begin
			pc <= -4;
			ram_inst_addr <= 32'hffffffff;
		end
		else if(rdy) begin
			if (~stall[0] & (~inst[6] | bj_stall)) begin
				if (use_npc) begin
					pc <= npc_addr;
					ram_inst_addr <= npc_addr;
				end
				else begin
					pc <= pcp4;
					ram_inst_addr <= pcp4;
				end
			end
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
