`include "defines.v"

module ID_EX (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire[`AluOpBus] 		id_opcode,
	input wire[`AluSelBus] 		id_alusel,
	input wire 					id_funct,
	input wire[`RegBus]			id_data1,
	input wire[`RegBus]			id_data2,
	input wire 					id_we,
	input wire[`RegAddrBus]		id_waddr,
	input wire[`RegBus]			id_extra_data,
	output reg 					id_ma_we,
	output reg 					id_ma_re,
	output reg[ 2:0]			id_ma_width,
	input wire[4:0] 			stall,

	output reg[`AluOpBus] 		ex_opcode,
	output reg[`AluSelBus] 		ex_alusel,
	output reg 					ex_funct,
	output reg[`RegBus]			ex_data1,
	output reg[`RegBus]			ex_data2,
	output reg 					ex_we,
	output reg[`RegAddrBus]		ex_waddr,
	output reg[`RegBus]			ex_extra_data,
	output reg[`RegBus]			ex_wdata,
	output reg 					ex_ma_we,
	output reg 					ex_ma_re,
	output reg[ 2:0]			ex_ma_width,
	output reg[31:0]			ex_ma_addr,
	output reg[31:0]			ex_ma_wdata
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			ex_opcode <= 7'b0000000;
			ex_alusel <= 3'b000;
			ex_funct <= `False_v;
			ex_data1 <= `ZeroWord;
			ex_data2 <= `ZeroWord;
			ex_we <= `False_v;
			ex_waddr <= `ZeroWord;
		end
		else if (rdy == `True_v) begin
			if (stall[1] == `True_v && stall[2] == `False_v)begin
				ex_opcode <= 7'b0000000;
				ex_alusel <= 3'b000;
				ex_funct <= `False_v;
				ex_data1 <= `ZeroWord;
				ex_data2 <= `ZeroWord;
				ex_we <= `False_v;
				ex_waddr <= `ZeroWord;
			end
			else begin
				ex_opcode <= id_opcode;
				ex_alusel <= id_alusel;
				ex_funct <= id_funct;
				ex_data1 <= id_data1;
				ex_data2 <= id_data2;
				ex_we <= id_we;
				ex_waddr <= id_waddr;
				ex_extra_data <= id_extra_data;
				ex_ma_we <= id_ma_we;
				ex_ma_re <= id_ma_re;
				ex_ma_width <= id_ma_width;
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
	input wire[`RegBus]			reg1_in,
	input wire[`RegBus]			reg2_in,
	input wire 					we_in,
	input wire[`RegAddrBus]		waddr_in,
	input wire[`RegBus]			extra_data_in,

	input wire 					ma_we_in,
	input wire 					ma_re_in,
	input wire[ 3:0]			ma_width_in,

	output reg 					we,
	output reg[`RegAddrBus]		waddr,
	output reg[`RegBus]			wdata,

	output reg 					ma_we,
	output reg 					ma_re,
	output reg[ 2:0]			ma_width,
	output reg[31:0]			ma_addr,
	output reg[31:0]			ma_wdata,

	output reg 					stall_req
	);

	reg [31:0] 					alu_out, data1, data2;

	always @ ( * ) begin
		if(rst == `RstEnable) begin
			data1 <= `ZeroWord;
			data2 <= `ZeroWord;
		end
		else if(rdy == `True_v) begin
			if (ma_we_in | ma_re_in) begin
				data1 <= reg2_in;
				data2 <= extra_data_in;
			end
			else begin
				data1 <= reg1_in;
				data2 <= reg2_in;
			end
		end
	end

	always @ ( * ) begin
		if(rst == `RstEnable) begin
			alu_out <= `ZeroWord;
		end
		else if(rdy == `True_v) begin
			case (alusel)
				`AND_SEL: alu_out <= data1 & data2;
				`OR_SEL: alu_out <= data1 | data2;
				`XOR_SEL: alu_out <= data1 ^ data2;
				`ADD_SEL: alu_out <= data1 + data2;
				`SLT_SEL:  begin
					if (data1[31] && !data2[31] ||
						data1[31] && data2[31] && ((~data1) + 1) > ((~data2) + 1) ||
						!data1[31] && !data2[31] && data1 < data2)
						alu_out <= data1;
					else
						alu_out <= `ZeroWord;
				end
				`SLTU_SEL: begin
					if (data1 < data2)
						alu_out <= data1;
					else
						alu_out <= `ZeroWord;
				end

				`SLL_SEL: alu_out <= data1 << data2[4:0];
				`SRL_SEL: begin
					if (funct == `False_v)
						alu_out <= data1 >> data2[4:0];
					else
						alu_out <= (data1 >> data2[4:0]) | ({32{data1[31]}} << (6'd32-data2[4:0]));
				end

				default: alu_out <= `ZeroWord;
			endcase
		end
	end

	always @ ( * ) begin
		if(rst == `RstEnable)begin
			we <= `False_v;
			waddr <= 5'b00000;
			ma_we <= `False_v;
			ma_re <= `False_v;
			ma_width <= 3'b000;
			ma_addr <= `ZeroWord;
			ma_wdata <= `ZeroWord;
		end
		else if(rdy == `True_v)  begin
			we <= we_in;
			waddr <= waddr_in;
			wdata <= alu_out;
			ma_we <= ma_we_in;
			ma_re <= ma_re_in;
			ma_width <= ma_width_in;
			if (ma_we_in | ma_re_in) begin
				ma_addr <= alu_out;
				ma_wdata <= reg1_in;
			end
			else begin
				ma_addr <= `ZeroWord;
				ma_wdata <= `ZeroWord;
			end
			// $display("opcode:%b alusel:%b funct:%b\ndata1:%h  data2:%h\nwe:%b waddr:%d\n",
			// 		opcode, alusel, funct, data1, data2, we_in, waddr_in);
		end
	end

endmodule // EX
