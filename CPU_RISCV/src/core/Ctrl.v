`include "defines.v"

module Ctrl (
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				if_stall_req,
	input wire 				id_stall_req,
	input wire 				ex_stall_req,
	input wire 				mem_stall_req,

	output reg[4:0] 		stall_cmd
	);

	always @ (*) begin
	if (rst == `True_v)
		stall_cmd <= 5'b00000;
	else if (rdy == `True_v) begin
			if (mem_stall_req == `True_v)
				stall_cmd <= 5'b11110;
			else if (ex_stall_req == `True_v)
				stall_cmd <= 5'b11100;
			else if (id_stall_req == `True_v)
				stall_cmd <= 5'b11000;
			else if (if_stall_req == `True_v)
				stall_cmd <= 5'b10000;
			else
				stall_cmd <= 5'b00000;
		end
	end

endmodule // Ctrl
