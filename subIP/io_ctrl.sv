//-----------------------------------------------------------------------------
// Title            : Input & Output Control
// Project          : SS_RVC
//-----------------------------------------------------------------------------
// File             : io_ctrl
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
module io_ctrl (
    //===========================
    //      Top Level Interface
    //===========================
    input   logic       QClk,            //
    input   logic       RstQnnnH,        //
    input   logic [9:0] TileIdStrapQnnnH,//
    //Ring Req - input
    input   logic       ReqValidQ500H,   //
    input   t_req_op    ReqOpcodeQ500H,  //
    input   t_xlen      ReqAddressQ500H, //
    input   t_xlen      ReqDataQ500H,    //
    //Ring Ack - output
    output  logic       RspValidQ503H,   //
    output  t_req_op    RspOpcodeQ503H,  //
    output  t_xlen      RspAddressQ503H, //
    output  t_xlen      RspDataQ503H,    //
    //===========================
    //      Local Memory Interface
    //===========================
    //Mem Req - output
    output  logic       ReqValidQ501H,   //
    output  t_req_op    ReqOpcodeQ501H,  //
    output  t_xlen      ReqAddressQ501H, //
    output  t_xlen      ReqDataQ501H,    //
    //Mem Ack - input
    input   logic       RspValidQ502H,   //
    input   t_req_op    RspOpcodeQ502H,  //
    input   t_xlen      RspAddressQ502H, //
    input   t_xlen      RspDataQ502H,    //
)

logic   MatchTileIdQ500H  , MatchTileIdQ501H   , MatchTileIdQ502H  ;
logic       IoReqValidQ501H   ,  IoReqValidQ502H   , FinalRspValidQ502H  ;

t_req_op    IoReqOpcodeQ501H  ,  IoReqOpcodeQ502H  , FinalRspOpcodeQ502H ;
t_xlen      IoReqAddressQ501H ,  IoReqAddressQ502H , FinalRspAddressQ502H;
t_xlen      IoReqDataQ501H    ,  IoReqDataQ502H    , FinalRspDataQ502H   ;


//Chick if request Address Matches the local Tile ID
assign MatchTileIdQ500H = (TileIdStrapQnnnH == ReqAddressQ500H[31:22]) && MatchTileIdQ500H;
`RVC_MSFF(MatchTileIdQ501H  , MatchTileIdQ500H  , QClk)
`RVC_MSFF(MatchTileIdQ502H  , MatchTileIdQ501H  , QClk)

//Q501H
`RVC_MSFF(IoReqValidQ501H  , ReqValidQ500H  , QClk)
`RVC_MSFF(IoReqOpcodeQ501H , ReqOpcodeQ500H , QClk)
`RVC_MSFF(IoReqAddressQ501H, ReqAddressQ500H, QClk)
`RVC_MSFF(IoReqDataQ501H   , ReqDataQ500H   , QClk)
assign ReqValidQ501H    = IoReqValidQ501H && MatchTileIdQ501H;
assign ReqOpcodeQ501H   = IoReqOpcodeQ501H 
assign ReqAddressQ501H  = IoReqAddressQ501H
assign ReqDataQ501H     = IoReqDataQ501H     
//Q502H
`RVC_MSFF(IoReqValidQ502H  , IoReqValidQ501H  , QClk)
`RVC_MSFF(IoReqOpcodeQ502H , IoReqOpcodeQ501H , QClk)
`RVC_MSFF(IoReqAddressQ502H, IoReqAddressQ501H, QClk)
`RVC_MSFF(IoReqDataQ502H   , IoReqDataQ501H   , QClk)
//mux Local MEM RSP with Pass-through
assign FinalRspValidQ502H   = MatchTileIdQ502H ? RspValidQ502H  : IoReqValidQ502H  ;
assign FinalRspOpcodeQ502H  = MatchTileIdQ502H ? RspOpcodeQ502H : IoReqOpcodeQ502H ;
assign FinalRspAddressQ502H = MatchTileIdQ502H ? RspAddressQ502H: IoReqAddressQ502H;
assign FinalRspDataQ502H    = MatchTileIdQ502H ? RspDataQ502H   : IoReqDataQ502H   ;
//Q503H
`RVC_MSFF(RspValidQ503H   , FinalRspValidQ502H  , QClk)
`RVC_MSFF(RspOpcodeQ503H  , FinalRspOpcodeQ502H , QClk)
`RVC_MSFF(RspAddressQ503H , FinalRspAddressQ502H, QClk)
`RVC_MSFF(RspDataQ503H    , FinalRspDataQ502H   , QClk)


endmodule //io_ctrl
