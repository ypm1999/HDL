`include "defines.v"

module Ctrl (
	input wire 				clk,
	input wire 				rst,
	input wire 				rdy,

	input wire 				if_stall_req,
	input wire 				id_stall_req,
	input wire 				ex_stall_req,
	input wire 				ma_stall_req,

	output reg[4:0] 		stall_cmd
	);

	always @ (*) begin
		if (rst)
			stall_cmd <= 5'b00000;
		else if (rdy) begin
				if (ma_stall_req)
					stall_cmd <= 5'b01111;
				else if (if_stall_req)
					stall_cmd <= 5'b00001;
				else
					stall_cmd <= 5'b00000;
			end
		// else
		// 	stall_cmd <= stall_cmd;
	end

endmodule // Ctrl
