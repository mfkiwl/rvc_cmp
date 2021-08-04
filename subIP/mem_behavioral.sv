//-----------------------------------------------------------------------------
// Title            : Behavioral Memory
// Project          : SS_RVC
//-----------------------------------------------------------------------------
// File             : mem_behavioral.sv
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
module mem_behavioral 
              #(parameter                    MSB_MEM_SIZE = 128,
                parameter                    MSB_MEM      = 7)
               (input  logic                 clock      ,
                //core access
                input  logic [MSB_MEM:2]     address_a  ,
                input  logic [31:0]          data_a     ,
                input  logic                 rden_a     ,
                input  logic                 wren_a     ,
                output logic [31:0]          q_a        ,
                //ring access
                input  logic [MSB_MEM:2]     address_b  ,
                input  logic [31:0]          data_b     ,
                input  logic                 rden_b     ,
                input  logic                 wren_b     ,
                output logic [31:0]          q_b   
               );
logic [7:0]  mem      [MSB_MEM_SIZE-1:0];
logic [7:0]  next_mem [MSB_MEM_SIZE-1:0];
logic [31:0] pre_q_a;  

//=======================================
//          Writing to memory
//=======================================
always_comb begin
    next_mem = mem;
    if(wren_a) begin
        next_mem[{address_a,2'b00}]= data_a[7:0];
        next_mem[{address_a,2'b01}]= data_a[15:8];
        next_mem[{address_a,2'b10}]= data_a[23:16];
        next_mem[{address_a,2'b11}]= data_a[31:24]; 
    end
    if(wren_b) begin
        next_mem[{address_b,2'b00}]= data_b[7:0];
        next_mem[{address_b,2'b01}]= data_b[15:8];
        next_mem[{address_b,2'b10}]= data_b[23:16];
        next_mem[{address_b,2'b11}]= data_b[31:24]; 
    end
end 

//=======================================
//          the memory Array
//=======================================
`RVC_MSFF(mem, next_mem, clock)

//=======================================
//          reading the memory
//=======================================
assign pre_q_a = rden_a ? {mem[{address_a,2'b11}], mem[{address_a,2'b10}], mem[{address_a,2'b01}], mem[{address_a,2'b00}]} : '0;
assign pre_q_b = rden_b ? {mem[{address_b,2'b11}], mem[{address_b,2'b10}], mem[{address_b,2'b01}], mem[{address_b,2'b00}]} : '0;
// sample the read - synchorus read
`RVC_MSFF(q_a, pre_q_a, clock)
`RVC_MSFF(q_b, pre_q_b, clock)

endmodule
