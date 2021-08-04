//-----------------------------------------------------------------------------
// Title            : Memory Wrap
// Project          : SS_RVC
//-----------------------------------------------------------------------------
// File             : mem_wrap.sv
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Created          : 7/2021
//-----------------------------------------------------------------------------
// Description :
//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------

`include "ss_rvc_defines.sv"
module mem_wrap 
    import ss_rvc_pkg::*;  
    (
    input  logic     QClk,
    input  logic     RstQnnnH,
    //===========================
    //      IO_CTRL interface
    //===========================
    //Mem Req - input
    input  logic         ReqValidQ501H,
    input  logic         ReqOpcodeQ501H,
    input  t_xlen        ReqAddressQ501H,
    input  t_xlen        ReqDataQ501H,
    //Mem Ack - output
    output logic         RspValidQ502H,
    output logic         RspOpcodeQ502H,
    output t_xlen        RspAddressQ502H,
    output t_xlen        RspDataQ502H,
    //===========================
    //      SS_RVC Interface (Core interface)
    //===========================
    //I_MEM - Instruction Fetch
    input  t_xlen        PcQ100H,
    output t_instruction InstructionQ101H,
    //D_MEM - Load/Store Interface
    input  t_xlen        AddressDmQ103H,
    input  t_xlen        WrDataDmQ103H,
    input  logic         RdEnDmQ103H,
    input  logic         WrEnDmQ103H,
    output t_xlen        RdDataDmQ104H
    );


localparam I_MEM = 1'b0;
localparam D_MEM = 1'b1;

logic         I_RdEnQ501H,       D_RdEnQ501H;
logic         I_WrEnQ501H,       D_WrEnQ501H;
t_xlen        I_ReqAddressQ501H, D_ReqAddressQ501H;       
t_xlen        I_ReqDataQ501H,    D_ReqDataQ501H;  

logic IvsDReqQ501H, IvsDReqQ502H;
t_xlen I_RspDataQ502H;
t_xlen D_RspDataQ502H;
assign IvsDReqQ501H = ReqAddressQ501H[12];
//==========================
//      reguest from IO_CTRL
//==========================
always_comb begin : io_ctrl_req_interface
    //I_MEM access from IO
    I_ReqAddressQ501H   = ReqAddressQ501H;
    I_ReqDataQ501H      = ReqDataQ501H;
    I_RdEnQ501H         = (IvsDReqQ501H == I_MEM) && (ReqOpcodeQ501H==RD);
    I_WrEnQ501H         = (IvsDReqQ501H == I_MEM) && (ReqOpcodeQ501H==WR);
    //D_MEM access from IO
    D_ReqAddressQ501H   = ReqAddressQ501H;
    D_ReqDataQ501H      = ReqDataQ501H;
    D_RdEnQ501H         = (IvsDReqQ501H == D_MEM) && (ReqOpcodeQ501H==RD);
    D_WrEnQ501H         = (IvsDReqQ501H == D_MEM) && (ReqOpcodeQ501H==WR);
end
//==========================
//      Response to IO_CTRL
//==========================
`RVC_MSFF(IvsDReqQ502H    , IvsDReqQ501H    , QClk)
`RVC_MSFF(RspValidQ502H   , ReqValidQ501H   , QClk)
`RVC_MSFF(RspAddressQ502H , ReqAddressQ501H , QClk)
`RVC_MSFF(RspOpcodeQ502H  , WR              , QClk)
always_comb begin : io_ctrl_rsp_interface
    unique casez (IvsDReqQ502H)
        I_MEM   : RspDataQ502H = I_RspDataQ502H;
        D_MEM   : RspDataQ502H = D_RspDataQ502H;
        default : RspDataQ502H = '0;// not really needed - good practice
    endcase 
end

//==========================
//      Response to IO_CTRL
//==========================
`ifdef FPGA_ALTERA
altera_sram_1024x32
`else 
mem_behavioral   #( 
    .MSB_MEM_SIZE (SIZE_I_MEM-1),
    .MSB_MEM      (MSB_I_MEM   )
    )
`endif
i_mem (
    .clock      (QClk),
    //============================================
    //      core interface
    //============================================
    .address_a  (PcQ100H[MSB_D_MEM:2]),
    .data_a     (32'b0),
    .rden_a     (1'b1),
    .wren_a     (1'b0),
    .q_a        (InstructionQ101H),
    //============================================
    //      Ring interface
    //============================================
    .address_b  (I_ReqAddressQ501H[MSB_D_MEM:2]),
    .data_b     (I_ReqDataQ501H),
    .rden_b     (I_RdEnQ501H),
    .wren_b     (I_WrEnQ501H),
    .q_b        (I_RspDataQ502H)
    );

`ifdef FPGA_ALTERA
altera_sram_1024x32
`else 
mem_behavioral   #( 
    .MSB_MEM_SIZE (SIZE_D_MEM-1),
    .MSB_MEM      (MSB_D_MEM   )
    )
`endif
d_mem (
    .clock      (QClk),
    //============================================
    //      core interface
    //============================================
    .address_a  (AddressDmQ103H[MSB_D_MEM:2]), //input
    .data_a     (WrDataDmQ103H),        //input
    .rden_a     (RdEnDmQ103H),          //input
    .wren_a     (WrEnDmQ103H),          //input
    .q_a        (RdDataDmQ104H),        //output
    //============================================
    //      Ring interface
    //============================================
    .address_b  (D_ReqAddressQ501H[MSB_D_MEM:2]),//input
    .data_b     (D_ReqDataQ501H),         //input
    .rden_b     (D_RdEnQ501H),            //input
    .wren_b     (D_WrEnQ501H),            //input
    .q_b        (D_RspDataQ502H)          //output
    );

endmodule //mem_wrap
