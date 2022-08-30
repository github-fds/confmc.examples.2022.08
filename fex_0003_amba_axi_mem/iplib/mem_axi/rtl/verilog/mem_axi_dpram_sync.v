//--------------------------------------------------------
// Copyright (c) 2022 by Future Design Systems Inc.
// All right reserved.
//
// http://www.future-ds.com
//--------------------------------------------------------
// mem_axi_dpram_sync.v
//--------------------------------------------------------
// VERSION = 2022.08.20.
//--------------------------------------------------------
// Simple Dual-Port RAM
//  - one port for write
//  - one port for read
//--------------------------------------------------------
// Macros and parameters:
//--------------------------------------------------------
// size of memory in byte: 1<<WIDTH_AD
// requires: 'WIDTH_DS' 8-bit BRAM of depth 1<<(ADDR_LENGTH-WIDTH_DSB)
//----------------------------------------------------------------

module mem_axi_dpram_sync
     #(parameter WIDTH_AD =10 // width of address
               , WIDTH_DA =32 // width of a line in bytes
               , WIDTH_DS =(WIDTH_DA/8) // width of a line in bytes
               , WIDTH_DSB=$clog2(WIDTH_DS)
               )
(
        input  wire                RESETn
      , input  wire                CLK
      , input  wire [WIDTH_AD-1:0] WADDR
      , input  wire [WIDTH_DA-1:0] WDATA
      , input  wire [WIDTH_DS-1:0] WSTRB
      , input  wire                WEN
      , input  wire [WIDTH_AD-1:0] RADDR
      , output wire [WIDTH_DA-1:0] RDATA
      , input  wire [WIDTH_DS-1:0] RSTRB
      , input  wire                REN
);
    //----------------------------------------------------
    localparam DEPTH_BIT=(WIDTH_AD-WIDTH_DSB);
    localparam DEPTH=(1<<DEPTH_BIT);
    //----------------------------------------------------
    generate
    genvar bs;
    for (bs=0; bs<WIDTH_DS; bs=bs+1) begin: mem_core
        mem_axi_dpram_sync_core #(.WIDTH_AD(WIDTH_AD-WIDTH_DSB))
        u_dpram_sync_core (
              .RESETn (RESETn             )
            , .CLK    (CLK                )
            , .WADDR  (WADDR[WIDTH_AD-1:WIDTH_DSB])
            , .WDATA  (WDATA[8*bs+7:8*bs] )
            , .WEN    (WEN&WSTRB[bs]      )
            , .RADDR  (RADDR[WIDTH_AD-1:WIDTH_DSB])
            , .RDATA  (RDATA[8*bs+7:8*bs] )
            , .REN    (REN&RSTRB[bs]      )
        );
    end
    endgenerate
endmodule
//----------------------------------------------------------------
module mem_axi_dpram_sync_core #(parameter WIDTH_AD=8)
(
       input  wire                 RESETn
     , input  wire                 CLK
     , input  wire [WIDTH_AD-1:0]  WADDR
     , input  wire [7:0]           WDATA
     , input  wire                 WEN
     , input  wire [WIDTH_AD-1:0]  RADDR
     , output reg  [7:0]           RDATA=8'h0
     , input  wire                 REN
);
     //-----------------------------------------------------------
     localparam DEPTH = (1<<WIDTH_AD);
     //-----------------------------------------------------------
     (* ram_style = "block" *) reg [7:0] mem[0:DEPTH-1];
     //-----------------------------------------------------------
     always @ (posedge CLK ) begin
         if (WEN==1'b1) mem[WADDR] <= WDATA; // write case
         if (REN==1'b1) RDATA <= mem[RADDR]; // read case
     end
     //-----------------------------------------------------------
endmodule
//--------------------------------------------------------
// Revision History
//
// 2022.08.20: Updated to use Xilinx BRAM.
// 2013.02.03: Start by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
