`include "defines.v"


//connect all parts of cpu core
module CORE_TOP (
    input wire                  clk,
	input wire 			        rst,

	input wire[`RomBus]         rom_rdata,
	output wire[`RomAddrBus]    rom_raddr,
	output wire                 rom_ce

	//input wire[`RegBus]         rom_wdata,
	//output wire[`RegAddrBus]     rom_waddr,
	//output wire                  rom_we
	);


	//IF->IFID->ID
	wire[`RomAddrBus]	if_pc;
	wire[`RomAddrBus]	id_pc;
 	wire[`InstBus]		id_inst;

    //ID->REGFile->ID
	wire 				reg_re1;
	wire 				reg_re2;
	wire[`RegAddrBus]	reg_raddr1;
	wire[`RegAddrBus]	reg_raddr2;
	wire[`RegBus]		reg_data1;
	wire[`RegBus]		reg_data2;
	wire				reg_we;
	wire[`RegAddrBus]	reg_waddr;
	wire[`RegBus]		reg_wdata;

	//ID->IDEX->EX
	wire[`AluOpBus] 	id_aluop;
	wire[`AluSelBus] 	id_alusel;
	wire				id_funct;
	wire				id_we;
	wire[`RegAddrBus]	id_waddr;
	wire[`RegBus]		id_data1;
	wire[`RegBus]		id_data2;

    //EX->EXMEM
    wire[`AluOpBus] 	ex_aluop;
	wire[`AluSelBus] 	ex_alusel;
	wire				ex_funct;
	wire				ex_we_in;
	wire[`RegAddrBus]	ex_waddr_in;
	wire[`RegBus]		ex_data1;
	wire[`RegBus]		ex_data2;
	wire 				ex_we_out;
	wire[`RegAddrBus]	ex_waddr_out;
	wire[`RegBus]		ex_wdata_out;

    //EXMEM->MEM
    wire 				mem_we_in;
	wire[`RegAddrBus]	mem_waddr_in;
	wire[`RegBus]		mem_wdata_in;

    //MEM->MEMWB->WB
	wire 				mem_we_out;
	wire[`RegAddrBus]	mem_waddr_out;
	wire[`RegBus]		mem_wdata_out;
    wire 				wb_we_in;
	wire[`RegAddrBus]	wb_waddr_in;
	wire[`RegBus]		wb_wdata_in;


	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
		.pc(if_pc),
		.ce(rom_ce)
		);

    // always @ ( * ) begin
    //     $display("if_pc:%d\n", if_pc);
    // end
	assign rom_raddr = if_pc;
    // always @ ( * ) begin
    //     $display("rom_raddr:%d\n", rom_raddr);
    // end


	IF_ID if_id0(
		.clk(clk),
		.rst(rst),
		.if_pc(if_pc),
		.if_inst(rom_rdata),
		.id_pc(id_pc),
		.id_inst(id_inst)
		);


    // always @ ( * ) begin
    //     $display("id_inst:%d\n", id_inst);
    // end

	ID id0(
		.rst(rst),
		.pc(id_pc),
		.inst(id_inst),
		.rdata1(reg_data1),
		.rdata2(reg_data2),
        .ex_we(ex_we_out),
        .ex_waddr(ex_waddr_out),
        .ex_wdata(ex_wdata_out),
        .mem_we(mem_we_out),
        .mem_waddr(mem_waddr_out),
        .mem_wdata(mem_wdata_out),
		.aluop(id_aluop),
		.alusel(id_alusel),
		.funct(id_funct),
		.re1(reg_re1),
		.re2(reg_re2),
		.raddr1(reg_raddr1),
		.raddr2(reg_raddr2),
		.reg1(id_data1),
		.reg2(id_data2),
		.we(id_we),
		.waddr(id_waddr)
		);

	RegFile regfile0(
		.clk(clk),
		.rst(rst),
		.we(reg_we),
		.waddr(reg_waddr),
		.wdata(reg_wdata),

		.re1(reg_re1),
		.raddr1(reg_raddr1),
		.rdata1(reg_data1),

		.re2(reg_re2),
		.raddr2(reg_raddr2),
		.rdata2(reg_data2)
		);



	ID_EX id_ex0(
		.clk(clk),
		.rst(rst),

		.opcode_id(id_aluop),
		.alusel_id(id_alusel),
		.funct_id(id_funct),
		.data1_id(id_data1),
		.data2_id(id_data2),
		.we_id(id_we),
		.waddr_id(id_waddr),

		.opcode_ex(ex_aluop),
		.alusel_ex(ex_alusel),
		.funct_ex(ex_funct),
		.data1_ex(ex_data1),
		.data2_ex(ex_data2),
		.we_ex(ex_we_in),
		.waddr_ex(ex_waddr_in)
		);

	EX ex0(
		.rst(rst),
		.opcode(ex_aluop),
		.alusel(ex_alusel),
		.funct(ex_funct),
		.data1(ex_data1),
		.data2(ex_data2),
		.we_in(ex_we_in),
		.waddr_in(ex_waddr_in),

		.we(ex_we_out),
		.waddr(ex_waddr_out),
		.wdata(ex_wdata_out)
		);




	EX_MEM ex_mem0(
		.clk(clk),
		.rst(rst),

		.ex_we(ex_we_out),
		.ex_waddr(ex_waddr_out),
		.ex_wdata(ex_wdata_out),

		.mem_we(mem_we_in),
		.mem_waddr(mem_waddr_in),
		.mem_wdata(mem_wdata_in)
		);


    MEM mem0(
        .rst(rst),

        .we_in(mem_we_in),
        .waddr_in(mem_waddr_in),
        .wdata_in(mem_wdata_in),
        .we_out(mem_we_out),
        .waddr_out(mem_waddr_out),
        .wdata_out(mem_wdata_out)
        );



	MEM_WB mem_wb0(
		.clk(clk),
		.rst(rst),

		.mem_we(mem_we_out),
		.mem_waddr(mem_waddr_out),
		.mem_wdata(mem_wdata_out),

		.wb_we(wb_we_in),
		.wb_waddr(wb_waddr_in),
		.wb_wdata(wb_wdata_in)
		);

    WB wb0(
        .rst(rst),

        .we_in(wb_we_in),
        .waddr_in(wb_waddr_in),
        .wdata_in(wb_wdata_in),
        .we_out(reg_we),
        .waddr_out(reg_waddr),
        .wdata_out(reg_wdata)
        );

endmodule // cup_top
