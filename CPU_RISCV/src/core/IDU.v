`include "defines.v"

module IF_ID (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus] 		if_inst,
	input wire[4:0] 			stall,


	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst
	);

	always @ ( posedge clk ) begin
		if (rst != `RstDisable)begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end
		else if(rdy)begin
			if ((stall[0] & !stall[1])) begin
				id_pc <= `ZeroWord;
				id_inst	 <= `ZeroWord;
			end
			else if (!stall[1])begin
				id_pc <= if_pc;
				// if (if_inst != `ZeroWord)
				// 	$display("pc:%h::%h", if_inst, if_pc);
				id_inst <= if_inst;
			end
		end
	end

endmodule // IF_ID



module ID (
	input wire 					rst,
	input wire 					rdy,

	input wire[`InstAddrBus]	pc,
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
	output reg[31:0]			npc_addr
	);

	reg [31:0]					reg1, reg2, imm;
	wire [2:0]					func3 = inst[14:12];
	wire 						sign_lt, lt, eq;

	always @ ( * ) begin
		if (rst == `RstEnable)begin
			waddr <= 5'b00000;
			funct <= 1'b0;
		end
		else if(rdy) begin
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
		if (rst == `RstEnable)begin
			we <= `False_v;
			ma_we <= `False_v;
			ma_re <= `False_v;
			ma_width <= 3'b000;
			alusel <= 3'b000;
		end
		else if(rdy)  begin
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
		// else begin
		// 	we <= we;
		// 	ma_we <= ma_we;
		// 	ma_re <= ma_re;
		// 	ma_width <= ma_width;
		// 	alusel <= alusel;
		// end
	end

	wire [31:0] immu, immj, immi, immb, imms, immr;

	assign immu = {inst[31:12], {12{1'b0}}};
	assign immj = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
	assign immb = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
	assign imms = {{20{inst[31]}}, inst[30:25], inst[11:7]};
	assign immr = {{27{1'b0}}, inst[24:20]};
	assign immi = {{21{inst[31]}}, inst[30:20]};

	always @ ( * ) begin
		if (rst | ~rdy)begin
			imm <= `ZeroWord;
		end
		else begin
			case(inst[6:1])
				6'b011011, 6'b001011 : imm <= immu;
				6'b110111 : imm <= immj;
				6'b110001 : imm <= immb;
				6'b010001 : imm <= imms;
				6'b001001 :begin// I/R;
					if (func3 == 3'b001 || func3 == 3'b101)
						imm <= immr;
					else
						imm <= immi;
				end
				default: imm <= immi;//6'b110011 : //6'b000001 :
			endcase
		end
	end

	always @ ( * ) begin
		if (rst | ~rdy)begin
			re1 <= `False_v;
			re2 <= `False_v;
			raddr1 <= 5'b00000;
			raddr2 <= 5'b00000;
		end
		else begin
			if (inst[2] & ~(inst[6] & ~inst[3])) begin
				re1 <= `True_v;
				re2 <= `False_v;
				raddr1 <= 5'b00000;
				raddr2 <= 5'b00000;
			end
			else begin
				{raddr2, raddr1} <= inst[24:15];
				re2 <= inst[1] & inst[5];
				re1 <= `True_v;
			end
		end
	end
	always @ ( * ) begin
		if (rst | ~rdy)
			reg1 <= `ZeroWord;
		else begin
			if (re1 == `True_v) begin
				if (fwd_ex_we == `True_v && fwd_ex_waddr == raddr1 && fwd_ex_waddr != 5'b00000)
					reg1 <= fwd_ex_wdata;
				else if(fwd_ma_we == `True_v && fwd_ma_waddr == raddr1 && fwd_ma_waddr != 5'b00000)
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
			if (re2 == `True_v)begin
				if (fwd_ex_we == `True_v && fwd_ex_waddr == raddr2 && fwd_ex_waddr != 5'b00000)
					reg2 <= fwd_ex_wdata;
				else if(fwd_ma_we == `True_v && fwd_ma_waddr == raddr2 && fwd_ma_waddr != 5'b00000)
					reg2 <= fwd_ma_wdata;
				else
					reg2 <= rdata2;
			end
		end
	end

	assign sign_lt = $signed(reg1) < $signed(reg2);
	// assign sign_lt = ((reg1[31] & ~reg2[31])
	// 				| (reg1[31] & reg2[31] & (~reg1 + 1 > ~reg2 + 1))
	// 				| (~reg1[31] & ~reg2[31] & (reg1 < reg2)));
	assign eq = reg1 == reg2;
	assign lt = reg1 < reg2;

	always @ ( * ) begin
		if (rst)begin
			use_npc <= `False_v;
		end
		else if(rdy) begin
			use_npc <= inst[6] & (inst[2] | (~inst[14] & (eq ^ inst[12]))
						| (~inst[13] & inst[14] & (sign_lt ^ inst[12]))
						| (inst[13] & inst[14] & (lt ^ inst[12])));
		end
	end

	wire[31:0] 		npc1, npc2;
	assign npc1 = imm + reg1;
	assign npc2 = imm + pc;

	always @ ( * ) begin
		if (rst == `RstEnable)
			npc_addr <= `ZeroWord;
		else
			npc_addr = (inst[3:2] == 2'b01) ? {npc1[31:1], 1'b0} : npc2;
	end

	always @ ( * ) begin
		if (rst == `RstEnable) begin
			data1 <= `ZeroWord;
		end
		else if (rdy) begin
			if (inst[6:2] == 5'b00101)
				data1 <= imm;
			else if (inst[6:2] == 5'b11001)
				data1 <= `ZeroWord;
			else
				data1 <= reg1;
		end
		else
			data1 <= data1;
	end

	always @ ( * ) begin
		if (rst == `RstEnable) begin
			data2 <= `ZeroWord;
			extra_data = `ZeroWord;
		end
		else if (rdy) begin
			if(ma_we)begin
				data2 <= imm;
				extra_data <= reg2;
			end
			else begin
				if (inst[6:2] == 5'b00101)
					data2 <= pc;
				else if (inst[6] & inst[2])
					data2 <= pc + 4;
				else
					data2 <= (re2) ? reg2 : imm;
				extra_data <= imm;
			end
		end
		else begin
			data2 <= data2;
			extra_data = extra_data;
		end
	end

endmodule // ID
