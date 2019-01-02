`include "defines.v"

// `include "defines.v"
//
// module EX_MA (
// 	input wire 					clk,
// 	input wire 					rst,
// 	input wire 					rdy,
//
// 	input wire 					ex_we,
// 	input wire[`RegAddrBus] 	ex_waddr,
// 	input wire[`RegBus] 		ex_wdata,
// 	input wire 					ex_ma_we,
// 	input wire 					ex_ma_re,
// 	input wire[ 2:0]			ex_ma_width,
// 	input wire[31:0]			ex_ma_addr,
// 	input wire[31:0]			ex_ma_wdata,
//
// 	input wire[4:0] 			stall,
//
// 	output reg 					ma_we,
// 	output reg[`RegAddrBus] 	ma_waddr,
// 	output reg[31:0] 			ma_wdata,
// 	output reg 					ma_ma_we,
// 	output reg 					ma_ma_re,
// 	output reg[ 2:0]			ma_ma_width,
// 	output reg[31:0]			ma_ma_addr,
// 	output reg[31:0]			ma_ma_wdata
// 	);
//
// 	always @ ( posedge clk ) begin
// 		if (rst) begin
// 			ma_we <= `False_v;
// 			ma_waddr <= 5'b00000;
// 			ma_wdata <= `ZeroWord;
// 			ma_ma_we <= `False_v;
// 			ma_ma_re <= `False_v;
// 			ma_ma_width <= 3'b000;
// 			ma_ma_addr <= `ZeroWord;
// 			ma_ma_wdata <= `ZeroWord;
// 		end
// 		else if (rdy) begin
// 			if(!stall[3]) begin
// 				ma_we <= ex_we;
// 				ma_waddr <= ex_waddr;
// 				ma_wdata <= ex_wdata;
// 				ma_ma_we <= ex_ma_we;
// 				ma_ma_re <= ex_ma_re;
// 				ma_ma_width <= ex_ma_width;
// 				ma_ma_addr <= ex_ma_addr;
// 				ma_ma_wdata <= ex_ma_wdata;
// 			end
// 		end
// 	end
//
// endmodule // EX_MEM



module MA (
	input wire 					clk,
	input wire 					rst,
	input wire 					rdy,

	input wire 					we_in,
	input wire[`RegAddrBus]		waddr_in,
	input wire[`RegBus]			wdata_in,

	input wire 					ma_we,
	input wire 					ma_re,
	input wire[ 2:0]			ma_width,
	input wire[31:0]			ma_addr,
	input wire[31:0]			ma_wdata,
	input wire[ 4:0]			stall,

	output reg 					ram_we,
	output reg 					ram_re,
	output reg [31:0]			ram_addr,
	output reg [2:0] 			ram_width,
	input wire [31:0]			ram_rdata,
	output reg [31:0]			ram_wdata,
	input wire 					ram_busy,

	output reg 					we_out,
	output reg[`RegAddrBus]		waddr_out,
	output reg[`RegBus]			wdata_out,
	output reg 					stall_req
	);

	reg [ 1:0] 		sta;

	always @ ( posedge clk ) begin
		if (rst == `RstEnable) begin
			we_out <= `False_v;
			waddr_out <= 5'b00000;
			wdata_out <= `ZeroWord;
			ram_we <= `False_v;
			ram_re <= `False_v;
			ram_addr <= `ZeroWord;
			ram_width <= 3'b000;
			ram_wdata <= `ZeroWord;
			stall_req <= `False_v;
			sta <= 2'b00;
		end
		else if(rdy == `True_v) begin
			case (sta)
				2'b00:begin
					if (!stall[3]) begin
						we_out <= we_in;
						waddr_out <= waddr_in;
						wdata_out <= wdata_in;
						if (ma_we | ma_re)begin
							ram_we <= ma_we;
							ram_re <= ma_re;
							ram_addr <= ma_addr;
							ram_width <= ma_width;
							ram_wdata <= ma_wdata;
							stall_req <= `True_v;
							sta <= 2'b10;
						end
						else begin
							ram_we <= `False_v;
							ram_re <= `False_v;
							ram_addr <= `ZeroWord;
							ram_width <= 3'b000;
							ram_wdata <= `ZeroWord;
							stall_req <= `False_v;
							sta <= 2'b00;
						end
					end
				end
				2'b01:begin
					if (!ram_busy)begin
						if (ram_re)begin
							if(ram_width[2] | ram_width[1])
								wdata_out <= ram_rdata;
							else
								wdata_out <= ram_width[0] ? {{17{ram_rdata[15]}},  ram_rdata[14:0]} :
														{{25{ram_rdata[7]}}, ram_rdata[6:0]};
						end
						stall_req <= `False_v;
						ram_we <= `False_v;
						ram_re <= `False_v;
						sta <= 2'b00;
					end
				end
				2'b10:begin
					if (ram_busy)
						sta <= 2'b01;
				end
				default : begin
					sta <= 2'b00;
				end
			endcase
		end
	end

endmodule // MEM


//
// module EX_MA (
// 	input wire 					clk,
// 	input wire 					rst,
// 	input wire 					rdy,
//
// 	input wire 					ex_we,
// 	input wire[`RegAddrBus] 	ex_waddr,
// 	input wire[`RegBus] 		ex_wdata,
// 	input wire 					ex_ma_we,
// 	input wire 					ex_ma_re,
// 	input wire[ 2:0]			ex_ma_width,
// 	input wire[31:0]			ex_ma_addr,
// 	input wire[31:0]			ex_ma_wdata,
//
// 	input wire[4:0] 			stall,
//
// 	output reg 					ma_we,
// 	output reg[`RegAddrBus] 	ma_waddr,
// 	output reg[31:0] 			ma_wdata,
// 	output reg 					ma_ma_we,
// 	output reg 					ma_ma_re,
// 	output reg[ 2:0]			ma_ma_width,
// 	output reg[31:0]			ma_ma_addr,
// 	output reg[31:0]			ma_ma_wdata
// 	);
//
// 	always @ ( posedge clk ) begin
// 		if (rst) begin
// 			ma_we <= `False_v;
// 			ma_waddr <= 5'b00000;
// 			ma_wdata <= `ZeroWord;
// 			ma_ma_we <= `False_v;
// 			ma_ma_re <= `False_v;
// 			ma_ma_width <= 3'b000;
// 			ma_ma_addr <= `ZeroWord;
// 			ma_ma_wdata <= `ZeroWord;
// 		end
// 		else if (rdy) begin
// 			if(!stall[3]) begin
// 				ma_we <= ex_we;
// 				ma_waddr <= ex_waddr;
// 				ma_wdata <= ex_wdata;
// 				ma_ma_we <= ex_ma_we;
// 				ma_ma_re <= ex_ma_re;
// 				ma_ma_width <= ex_ma_width;
// 				ma_ma_addr <= ex_ma_addr;
// 				ma_ma_wdata <= ex_ma_wdata;
// 			end
// 		end
// 	end
//
// endmodule // EX_MEM
//
//
//
// module MA (
// 	input wire 					clk,
// 	input wire 					rst,
// 	input wire 					rdy,
//
// 	input wire 					we_in,
// 	input wire[`RegAddrBus]		waddr_in,
// 	input wire[`RegBus]			wdata_in,
//
// 	input wire 					ma_we,
// 	input wire 					ma_re,
// 	input wire[ 2:0]			ma_width,
// 	input wire[31:0]			ma_addr,
// 	input wire[31:0]			ma_wdata,
//
// 	output reg 					ram_we,
// 	output reg 					ram_re,
// 	output reg [31:0]			ram_addr,
// 	output reg [2:0] 			ram_width,
// 	input wire [31:0]			ram_rdata,
// 	output reg [31:0]			ram_wdata,
// 	input wire 					ram_busy,
//
// 	output reg 					we_out,
// 	output reg[`RegAddrBus]		waddr_out,
// 	output reg[`RegBus]			wdata_out,
// 	output reg 					stall_req
// 	);
//
// 	reg 		try_stall, rst_stall;
// 	wire 		work;
// 	assign work = ma_we | ma_re;
//
// 	always @ ( * ) begin
// 		if (rst)begin
// 			ram_we <= `False_v;
// 			ram_re <= `False_v;
// 			ram_addr <= `ZeroWord;
// 			ram_width <= 3'b000;
// 		end
// 		else if(rdy) begin
// 			ram_we <= ma_we;
// 			ram_re <= ma_re;
// 			ram_addr <= ma_addr;
// 			ram_width <= ma_width;
// 		end
// 	end
//
// 	always @ ( rst, rdy, work) begin
// 		if (rst)begin
// 			try_stall <= `False_v;
// 		end
// 		else if(rdy) begin
// 			if (work)
// 				try_stall <= ~try_stall;
// 		end
// 	end
//
// 	always @ ( * ) begin
// 		if (rst)begin
// 			ram_wdata <= `ZeroWord;
// 		end
// 		else if(rdy) begin
// 			if (ma_we) begin
// 				ram_wdata <= ma_wdata;
// 			end
// 			else begin
// 				ram_wdata <= 3'b000;
// 			end
// 		end
// 	end
//
// 	always @ ( rst  or ram_busy ) begin
// 		if (rst)begin
// 			rst_stall <= `False_v;
// 		end
// 		else if(rdy) begin
// 			if( (work & !ram_busy) )
// 				rst_stall <= ~rst_stall;
// 		end
// 	end
//
// 	always @ ( * ) begin
// 		if (rst)
// 			stall_req <= `False_v;
// 		else if (rdy) begin
// 			stall_req <= try_stall ^ rst_stall;
// 		end
// 	end
//
// 	always @ ( * ) begin
// 		if (rst == `RstEnable)begin
// 			we_out <= `False_v;
// 			waddr_out <= 5'b00000;
// 		end
// 		else if(rdy) begin
// 			we_out <= we_in;
// 			waddr_out <= waddr_in;
// 		end
// 	end
//
// 	always @ ( * ) begin
// 		if (rst == `RstEnable)begin
// 			wdata_out <= `ZeroWord;
// 		end
// 		else if(rdy) begin
// 			if(ma_re)begin
// 				if(ma_width[2] | ma_width[1])
// 					wdata_out <= ram_rdata;
// 				else
// 					wdata_out <= ma_width[0] ? {{17{ram_rdata[15]}},  ram_rdata[14:0]} :
// 												{{25{ram_rdata[7]}}, ram_rdata[6:0]};
// 			end
// 			else
// 				wdata_out <= wdata_in;
// 		end
// 	end
//
// endmodule // MEM
