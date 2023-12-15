import uvm_pkg::*;
`include "globals/axi4_globals_pkg.sv"
//`ifndef AXI4_IF_INCLUDED_
 	//`define AXI4_IF_INCLUDED_

  	interface axi_master_interface(input clk,rst);
     //Declare all output and ouput signals as logic
       logic    [8-1:0]    s_axi_awid;
       logic    [16-1:0]   s_axi_awaddr;
       logic    [7:0]      s_axi_awlen;
       logic    [2:0]      s_axi_awsize;
       logic    [1:0]      s_axi_awburst;
      logic                s_axi_awlock;
      logic    [3:0]       s_axi_awcache;
     logic    [2:0]        s_axi_awprot;
      logic                s_axi_awvalid;
      logic                s_axi_awready;
      logic    [32-1:0]  s_axi_wdata;
      logic    [4-1:0]  s_axi_wstrb;
      logic                      s_axi_wlast;
      logic                      s_axi_wvalid;
      logic                     s_axi_wready;
      logic   [8-1:0]    s_axi_bid;
      logic   [1:0]             s_axi_bresp;
      logic                     s_axi_bvalid;
      logic                      s_axi_bready;
      logic    [8-1:0]    s_axi_arid;
      logic    [16-1:0]  s_axi_araddr;
      logic    [7:0]             s_axi_arlen;
      logic    [2:0]             s_axi_arsize;
      logic    [1:0]             s_axi_arburst;
      logic                      s_axi_arlock;
      logic    [3:0]             s_axi_arcache;
      logic    [2:0]             s_axi_arprot;
      logic                      s_axi_arvalid;
      logic                     s_axi_arready;
      logic   [8-1:0]    s_axi_rid;
      logic   [32-1:0]  s_axi_rdata;
      logic   [1:0]             s_axi_rresp;
      logic                     s_axi_rlast;
      logic                     s_axi_rvalid;
      logic                      s_axi_rready;
 
  //clocking blocks are used for synchronization between DUT and testbench
  //Clocking block for master driver
      clocking axi_master_dr_cb @(posedge clk);
      default input #1 output #1;
      output       s_axi_awid;
      output      s_axi_awaddr;
      output              s_axi_awlen;
      output               s_axi_awsize;
      output             s_axi_awburst;
      output                      s_axi_awlock;
      output              s_axi_awcache;
      output              s_axi_awprot;
      output                      s_axi_awvalid;
      input                     s_axi_awready;
      output     s_axi_wdata;
      output     s_axi_wstrb;
      output                      s_axi_wlast;
      output                      s_axi_wvalid;
      input                     s_axi_wready;
      input       s_axi_bid;
      input                s_axi_bresp;
      input                     s_axi_bvalid;
      output                      s_axi_bready;
      output       s_axi_arid;
      output      s_axi_araddr;
      output             s_axi_arlen;
      output            s_axi_arsize;
      output               s_axi_arburst;
      output                      s_axi_arlock;
      output              s_axi_arcache;
      output                s_axi_arprot;
      output                      s_axi_arvalid;
      input                     s_axi_arready;
      input       s_axi_rid;
      input     s_axi_rdata;
      input              s_axi_rresp;
      input                     s_axi_rlast;
      input                     s_axi_rvalid;
      output                    s_axi_rready;
    endclocking
 
     //clocking block for master monitor
 
       clocking axi_master_mo_cb @(posedge clk);
      default input #1 output #1;
       input   s_axi_awid;
       input   s_axi_awaddr;
       input              s_axi_awlen;
       input                s_axi_awsize;
       input              s_axi_awburst;
       input                     s_axi_awlock;
       input              s_axi_awcache;
       input              s_axi_awprot;
       input                     s_axi_awvalid;
       input                    s_axi_awready;
       input    s_axi_wdata;
       input     s_axi_wstrb;
       input                     s_axi_wlast;
       input                     s_axi_wvalid;
       input                    s_axi_wready;
       input      s_axi_bid;
       input              s_axi_bresp;
       input                    s_axi_bvalid;
       input                     s_axi_bready;
       input       s_axi_arid;
       input     s_axi_araddr;
       input              s_axi_arlen;
       input               s_axi_arsize;
       input              s_axi_arburst;
       input                     s_axi_arlock;
       input               s_axi_arcache;
       input               s_axi_arprot;
       input                     s_axi_arvalid;
       input                    s_axi_arready;
       input    s_axi_rid;
       input    s_axi_rdata;
       input             s_axi_rresp;
       input                    s_axi_rlast;
       input                    s_axi_rvalid;
       input                     s_axi_rready;
     endclocking

      //Declare modports to specify the directions
      //modport for master driver

       modport axi_master_dr_mp(input clk,rst,clocking axi_master_dr_cb);

       //modport for master monitor
       modport axi_master_mo_mp(input clk,rst,clocking axi_master_mo_cb);


   endinterface
  //`endif
