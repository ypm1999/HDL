`include "defines.v"

module ID_EX (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire[`AluSelBus] 		id_alusel,
	input wire 					id_funct,
	input wire[`RegBus]			id_data1,
	input wire[`RegBus]			id_data2,
	input wire[`RegBus]			id_extra_data,
	input wire 					id_we,
	input wire[`RegAddrBus]		id_waddr,
	input wire 					id_ma_we,
	input wire 					id_ma_re,
	input wire[ 2:0]			id_ma_width,
	input wire[4:0] 			stall,

	output reg[`AluSelBus] 		ex_alusel,
	output reg 					ex_funct,
	output reg[`RegBus]			ex_data1,
	output reg[`RegBus]			ex_data2,
	output reg[`RegBus]			ex_extra_data,
	output reg 					ex_we,
	output reg[`RegAddrBus]		ex_waddr,
	output reg 					ex_ma_we,
	output reg 					ex_ma_re,
	output reg[ 2:0]			ex_ma_width
	);

	always @ ( posedge clk ) begin
		if (rst == `RstEnable)begin
			ex_alusel <= 3'b000;
			ex_funct <= `False_v;
			ex_data1 <= `ZeroWord;
			ex_data2 <= `ZeroWord;
			ex_we <= `False_v;
			ex_waddr <= `ZeroWord;
			ex_ma_we <= `False_v;
			ex_ma_re <= `False_v;
			ex_ma_width <= 3'b000;
		end
		else if (rdy) begin
			if (stall[1] && stall[2] == `False_v)begin
				ex_alusel <= 3'b000;
				ex_funct <= `False_v;
				ex_data1 <= `ZeroWord;
				ex_data2 <= `ZeroWord;
				ex_we <= `False_v;
				ex_waddr <= `ZeroWord;
				ex_ma_we <= `False_v;
				ex_ma_re <= `False_v;
				ex_ma_width <= 3'b000;
			end
			else if(!stall[2]) begin
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
		end
	end
endmodule // ID_EX



module EX (
	input wire 					rst,
	input wire 					rdy,

	input wire[`AluSelBus] 		alusel,
	input wire 					funct,
	input wire[`RegBus]			data1,
	input wire[`RegBus]			data2,
	input wire 					we_in,
	input wire[`RegAddrBus]		waddr_in,
	input wire[`RegBus]			extra_data_in,

	input wire 					ma_we_in,
	input wire 					ma_re_in,
	input wire[ 2:0]			ma_width_in,

	output reg 					we,
	output reg[`RegAddrBus]		waddr,
	output reg[`RegBus]			wdata,

	output reg 					ma_we,
	output reg 					ma_re,
	output reg[ 2:0]			ma_width,
	output reg[31:0]			ma_addr,
	output reg[31:0]			ma_wdata
	);

	reg [31:0] 					alu_out;
	wire [31:0]					AND, OR, XOR, ADD, SUB, SLT, SLTU, SLL, SRL;
	assign AND = data1 & data2;
	assign OR = data1 | data2;
	assign XOR = data1 ^ data2;
	assign ADD = funct ? ($signed(data1) - $signed(data2)) : (data1 + data2);
	assign SLT = ($signed(data1) < $signed(data2)) ? 32'h00000001 : `ZeroWord;
	assign SLTU = (data1 < data2) ? 32'h00000001 : `ZeroWord;
	assign SLL = data1 << data2[4:0];
	assign SRL = (data1 >> data2[4:0]) | ({32{funct & data1[31]}} << (6'd32-data2[4:0]));

	always @ ( * ) begin
		if(rst | !rdy) begin
			alu_out <= `ZeroWord;
		end
		else begin
			case (alusel)
				`AND_SEL: alu_out <= AND;
				`OR_SEL: alu_out <= OR;
				`XOR_SEL: alu_out <= XOR;
				`ADD_SEL: alu_out <= ADD;
				`SLT_SEL: alu_out <= SLT;
				`SLTU_SEL: alu_out <= SLTU;
				`SLL_SEL: alu_out <= SLL;
				`SRL_SEL: alu_out <= SRL;
			endcase
		end
	end

	always @ ( * ) begin
		if(rst == `RstEnable)begin
			we <= `False_v;
			waddr <= 5'b00000;
			wdata <= `ZeroWord;
		end
		else if(rdy)  begin
			we <= we_in;
			waddr <= waddr_in;
			wdata <= alu_out;
		end
	end

	always @ ( * ) begin
		if(rst == `RstEnable)begin
			ma_we <= `False_v;
			ma_re <= `False_v;
			ma_width <= 3'b000;
		end
		else if(rdy)  begin
			ma_we <= ma_we_in;
			ma_re <= ma_re_in;
			ma_width <= ma_width_in;
		end
	end

	always @ ( * ) begin
		if(rst == `RstEnable)begin
			ma_addr <= `ZeroWord;
			ma_wdata <= `ZeroWord;
		end
		else if(rdy)  begin
			ma_addr <= alu_out;
			ma_wdata <= extra_data_in;
		end
	end

endmodule // EX
