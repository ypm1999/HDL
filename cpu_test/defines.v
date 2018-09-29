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

`define AluOpBus        7:0
`define AluSelBus       2:0

`define ZeroWord        32'h00000000


//----------------------------Instruction Defines-------------------------------
`define InstAddrBus     31:0
`define InstBus         31:0
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

//----------------------------OPcode Defines-------------------------------
`define NOP_OP          6'b0000000
`define LUI_OP          6'b0110111
`define AUIPC_OP        6'b0010111
`define JAL_OP          6'b1101111
`define JALR_OP         6'b1100111
`define BEQ_OP          6'b1100011
`define BNE_OP          6'b1100011
`define BLT_OP          6'b1100011
`define BGE_OP          6'b1100011
`define BLEU_OP         6'b1100011
`define BGEU_OP         6'b1100011
`define LB_OP           6'b0000011
`define LH_OP           6'b0000011
`define LW_OP           6'b0000011
`define LBU_OP          6'b0000011
`define LHU_OP          6'b0000011
`define SB_OP           6'b0100011
`define SH_OP           6'b0100011
`define SW_OP           6'b0100011
`define ADDI_OP         6'b0010011
`define SLTI_OP         6'b0010011
`define SLTIU_OP        6'b0010011
`define XORI_OP         6'b0010011
`define ORI_OP          6'b0010011
`define ANDI_OP         6'b0010011
`define SLLI_OP         6'b0010011
`define SRLI_OP         6'b0010011
`define SRAI_OP         6'b0010011
`define ADD_OP          6'b0110011
`define SUB_OP          6'b0110011
`define SLL_OP          6'b0110011
`define SLT_OP          6'b0110011
`define SLTU_OP         6'b0110011
`define XOR_OP          6'b0110011
`define SRL_OP          6'b0110011
`define SRA_OP          6'b0110011
`define OR_OP           6'b0110011
`define AND_OP          6'b0110011
`define FENCE_OP        6'b0001111
`define FENCEI_OP       6'b0001111
`define ECALL_OP        6'b1110011
`define EBREAK_OP       6'b1110011
`define CSRRW_OP        6'b1110011
`define CSRRS_OP        6'b1110011
`define CSRRC_OP        6'b1110011
`define CSRRWI_OP       6'b1110011
`define CSRRSI_OP       6'b1110011
`define CSRRCI_OP       6'b1110011
