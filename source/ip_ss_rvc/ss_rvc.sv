//-----------------------------------------------------------------------------
// Title            : Subset RV32I RISCV Core
// Project          : SS_RVC
//-----------------------------------------------------------------------------
// File             : ss_rvc.sv
// Original Author  : Amichai Ben-David
// Code Owner       : 
// Created          : 7/2021
//-----------------------------------------------------------------------------
// Description :
// ----5 PipeStage----
// 1) Q100H Instruction Fetch   - Send Pc to Instruction Memory, Calculate next PC.
// 2) Q101H Instruction Decode  - Set thye Ctrl bits, read from register file.
// 3) Q102H Excecute            - Calculate the Imm<->Reg | Reg<->Reg in the ALU.
// 4) Q103H Mem Access          - Load/Store data from/to data memory
// 5) Q104H Writeback           - mux the data from Load with ALU output. write to register file.
//------------------------------------------------------------------------------
// Modification history :
//
//
//------------------------------------------------------------------------------

`include "ss_rvc_defines.sv"
module ss_rvc 
    import ss_rvc_pkg::*;  
    (
    input  logic          QClk,
    input  logic          RstQnnnH,
    input  logic          RstPcQnnnH,
    //Instruction Memory
    output t_xlen         PcQ100H,
    input  t_instruction  InstructionQ101H,
    //Data Memory
    output t_xlen         AddressDmQ103H,
    output t_xlen         WrDataDmQ103H,
    output logic          WrEnDmQ103H
    );

assign PcQ100H = '0;

endmodule
