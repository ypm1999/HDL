`include "core/defines.v"
// RISCV32I CPU top module
// port modification allowed for debugging purposes

module cpu(
    input  wire                 clk_in,			// system clock signal
    input  wire                 rst_in,			// reset signal
	input  wire					rdy_in,			// ready signal, pause cpu when low

    input  wire [ 7:0]          mem_din,		// data input bus
    output wire [ 7:0]          mem_dout,		// data output bus
    output wire [31:0]          mem_a,			// address bus (only 17:0 is used)
    output wire                 mem_wr,			// write/read signal (1 for write)

	output wire [31:0]			dbgreg_dout		// cpu register output (debugging demo)
);

// implementation goes here

// Specifications:
// - Pause cpu(freeze pc, registers, etc.) when rdy_in is low
// - Memory read takes 2 cycles(wait till next cycle), write takes 1 cycle(no need to wait)
// - Memory is of size 128KB, with valid address ranging from 0x0 to 0x20000
// - I/O port is mapped to address higher than 0x30000 (mem_a[17:16]==2'b11)
// - 0x30000 read: read a byte from input
// - 0x30000 write: write a byte to output (write 0x00 is ignored)
// - 0x30004 read: read clocks passed since cpu starts (in dword, 4 bytes)
// - 0x30004 write: indicates program stop (will output '\0' through uart tx)

//IF->IFID->ID
wire[`RomAddrBus]	if_pc;
wire[`InstBus]		if_inst;
wire[`RomAddrBus]	id_pc;
wire[`InstBus]		id_inst;

//ID->IF(new pc for J and B)
wire                use_npc;
wire[`RomAddrBus]   npc_addr;

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
wire 				ma_we_in;
wire[`RegAddrBus]	ma_waddr_in;
wire[`RegBus]		ma_wdata_in;

  //MEM->MEMWB->WB
wire 				ma_we_out;
wire[`RegAddrBus]	ma_waddr_out;
wire[`RegBus]		ma_wdata_out;
wire 				wb_we_in;
wire[`RegAddrBus]	wb_waddr_in;
wire[`RegBus]		wb_wdata_in;

//wire for ram_accesser0 (input & output)
wire                ram_acc_re;
wire                ram_acc_we;
wire                ram_acc_busy;
wire[31:0]          ram_acc_addr;
wire[31:0]          ram_acc_rdata;
wire[31:0]          ram_acc_wdata;

//wire for ram_ctrl0 (input and output to outside)
wire                ram_ctrl_inst_re;
wire                ram_ctrl_ma_re;
wire                ram_ctrl_ma_we;
wire                ram_ctrl_ma_rbusy;
wire                ram_ctrl_inst_busy;
wire                ram_ctrl_mem_wbusy;
wire[31:0]          ram_ctrl_inst_raddr;
wire[31:0]          ram_ctrl_inst_rdata;
wire[31:0]          ram_ctrl_ma_raddr;
wire[31:0]          ram_ctrl_ma_rdata;
wire[31:0]          ram_ctrl_ma_waddr;
wire[31:0]          ram_ctrl_ma_wdataa;
//Ctrl lines
wire[4:0]           stall_cmd;
wire 				if_stall_req;
wire 				id_stall_req;
wire 				ex_stall_req;
wire 				ma_stall_req;

Ctrl ctrl0(
    .clk(clk_in),
    .rst(rst_in),
    .rdy(rdy_in),

    .if_stall_req(if_stall_req),
	.id_stall_req(id_stall_req),
	.ex_stall_req(ex_stall_req),
	.ma_stall_req(ma_stall_req),

	.stall_cmd(stall_cmd)
    );

Memory_Accesser ram_accesser0(
    .clk(clk_in),
    .rst(rst_in),
    .rdy(rdy_in),

    .mem_din(mem_din),
    .mem_dout(mem_dout),
    .mem_a(mem_a),
    .mem_wr(mem_wr),

    .re(ram_acc_re),
    .we(ram_acc_we),
    .mem_addr(ram_acc_addr),
    .mem_wdata(ram_acc_wdata),
    .mem_rdata(ram_acc_rdata),
    .busy(ram_acc_busy)
    );

Memory_Ctrl ram_ctrl0(
    .clk(clk_in),
    .rst(rst_in),
    .rdy(rdy_in),

    .inst_re(ram_ctrl_inst_re),
	.inst_raddr(ram_ctrl_inst_raddr),
	.inst_rdata(ram_ctrl_inst_rdata),
	.inst_rbusy(ram_ctrl_inst_rbusy),

    .mem_re(ram_ctrl_ma_re),
    .mem_raddr(ram_ctrl_ma_raddr),
    .mem_rdata(ram_ctrl_ma_rdata),
    .mem_rbusy(ram_ctrl_ma_rbusy),

    .mem_we(ram_ctrl_ma_we),
    .mem_waddr(ram_ctrl_ma_waddr),
    .mem_wdata(ram_ctrl_ma_wdata),
    .mem_wbusy(ram_ctrl_ma_wbusy),

    .ram_busy(ram_acc_busy),
    .ram_rdata(ram_acc_rdata),

    .ram_we(ram_acc_we),
    .ram_re(ram_acc_re),
    .ram_addr(ram_acc_addr),
    .ram_wdata(ram_acc_wdata)
    );


IF if0(
	.clk(clk_in),
	.rst(rst_in),
    .rdy(rdy_in),

    .use_npc(use_npc),
	.npc_addr(npc_addr),
	.ram_inst(ram_ctrl_inst_rdata),
	.ram_inst_busy(ram_ctrl_inst_rbusy),
	.stall(stall_cmd),

	.pc(if_pc),
	.inst(if_inst),
	.ram_inst_re(ram_ctrl_inst_re),
	.ram_inst_raddr(ram_ctrl_inst_raddr),

    .stall_req(if_stall_req)
	);

IF_ID if_id0(
	.clk(clk_in),
	.rst(rst_in),
	.rdy(rdy_in),

	.if_pc(if_pc),
	.if_inst(if_inst),

    .stall(stall_cmd),

	.id_pc(id_pc),
	.id_inst(id_inst)
	);

ID id0(
	.rst(rst_in),
	.rdy(rdy_in),

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
	.waddr(id_waddr),

    .use_npc(use_npc),
	.npc_addr(npc_addr),

    .stall_req(id_stall_req)
	);

RegFile regfile0(
	.clk(clk_in),
	.rst(rst_in),
	.rdy(rdy_in),

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
	.clk(clk_in),
	.rst(rst_in),
	.rdy(rdy_in),

	.opcode_id(id_aluop),
	.alusel_id(id_alusel),
	.funct_id(id_funct),
	.data1_id(id_data1),
	.data2_id(id_data2),
	.we_id(id_we),
	.waddr_id(id_waddr),
    .stall(stall_cmd),

	.opcode_ex(ex_aluop),
	.alusel_ex(ex_alusel),
	.funct_ex(ex_funct),
	.data1_ex(ex_data1),
	.data2_ex(ex_data2),
	.we_ex(ex_we_in),
	.waddr_ex(ex_waddr_in)
	);

EX ex0(
	.rst(rst_in),
	.rdy(rdy_in),
	.opcode(ex_aluop),
	.alusel(ex_alusel),
	.funct(ex_funct),
	.data1(ex_data1),
	.data2(ex_data2),
	.we_in(ex_we_in),
	.waddr_in(ex_waddr_in),

	.we(ex_we_out),
	.waddr(ex_waddr_out),
	.wdata(ex_wdata_out),

    .stall_req(ex_stall_req)
	);

EX_MA ex_ma0(
	.clk(clk_in),
	.rst(rst_in),
	.rdy(rdy_in),

	.ex_we(ex_we_out),
	.ex_waddr(a_waddr_out),
	.ex_wdata(ex_wdata_out),
    .stall(stall_cmd),

	.ma_we(ma_we_in),
	.ma_waddr(ma_waddr_in),
	.ma_wdata(ma_wdata_in)
	);


  MA ma0(
	.rst(rst_in),
	.rdy(rdy_in),

	.we_in(ma_we_in),
	.waddr_in(ma_waddr_in),
	.wdata_in(ma_wdata_in),

    .ram_re(ram_ctrl_mem_re),
    .ram_raddr(ram_ctrl_mem_raddr),
    .ram_rdata(ram_ctrl_mem_rdata),
    .ram_rbusy(ram_ctrl_mem_rbusy),

	.we_out(ma_we_out),
	.waddr_out(ma_waddr_out),
	.wdata_out(ma_wdata_out),

    .ram_we(ram_ctrl_mem_we),
    .ram_waddr(ram_ctrl_mem_waddr),
    .ram_wdata(ram_ctrl_mem_wdata),
    .ram_wbusy(ram_ctrl_mem_wbusy),

    .stall_req(ma_stall_req)
    );



MA_WB ma_wb0(
	.clk(clk_in),
	.rst(rst_in),
    .rdy(rdy_in),

	.ma_we(ma_we_out),
	.ma_waddr(ma_waddr_out),
	.ma_wdata(ma_wdata_out),
    .stall(stall_cmd),

	.wb_we(wb_we_in),
	.wb_waddr(wb_waddr_in),
	.wb_wdata(wb_wdata_in)
	);

  WB wb0(
	.rst(rst_in),
	.rdy(rdy_in),

	.we_in(wb_we_in),
	.waddr_in(wb_waddr_in),
	.wdata_in(wb_wdata_in),

	.we_out(reg_we),
	.waddr_out(reg_waddr),
	.wdata_out(reg_wdata)
	);

endmodule
