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
	(*MARK_DEBUG="TRUE"*)output reg 				ram_inst_re,
	(*MARK_DEBUG="TRUE"*)output reg[31:0]		ram_inst_addr,

	(*MARK_DEBUG="TRUE"*)output reg 				stall_req
	);

	reg [1:0] 			sta;

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			sta = 2'b00;
			pc <= -4;
			ram_inst_re <= `False_v;
			ram_inst_addr <= 32'hffffffff;
			stall_req <= `False_v;
		end
		else if(rdy == `True_v) begin
			case (sta)
				2'b00:begin
					if (stall[0] == `False_v) begin
						if (use_npc) begin
							pc <= npc_addr;
							ram_inst_re <= `True_v;
							ram_inst_addr <= npc_addr;
							stall_req <= `True_v;
						end
						else begin
							pc <= pc + 4;
							ram_inst_re <= `True_v;
							ram_inst_addr <= pc + 4;
							stall_req <= `True_v;
						end
						sta <= 2'b10;
					end
				end
				2'b01:begin
					if (ram_inst_re & !ram_inst_busy)begin
						stall_req <= `False_v;
						ram_inst_re <= `False_v;
						inst <= ram_inst;
						sta = 2'b11;
					end
				end
				2'b10:begin
					sta <= 2'b01;
				end
				default : sta <= 2'b00;
			endcase
		end
	end

endmodule // pc_reg
