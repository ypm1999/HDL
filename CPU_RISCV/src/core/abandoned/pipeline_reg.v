// `include "defines.v"
//
//
// module IF_ID (
// 	input wire 					clk,
// 	input wire 					rst,
//
// 	input wire[`InstAddrBus]	if_pc,
// 	input wire[`InstBus] 		if_inst,
//
// 	output reg[`InstAddrBus]	id_pc,
// 	output reg[`InstBus]		id_inst
// 	);
//
// 	always @ ( posedge clk ) begin
// 		if (rst == `RstEnable)
// 			id_pc <= `ZeroWord;
// 		else
// 			id_pc <= if_pc;
// 	end
//
// 	always @ ( posedge clk ) begin
// 		if (rst == `RstEnable)
// 			id_inst <= `ZeroWord;
// 		else
// 			id_inst <= if_inst;
// 	end
//
// endmodule // IF_ID
//
// module ID_EX (
// 	input wire 					clk,
// 	input wire 					rst,
//
// 	input wire[`AluOpBus] 		opcode_id,
// 	input wire[`AluSelBus] 		alusel_id,
// 	input wire 					funct_id,
// 	input wire[`RegBus]			data1_id,
// 	input wire[`RegBus]			data2_id,
// 	input wire 					we_id,
// 	input wire[`RegAddrBus]		waddr_id,
//
// 	output reg[`AluOpBus] 		opcode_ex,
// 	output reg[`AluSelBus] 		alusel_ex,
// 	output reg 					funct_ex,
// 	output reg[`RegBus]			data1_ex,
// 	output reg[`RegBus]			data2_ex,
// 	output reg 					we_ex,
// 	output reg[`RegAddrBus]		waddr_ex
// 	);
//
// 	always @ ( posedge clk ) begin
// 		if (rst == `RstEnable)begin
// 			opcode_ex <= `NOP_OP;
// 			alusel_ex <= 3'b000;
// 			funct_ex <= `False_v;
// 			data1_ex <= `ZeroWord;
// 			data2_ex <= `ZeroWord;
// 			we_ex <= `False_v;
// 			waddr_ex <= `ZeroWord;
// 		end
// 		else begin
// 			opcode_ex <= opcode_id;
// 			alusel_ex <= alusel_id;
// 			funct_ex <= funct_id;
// 			data1_ex <= data1_id;
// 			data2_ex <= data2_id;
// 			we_ex <= we_id;
// 			waddr_ex <= waddr_id;
// 		end
// 	end
//
// endmodule // ID_EX
//
// module EX_MEM (
// 	input wire clk,
// 	input wire rst,
//
// 	input wire 					ex_we,
// 	input wire[`RegAddrBus] 	ex_waddr,
// 	input wire[`RegBus] 		ex_wdata,
//
// 	output reg 					mem_we,
// 	output reg[`RegAddrBus] 	mem_waddr,
// 	output reg[`RegBus] 		mem_wdata
// 	);
//
// 	always @ ( posedge clk ) begin
// 		if (rst == `RstEnable)begin
// 			mem_we <= `False_v;
// 			mem_waddr <= 5'b00000;
// 			mem_wdata <= 32'h00000000;
// 		end
// 		else begin
// 			mem_we <= ex_we;
// 			mem_waddr <= ex_waddr;
// 			mem_wdata <= ex_wdata;
// 		end
// 	end
//
// endmodule // EX_MEM
//
// module MEM_WB (
// 	input wire clk,
// 	input wire rst,
//
// 	input wire 					mem_we,
// 	input wire[`RegAddrBus] 	mem_waddr,
// 	input wire[`RegBus] 		mem_wdata,
//
// 	output reg 					wb_we,
// 	output reg[`RegAddrBus] 	wb_waddr,
// 	output reg[`RegBus] 		wb_wdata
// 	);
//
// 	always @ ( posedge clk ) begin
// 		if (rst == `RstEnable)begin
// 			wb_we <= `False_v;
// 			wb_waddr <= 5'b00000;
// 			wb_wdata <= 32'h00000000;
// 		end
// 		else begin
// 			wb_we <= mem_we;
// 			wb_waddr <= mem_waddr;
// 			wb_wdata <= mem_wdata;
// 		end
// 	end
//
// endmodule // MEM_WB
