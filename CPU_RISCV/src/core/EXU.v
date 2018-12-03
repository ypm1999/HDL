`include "defines.v"

module ID_EX (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire[`AluOpBus] 		opcode_id,
	input wire[`AluSelBus] 		alusel_id,
	input wire 					funct_id,
	input wire[`RegBus]			data1_id,
	input wire[`RegBus]			data2_id,
	input wire 					we_id,
	input wire[`RegAddrBus]		waddr_id,
	input wire[4:0] 			stall,

	output reg[`AluOpBus] 		opcode_ex,
	output reg[`AluSelBus] 		alusel_ex,
	output reg 					funct_ex,
	output reg[`RegBus]			data1_ex,
	output reg[`RegBus]			data2_ex,
	output reg 					we_ex,
	output reg[`RegAddrBus]		waddr_ex
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			opcode_ex <= 7'b0000000;
			alusel_ex <= 3'b000;
			funct_ex <= `False_v;
			data1_ex <= `ZeroWord;
			data2_ex <= `ZeroWord;
			we_ex <= `False_v;
			waddr_ex <= `ZeroWord;
		end
		else if (rdy == `True_v) begin
			if (stall[1] == `True_v && stall[2] == `False_v)begin
				opcode_ex <= 7'b0000000;
				alusel_ex <= 3'b000;
				funct_ex <= `False_v;
				data1_ex <= `ZeroWord;
				data2_ex <= `ZeroWord;
				we_ex <= `False_v;
				waddr_ex <= `ZeroWord;
			end
			else begin
				opcode_ex <= opcode_id;
				alusel_ex <= alusel_id;
				funct_ex <= funct_id;
				data1_ex <= data1_id;
				data2_ex <= data2_id;
				we_ex <= we_id;
				waddr_ex <= waddr_id;
			end
			// $display("opcode:%b alusel:%b funct:%b\ndata1:%h  data2:%h\nwe:%b waddr:%d",
			// 		opcode_id, alusel_id, funct_id, data1_id, data2_id, we_id, waddr_id);
		end
	end

endmodule // ID_EX



module EX (
	input wire 					rst,
	input wire 					rdy,

	input wire[`AluOpBus] 		opcode,
	input wire[`AluSelBus] 		alusel,
	input wire 					funct,
	input wire[`RegBus]			data1,
	input wire[`RegBus]			data2,
	input wire 					we_in,
	input wire[`RegAddrBus]		waddr_in,

	output reg 					we,
	output reg[`RegAddrBus]		waddr,
	output reg[`RegBus]			wdata,

	output reg 					stall_req
	);

	always @ ( * ) begin
		if(rst == `RstEnable)begin
			we <= `False_v;
			waddr <= 5'b00000;
		end
		else if(rdy == `True_v)  begin
			we <= we_in;
			waddr <= waddr_in;
			// $display("opcode:%b alusel:%b funct:%b\ndata1:%h  data2:%h\nwe:%b waddr:%d\n",
			// 		opcode, alusel, funct, data1, data2, we_in, waddr_in);
		end
	end

	always @ ( * ) begin
		if(rst == `RstEnable) begin
			wdata <= `ZeroWord;
		end
		else if(rdy == `True_v) begin
			case (alusel)
				`AND_SEL: wdata <= data1 & data2;
				`OR_SEL: wdata <= data1 | data2;
				`XOR_SEL: wdata <= data1 ^ data2;
				`ADD_SEL: wdata <= data1 + data2;
				`SLT_SEL:  begin
					if (data1[31] && !data2[31] ||
						data1[31] && data2[31] && ((~data1) + 1) > ((~data2) + 1) ||
						!data1[31] && !data2[31] && data1 < data2)
						wdata <= data1;
					else
						wdata <= `ZeroWord;
				end
				`SLTU_SEL: begin
					if (data1 < data2)
						wdata <= data1;
					else
						wdata <= `ZeroWord;
				end

				`SLL_SEL: wdata <= data1 << data2[4:0];
				`SRL_SEL: begin
					if (funct == `False_v)
						wdata <= data1 >> data2[4:0];
					else
						wdata <= (data1 >> data2[4:0]) | ({32{data1[31]}} << (6'd32-data2[4:0]));
				end

				default: wdata <= `ZeroWord;
			endcase
		end
	end
endmodule // EX
