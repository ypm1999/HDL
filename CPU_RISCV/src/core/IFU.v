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

	output reg[`RomAddrBus] pc,
	output reg[31:0]		inst,
	output reg 				ram_inst_re,
	output reg[31:0]		ram_inst_raddr,

	output reg 				stall_req
	);
	reg start, waiting;

	initial begin
		pc <= -4;
		start <= `False_v;
		waiting <= `False_v;
		ram_inst_re <= `False_v;
		ram_inst_raddr <= 8'hffffffff;
	end

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			pc <= -4;
			start <= `False_v;
			waiting <= `False_v;
			ram_inst_re <= `False_v;
			ram_inst_raddr <= 8'hffffffff;
		end
		else if(rdy == `True_v) begin
			ram_inst_re <= `False_v;
			if (stall[0] == `False_v) begin
				if (use_npc == `True_v)begin
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

	always @ ( ram_inst_busy ) begin
			if (rst == `RstEnable)begin
				stall_req <= `False_v;
				inst <= `ZeroWord;
			end
			else if(rdy == `True_v) begin
				if (ram_inst_busy == `True_v)begin
					stall_req = `True_v;
					inst <= `ZeroWord;
				end
				else begin
					stall_req <= `False_v;
					inst <= ram_inst;
				end
			end
		end

	//
	// always @ ( negedge ram_inst_busy ) begin
	// 	$display("negedge ram_inst_busy");
	// 	if (rst == `RstEnable)begin
	// 		stall_req <= `False_v;
	// 		inst <= `ZeroWord;
	// 	end
	// 	else if(rdy == `True_v && waiting == `True_v) begin
	// 		stall_req <= `False_v;
	// 		$display("stall_req <= false ::%d", ram_inst_busy);
	// 		inst <= ram_inst;
	// 		waiting <= `False_v;
	// 	end
	// end

endmodule // pc_reg
