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
		else if(rdy == `True_v)begin
			if(stall[1] == `False_v && stall[0] == `True_v)begin
				id_pc <= `ZeroWord;
				id_inst	 <= `ZeroWord;
			end
			else if (stall[0] == `False_v)begin
				id_pc <= if_pc;
				id_inst <= if_inst;
			end
			// $display("IF_ID:: inst:%d", if_inst);
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

	input wire 					ex_we,
	input wire[`RegAddrBus]		ex_waddr,
	input wire[`RegBus]			ex_wdata,

	input wire 					mem_we,
	input wire[`RegAddrBus]		mem_waddr,
	input wire[`RegBus]			mem_wdata,

	output reg[`AluOpBus] 		aluop,
	output reg[`AluSelBus] 		alusel,

	output reg					funct,

	output reg 					re1,
	output reg 					re2,
	output reg[`RegAddrBus]		raddr1,
	output reg[`RegAddrBus]		raddr2,

	output reg[`RegBus]			reg1,
	output reg[`RegBus]			reg2,

	output reg 					we,
	output reg[`RegAddrBus]		waddr,
	output reg[`RegBus]			wdata,

	output reg 					use_npc,
	output reg 					npc_addr,

	output reg 					stall_req
	);

	reg [31:0]					imm;
	wire [2:0]					func3 = inst[14:12];

	always @ ( * ) begin
		if (rst == `RstEnable)begin
			raddr1 <= 5'b00000;
			raddr2 <= 5'b00000;
			waddr <= 5'b00000;
			aluop <= 7'b0000000;
			funct <= 1'b0;
		end
		else if(rdy == `True_v) begin
			{raddr2, raddr1} <= inst[24:15];
			{waddr, aluop} <= inst[11:0];
			funct <= inst[30];
		end
	end

	always @ ( * ) begin
		if (rst == `RstEnable)begin
			we <= `False_v;
			re1 <= `False_v;
			re2 <= `False_v;
			imm <= `ZeroWord;
		end
		else if(rdy == `True_v)  begin
			we <= `False_v;
			re1 <= `False_v;
			re2 <= `False_v;
			imm <= `ZeroWord;
			use_npc <= `False_v;
			npc_addr <= `ZeroWord;
			$display("operate: %d", inst);
			// $display("operate: %b", inst[6:0]);
			case(inst[6:0])
				7'b0110111 :we <= `True_v;// U
				7'b0010111 :we <= `True_v;// U
				7'b1101111 :we <= `True_v;// J
				7'b1100111 :we <= `True_v;// I
				7'b1100011 :we <= `True_v;// B
				7'b0000011 :begin // I
					we <= `True_v;
					re1 <= `True_v;
					alusel <= 3'b000;
					if (func3[2] == 1'b1)
						imm <= {{20{1'b0}}, inst[31:20]};
					else
						imm <= {{20{inst[31]}}, inst[30:20]};
				end
				7'b0100011 :begin// S
					re1 <= `True_v;
					re2 <= `True_v;
					alusel <= 3'b000;
					imm <= {{20{inst[31]}}, inst[30:25], inst[11:7]};
				end
				7'b0010011 :// I/R;
                begin
					if (func3 == 3'b111)
						$display("ANDI %d %d %h\n", inst[19:15], inst[11:7], {{20{1'b0}}, inst[31:20]});
					if (func3 == 3'b110)
						$display("ORI %d %d %h\n", inst[19:15], inst[11:7], {{20{1'b0}}, inst[31:20]});
					if (func3 == 3'b001)
						$display("SLLI %d %d %h\n", inst[19:15], inst[11:7], {{27{1'b0}}, inst[24:20]});
					we <= `True_v;
					re1 <= `True_v;
					re2 <= `False_v;
					alusel <= inst[14:12];
					if (func3 == 3'b001 || func3 == 3'b101)
						imm <= {{27{1'b0}}, inst[24:20]};
					else if (func3 != 3'b011)
						imm <= {{20{inst[31]}}, inst[30:20]};
					else
						imm <= {{20{1'b0}}, inst[31:20]};
				end
				7'b0110011 :we <= `True_v;// R

			endcase
		end
	end

	always @ ( * ) begin
		if (rst == `RstEnable)
			reg1 <= `ZeroWord;
		else if(rdy == `True_v) begin
			if (re1 == `True_v) begin
				if (ex_we == `True_v && ex_waddr == raddr1)
					reg1 <= ex_wdata;
				else if(mem_we == `True_v && mem_waddr == raddr1)
					reg1 <= mem_wdata;
				else
					reg1 <= rdata1;
			end
			else
				reg1 <= imm;
		end
	end

	always @ ( * ) begin
		if (rst == `RstEnable)
			reg2 <= `ZeroWord;
		else  if(rdy == `True_v) begin
			if (re2 == `True_v)begin
				if (ex_we == `True_v && ex_waddr == raddr2)
					reg2 <= ex_wdata;
				else if(mem_we == `True_v && mem_waddr == raddr2)
					reg2 <= mem_wdata;
				else
					reg2 <= rdata2;
			end
			else begin
				reg2 <= imm;
				// $display("reg2 <= imm");
			end
		end
	end

	always @ ( * ) begin
		if (rst == `RstEnable)
			wdata <= `ZeroWord;
		else  if(rdy == `True_v) begin
			if (inst[6:0] == 7'b0100011) begin
				wdata <= reg1;
				reg1 <= imm;
			end
		end
	end

endmodule // ID
