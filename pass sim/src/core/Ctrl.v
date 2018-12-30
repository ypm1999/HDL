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
		if (rst == `True_v)
			stall_cmd <= 5'b00000;
		else if (rdy == `True_v) begin
				if (ma_stall_req == `True_v)
					stall_cmd <= 5'b01111;
				else if (ex_stall_req == `True_v)
					stall_cmd <= 5'b00111;
				else if (id_stall_req == `True_v)
					stall_cmd <= 5'b00011;
				else if (if_stall_req == `True_v)
					stall_cmd <= 5'b00001;
				else
					stall_cmd <= 5'b00000;
			end
	end

endmodule // Ctrl
