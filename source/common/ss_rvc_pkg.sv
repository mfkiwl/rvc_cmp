//-----------------------------------------------------------------------------
// Title         : 
// Project       : 
//-----------------------------------------------------------------------------
// File          : 
// Author        : Amichai Ben-David
// Created       : 7/2020
//-----------------------------------------------------------------------------
// Description :
// parameters and struct used in ss_rvc
//-----------------------------------------------------------------------------

package ss_rvc_pkg;


parameter XLEN          = 32;
parameter MSB_I_MEM     = 9;
parameter MSB_D_MEM     = 9;
parameter SIZE_I_MEM    = 2**(MSB_I_MEM + 1);
parameter SIZE_D_MEM    = 2**(MSB_D_MEM + 1);
parameter I_MEM_OFFSET  = 0;
parameter D_MEM_OFFSET  = SIZE_I_MEM;

parameter MSB_REG_FILE     = 31;
parameter MSB_ENC_REG_FILE = $clog2(MSB_REG_FILE+1)-1;

parameter EBREAK =   32'h0010_0073;

typedef logic [XLEN-1:0] t_xlen;
typedef logic [31:0]     t_instruction;
typedef enum logic {
    I_TYPE  =   1'b0,
    S_TYPE  =   1'b1
} t_imm_type;

typedef enum logic [2:0] {
    ADD  =   3'b000,
    SLL  =   3'b001,
    SLT  =   3'b010,
    SLTU =   3'b011,
    XOR  =   3'b100,
    SRL  =   3'b101,
    OR   =   3'b110,
    AND  =   3'b111
} t_alu_op;

typedef enum logic [6:0] {
    OP_LOAD   =   7'b0000011,
    OP_STORE  =   7'b0100011,
    OP_OPIMM  =   7'b0010011,
    OP_OP     =   7'b0110011
} t_opcodes;

typedef enum logic {
    RD   =   1'b0,
    WR   =   1'b1
} t_req_op;

endpackage // ss_rvc_pkg
