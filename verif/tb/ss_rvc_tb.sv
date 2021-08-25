//-----------------------------------------------------------------------------
// Title            : the RVC Test Bench
// Project          : SS_RVC
//-----------------------------------------------------------------------------
// File             : ss_rvc_tb.sv
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

`timescale 1ps/1ps
`include "ss_rvc_defines.sv"

module ss_rvc_tb ();
import ss_rvc_pkg::*; 

// clock and reset
logic  QClk;
logic  RstQnnnH;

// clock generation
initial begin: clock_gen
        QClk = 1'b0;
    forever begin
        #5 QClk = 1'b1;
        #5 QClk = 1'b0;
    end
end

// reset generation
initial begin: reset_gen
        RstQnnnH = 1'b1;
    #40 RstQnnnH = 1'b0;
end


//================================================================================
//==========================      test_seq      ==================================
//================================================================================
// loading the test from verif/Tests/ - getting the HPATH from Environment
`define TEST_DEFINE(x) `"x`"
`define HPATH 
string hpath = `TEST_DEFINE(`HPATH);

logic [7:0]  IMemQnnnH     [I_MEM_OFFSET+SIZE_I_MEM-1:I_MEM_OFFSET];
//logic [7:0]  DMemQnnnH     [D_MEM_OFFSET+SIZE_D_MEM-1:D_MEM_OFFSET];

`RVC_MSFF(IMemQnnnH, IMemQnnnH, QClk)
//`RVC_MSFF(DMemQnnnH, DMemQnnnH, QClk)

initial begin: test_seq
    $display({"\n======================= \n start test \"",hpath,"\"\n======================= \n "});
    //======================================
    //load the program to the TB
    //======================================
    $readmemh({"../verif/tests/",hpath,"/",hpath,"_inst_mem.sv"}, ss_rvc_tb.mem_wrap.i_mem.mem);
    $readmemh({"../verif/tests/",hpath,"/",hpath,"_inst_mem.sv"}, ss_rvc_tb.mem_wrap.i_mem.next_mem);
    #10000         
    end_tb("\nERROR: End-Of-Test Timeout\n");
end: test_seq


//================================
//      MEM_WRAP<->SS_RVC
//================================
//Core -> Mem
t_xlen          PcQ100H;
t_instruction   InstructionQ101H;
//Mem -> Core
t_xlen          AddressDmQ103H;
t_xlen          WrDataDmQ103H ;
logic           RdEnDmQ103H   ;
logic           WrEnDmQ103H   ;
t_xlen          RdDataDmQ104H ;
logic RstPcQnnnH;
assign RstPcQnnnH =1'b0;
//=====================
//          The DUT
//======================
ss_rvc ss_rvc (
    .QClk             (QClk),            //input
    .RstQnnnH         (RstQnnnH),        //input
    .RstPcQnnnH       (RstPcQnnnH),      //input
    //I_MEM - Instruction Fetch
    .PcQ100H          (PcQ100H),         //output
    .InstructionQ101H (InstructionQ101H),//input
    //D_MEM - Load/Store Interface
    .AddressDmQ103H   (AddressDmQ103H),  //output
    .WrDataDmQ103H    (WrDataDmQ103H),   //output
    .WrEnDmQ103H      (WrEnDmQ103H)      //output
    );


//======================
//  VC of memory - not part of DUT - its part of TB
//======================
mem_wrap mem_wrap (
    .QClk             (QClk),            //input
    .RstQnnnH         (RstQnnnH),        //input
    //===========================
    //      IO_CTRL interface
    //===========================
    //Mem Req - input
    .ReqValidQ501H    ('0), //input
    .ReqOpcodeQ501H   (RD), //input
    .ReqAddressQ501H  ('0), //input
    .ReqDataQ501H     ('0), //input
    //Mem Ack - output
    .RspValidQ502H    (), //output
    .RspOpcodeQ502H   (), //output
    .RspAddressQ502H  (), //output
    .RspDataQ502H     (),  //output
    //===========================
    //      SS_RVC Interface (Core interface)
    //===========================
    //I_MEM - Instruction Fetch
    .PcQ100H          (PcQ100H),         //input
    .InstructionQ101H (InstructionQ101H),//output
    //D_MEM - Load/Store Interface
    .AddressDmQ103H   (AddressDmQ103H),  //input
    .WrDataDmQ103H    (WrDataDmQ103H),   //input
    .RdEnDmQ103H      ('0),              //input
    .WrEnDmQ103H      (WrEnDmQ103H),     //input
    .RdDataDmQ104H    ()               //output
);

//================================================================================
//==========================  tracker and logs  ==================================
//================================================================================
`include "trk_gen_ss_rvc.sv"

//================================================================================
//==========================      End Of Test   ==================================
//================================================================================

// sv task that initiate ending routine :
// 1.snapshot of data memory to text file
// 4.fclose on all open files    
// 5.exit test with message   
task end_tb;
    input string msg;
    integer d_mem_snpshot,i,j,l;
    d_mem_snpshot=$fopen({"../regression/",hpath,"/d_mem_snapshot.log"},"w");
    for (i = 0 ; i < SIZE_D_MEM; i = i+4) begin  
        $fwrite(d_mem_snpshot,"Offset %08x : %02x%02x%02x%02x\n",i+D_MEM_OFFSET, mem_wrap.d_mem.mem[i+3],mem_wrap.d_mem.mem[i+2],mem_wrap.d_mem.mem[i+1],mem_wrap.d_mem.mem[i]);
    end
    $fclose(trk_d_mem_access);  
    $fclose(trk_write_registers);  
    $fclose(d_mem_snpshot);
    $display({"=======================\nTest : ",hpath,msg,"\n"});        
    $finish;
endtask


endmodule // tb_top
