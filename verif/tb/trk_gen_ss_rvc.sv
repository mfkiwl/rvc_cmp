//-----------------------------------------------------------------------------
// Title            : trk generator
// Project          : SS_RVC
//-----------------------------------------------------------------------------
// File             : treg_gen_ss_rvc.sv
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
integer      trk_d_mem_access;
integer      trk_write_registers;
logic [31:0] PcQ101H, PcQ102H, PcQ103H, PcQ104H;

t_xlen          AddressDmQ104H;
t_xlen          WrDataDmQ104H ;
logic           RdEnDmQ104H   ;
logic           WrEnDmQ104H   ;
`RVC_MSFF(PcQ101H        , PcQ100H         , QClk)
`RVC_MSFF(PcQ102H        , PcQ101H         , QClk)
`RVC_MSFF(PcQ103H        , PcQ102H         , QClk)
`RVC_MSFF(PcQ104H        , PcQ103H         , QClk)
`RVC_MSFF(RdEnDmQ104H    , RdEnDmQ103H     , QClk)
`RVC_MSFF(WrEnDmQ104H    , WrEnDmQ103H     , QClk)
`RVC_MSFF(AddressDmQ104H , AddressDmQ103H  , QClk)
`RVC_MSFF(WrDataDmQ104H  , WrDataDmQ103H   , QClk)

initial begin : open_the_trk_d_mem_access
    $timeformat(-9, 1, " ", 6);
    trk_d_mem_access      = $fopen({"../regression/",hpath,"/trk_d_mem_access.log"},"w");
    trk_write_registers   = $fopen({"../regression/",hpath,"/trk_write_registers.log"},"w");

    $fwrite(trk_d_mem_access,"-----------------------------------------------------\n");
    $fwrite(trk_d_mem_access,"Time   |    PC    | Address  | RD/WR |   Data   |\n");
    $fwrite(trk_d_mem_access,"-----------------------------------------------------\n"); 

    $fwrite(trk_write_registers,"-------------------------------------------------\n");
    $fwrite(trk_write_registers,"Time   |    PC    |Reg<#>| Wr Data  | \n");
    $fwrite(trk_write_registers,"-------------------------------------------------\n");
end //initial


// Checker
logic EbreakQ101H, EbreakQ102H, EbreakQ103H, EbreakQ104H;
assign EbreakQ101H = (InstructionQ101H == EBREAK);

`RVC_MSFF(EbreakQ102H, EbreakQ101H   , QClk)
`RVC_MSFF(EbreakQ103H, EbreakQ102H   , QClk)
`RVC_MSFF(EbreakQ104H, EbreakQ103H   , QClk)
always @(posedge QClk) begin : ebreak_end_test
    if(EbreakQ104H) begin
        end_tb("\n=======================\nEBREAK at End-Of-Test: Finished Successfully \n======================= \n");
    end
end

//tracker on memory transactions
always @(posedge QClk) begin : memory_access_print
    if (RdEnDmQ104H) begin 
        $fwrite(trk_d_mem_access,"%t | %8h | %8h | READ  | %8h | \n", $realtime, PcQ104H, AddressDmQ104H , RdDataDmQ104H);
    end //if
    if (WrEnDmQ104H) begin 
        $fwrite(trk_d_mem_access,"%t | %8h | %8h | WRITE | %8h | \n", $realtime, PcQ104H, AddressDmQ104H , WrDataDmQ104H);
    end //if
end //shared_space
//logic [4:0]  RegWrPtrQ104H;
//logic [31:0] RegWrDataQ104H;
//assign RegWrDataQ104H   = ss_rvc_tb.ss_rvc.RegWrDataQ104H;
//assign RegWrPtrQ104H    = ss_rvc_tb.ss_rvc.RegWrDstQ104H;
////tracker on write to registers
//always @(posedge QClk) begin : write_to_registers
//    if (CtrlRegWrQ104H && RegWrPtrQ104H!=0) begin 
//        $fwrite(trk_write_registers,"%t | %08x |  x%01d  | %08x | \n", $realtime, PcQ104H, RegWrPtrQ104H , RegWrDataQ104H);
//    end //if
//end



