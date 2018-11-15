//----------------------------general Defines-------------------------------
`define RstEnable       1'b1
`define RstDisable      1'b0
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define True_v          1'b1
`define False_v         1'b0
`define InstValid       1'b1
`define InstDisvalid    1'b0
`define ClipEnable      1'b1
`define ClipDisable     1'b0

`define AluOpBus        6:0
`define AluSelBus       2:0

`define ZeroWord        32'h00000000


//----------------------------Instruction Defines-------------------------------
`define InstAddrBus     31:0
`define InstBus         31:0
`define RomAddrBus     	31:0
`define RomBus         	31:0
`define InstMemNum      131071
`define InstMemNumLog2  17


//----------------------------Registers Defines-------------------------------
`define RegAddrBus      4:0
`define RegBus          31:0
`define RegWidth        32
`define DoubleRegBus    63:0
`define DoubleRegWidth  64
`define RegNum          32
`define RegNumLog2      32

//----------------------------SELcode Defines-------------------------------
`define ADD_SEL			3'b000
`define SLT_SEL 		3'b010
`define SLTU_SEL		3'b011
`define XOR_SEL 		3'b100
`define OR_SEL 			3'b110
`define AND_SEL			3'b111
`define SLL_SEL			3'b001
`define SRL_SEL			3'b101



//----------------------------OPcode Defines-------------------------------
`define NOP_OP          7'b0000000
`define LUI_OP          7'b0110111
`define AUIPC_OP        7'b0010111
`define JAL_OP          7'b1101111
`define JALR_OP         7'b1100111
`define BEQ_OP          7'b1100011
`define BNE_OP          7'b1100011
`define BLT_OP          7'b1100011
`define BGE_OP          7'b1100011
`define BLEU_OP         7'b1100011
`define BGEU_OP         7'b1100011
`define LB_OP           7'b0000011
`define LH_OP           7'b0000011
`define LW_OP           7'b0000011
`define LBU_OP          7'b0000011
`define LHU_OP          7'b0000011
`define SB_OP           7'b0100011
`define SH_OP           7'b0100011
`define SW_OP           7'b0100011
`define ADDI_OP         7'b0010011
`define SLTI_OP         7'b0010011
`define SLTIU_OP        7'b0010011
`define XORI_OP         7'b0010011
`define ORI_OP          7'b0010011
`define ANDI_OP         7'b0010011
`define SLLI_OP         7'b0010011
`define SRLI_OP         7'b0010011
`define SRAI_OP         7'b0010011
`define ADD_OP          7'b0110011
`define SUB_OP          7'b0110011
`define SLL_OP          7'b0110011
`define SLT_OP          7'b0110011
`define SLTU_OP         7'b0110011
`define XOR_OP          7'b0110011
`define SRL_OP          7'b0110011
`define SRA_OP          7'b0110011
`define OR_OP           7'b0110011
`define AND_OP          7'b0110011
`define FENCE_OP        7'b0001111
`define FENCEI_OP       7'b0001111
`define ECALL_OP        7'b1110011
`define EBREAK_OP       7'b1110011
`define CSRRW_OP        7'b1110011
`define CSRRS_OP        7'b1110011
`define CSRRC_OP        7'b1110011
`define CSRRWI_OP       7'b1110011
`define CSRRSI_OP       7'b1110011
`define CSRRCI_OP       7'b1110011
