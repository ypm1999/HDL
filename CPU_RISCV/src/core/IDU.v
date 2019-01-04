`include "defines.v"

module IF_ID (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire[16:0]			if_pc,
	input wire[`InstBus] 		if_inst,
	input wire[4:0] 			stall,

	output reg[16:0]			id_pc,
	output reg[`InstBus]		id_inst
	);

	always @ ( posedge clk ) begin
		if (rst)begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end
		else if(rdy & ~stall[1])begin
			if (stall[0]) begin
				id_pc <= `ZeroWord;
				id_inst	 <= `ZeroWord;
			end
			else begin
				id_pc <= if_pc;
				id_inst <= if_inst;
				// if (if_inst != `ZeroWord)
				// 	$display("pc:%h::%h", if_pc, if_inst);
			end
		end
	end

endmodule // IF_ID



module ID (
	input wire 					rst,
	input wire 					rdy,

	input wire[16:0]			pc,
	input wire[`InstBus] 		inst,

	input wire[`RegBus]			rdata1,
	input wire[`RegBus]			rdata2,

	input wire 					fwd_ex_we,
	input wire[`RegAddrBus]		fwd_ex_waddr,
	input wire[`RegBus]			fwd_ex_wdata,
	input wire 					fwd_ma_we,
	input wire[4:0]				fwd_ma_waddr,
	input wire[31:0]			fwd_ma_wdata,

	output reg[`AluSelBus] 		alusel,
	output reg					funct,

	output reg 					re1,
	output reg 					re2,
	output reg[`RegAddrBus]		raddr1,
	output reg[`RegAddrBus]		raddr2,

	output reg[31:0]			data1,
	output reg[31:0]			data2,

	output reg 					we,
	output reg[ 4:0]			waddr,
	output reg[31:0]			extra_data,

	output reg 					ma_we,
	output reg 					ma_re,
	output reg[ 2:0]			ma_width,

	output reg 					use_npc,
	output reg[16:0]			npc_addr
	);

	reg [31:0]					reg1, reg2, imm;
	wire [2:0]					func3 = inst[14:12];
	wire 						sign_lt, lt, eq;

	always @ ( * ) begin
		if (rst | ~rdy) begin
			waddr <= 5'b00000;
			funct <= 1'b0;
		end
		else begin
			waddr <= inst[11:7];
			if ((inst[6:1] == 6'b001001) && (inst[14:12] == 3'b101) ||
				(inst[6:1] == 6'b011001))begin
				funct <= inst[30];
			end
			else begin
				funct <= 1'b0;
			end
		end
	end

	always @ ( * ) begin
		if (rst | ~rdy) begin
			we <= `False_v;
			ma_we <= `False_v;
			ma_re <= `False_v;
			ma_width <= 3'b000;
			alusel <= 3'b000;
		end
		else begin
			we <= `True_v;
			ma_we <= `False_v;
			ma_re <= `False_v;
			alusel <= 3'b000;
			case(inst[6:1])
				6'b011011, 6'b001011, 6'b110111, 6'b110011 :begin// U
					ma_width <= 3'b000;
				end
				6'b000001 :begin // I
					ma_re <= `True_v;
					ma_width <= inst[14:12];
				end
				6'b010001 :begin// S
					we <= `False_v;
					ma_we <= `True_v;
					ma_width <= inst[14:12];
				end
				6'b001001, 6'b011001 :begin// I/R;
					alusel <= inst[14:12];
					ma_width <= 3'b000;
				end
				default: begin
					we <= `False_v;
					ma_we <= `False_v;
					ma_re <= `False_v;
					ma_width <= 3'b000;
					alusel <= 3'b000;
				end
			endcase
		end
	end

	wire [31:0] immu, immj, immi, immb, imms, immr, immir;

	assign immu = {inst[31:12], {12{1'b0}}};
	assign immj = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
	assign immb = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
	assign imms = {{20{inst[31]}}, inst[30:25], inst[11:7]};
	assign immr = {{27{1'b0}}, inst[24:20]};
	assign immi = {{21{inst[31]}}, inst[30:20]};
	assign immir = ((func3 ^ 3'b001) & (func3 ^ 3'b101)) ? immi : immr;

	always @ ( * ) begin
		case(inst[6:2])
			5'b01101, 5'b00101 : imm <= immu;
			5'b11011 : imm <= immj;
			5'b11000 : imm <= immb;
			5'b01000 : imm <= imms;
			5'b00100 : imm <= immir;
			default: imm <= immi;//6'b110011 : //6'b000001 :
		endcase
	end

	wire re = (inst[2] & ~(inst[6] & ~inst[3]));

	always @ ( * ) begin
		if (rst | ~rdy)begin
			re1 <= `False_v;
			raddr1 <= 5'b00000;
		end
		else begin
			re1 <= `True_v;
			raddr1 <= re ? 5'b00000 : inst[19:15];
		end
	end

	always @ ( * ) begin
		if (rst | ~rdy)begin
			re2 <= `False_v;
			raddr2 <= 5'b00000;
		end
		else begin
			raddr2 <= inst[24:20];
			re2 <= ~re & inst[1] & inst[5];
		end
	end

	wire 	reg1_use_ex, reg2_use_ex, reg1_use_ma, reg2_use_ma;
	assign reg1_use_ex = fwd_ex_we & (fwd_ex_waddr == raddr1) & (fwd_ex_waddr != 5'b00000);
	assign reg2_use_ex = fwd_ex_we & (fwd_ex_waddr == raddr2) & (fwd_ex_waddr != 5'b00000);
	assign reg1_use_ma = fwd_ma_we & (fwd_ma_waddr == raddr1) & (fwd_ma_waddr != 5'b00000);
	assign reg2_use_ma = fwd_ma_we & (fwd_ma_waddr == raddr2) & (fwd_ma_waddr != 5'b00000);



		always @ ( * ) begin
			if (rst | ~rdy)
				reg1 <= `ZeroWord;
			else begin
				if (re1) begin
					if (reg1_use_ex)
						reg1 <= fwd_ex_wdata;
					else
					if(reg1_use_ma)
						reg1 <= fwd_ma_wdata;
					else
						reg1 <= rdata1;
				end
			end
		end

		always @ ( * ) begin
			if (rst | ~rdy)
				reg2 <= `ZeroWord;
			else  begin
				if (re2)begin
					if (reg2_use_ex)
						reg2 <= fwd_ex_wdata;
					else
					if(reg2_use_ma)
						reg2 <= fwd_ma_wdata;
					else
						reg2 <= rdata2;
				end
			end
		end

	assign sign_lt = (~inst[13] & inst[14]) & (($signed(reg1) < $signed(reg2)) ^ inst[12]);
	assign eq = ~inst[14] & (!(reg1 ^ reg2) ^ inst[12]);
	assign lt = (inst[13] & inst[14]) & ((reg1 < reg2) ^ inst[12]);

	always @ ( * ) begin
		use_npc <= inst[6] & ((inst[2] | eq) | (sign_lt | lt));
	end

	wire[16:0] 		npc1, npc2;
	assign npc1 = imm[16:0] + reg1[16:0];
	assign npc2 = imm[16:0] + pc;

	always @ ( * ) begin
		npc_addr <= (inst[3:2] ^ 2'b01) ? npc2 : {npc1[16:1], 1'b0};
	end

	always @ ( * ) begin
		if (rst | ~rdy) begin
			data1 <= `ZeroWord;
		end
		else begin
			if (inst[6:2] == 5'b00101)
				data1 <= imm;
			else if (inst[6:2] == 5'b11001)
				data1 <= `ZeroWord;
			else
				data1 <= reg1;
		end
	end

	always @ ( * ) begin
		if (rst | ~rdy)
			data2 <= `ZeroWord;
		else begin
			if(ma_we)
				data2 <= imm;
			else if (inst[6:2] == 5'b00101)
				data2 <= pc;
			else if (inst[6] & inst[2])
				data2 <= pc + 4;
			else
				data2 <= (re2) ? reg2 : imm;
		end
	end

	always @ ( * ) begin
		if (rst | ~rdy)
			extra_data <= `ZeroWord;
		else begin
			extra_data <= ma_we ? reg2 : imm;
		end
	end

endmodule // ID
