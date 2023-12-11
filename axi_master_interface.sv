  


       `ifndef AXI4_IF_INCLUDED_
 	`define AXI4_IF_INCLUDED_

  	interface axi_master_interface(input clk,rst);
     //Declare all output and ouput signals as logic
       logic    [ID_WIDTH-1:0]    s_axi_awid;
       logic    [ADDR_WIDTH-1:0]  s_axi_awaddr;
       logic    [7:0]             s_axi_awlen;
       logic    [2:0]             s_axi_awsize;
       logic    [1:0]             s_axi_awburst;
      logic                      s_axi_awlock;
      logic    [3:0]             s_axi_awcache;
     logic    [2:0]             s_axi_awprot;
      logic                      s_axi_awvalid;
      logic                     s_axi_awready;
      logic    [DATA_WIDTH-1:0]  s_axi_wdata;
      logic    [STRB_WIDTH-1:0]  s_axi_wstrb;
      logic                      s_axi_wlast;
      logic                      s_axi_wvalid;
      logic                     s_axi_wready;
      logic   [ID_WIDTH-1:0]    s_axi_bid;
      logic   [1:0]             s_axi_bresp;
      logic                     s_axi_bvalid;
      logic                      s_axi_bready;
      logic    [ID_WIDTH-1:0]    s_axi_arid;
      logic    [ADDR_WIDTH-1:0]  s_axi_araddr;
      logic    [7:0]             s_axi_arlen;
      logic    [2:0]             s_axi_arsize;
      logic    [1:0]             s_axi_arburst;
      logic                      s_axi_arlock;
      logic    [3:0]             s_axi_arcache;
      logic    [2:0]             s_axi_arprot;
      logic                      s_axi_arvalid;
      logic                     s_axi_arready;
      logic   [ID_WIDTH-1:0]    s_axi_rid;
      logic   [DATA_WIDTH-1:0]  s_axi_rdata;
      logic   [1:0]             s_axi_rresp;
      logic                     s_axi_rlast;
      logic                     s_axi_rvalid;
      logic                      s_axi_rready;
 
  //clocking blocks are used for synchronization between DUT and testbench
  //Clocking block for master driver
      clocking axi_master_dr_cb @(posedge clk);
      default output #1 input #1;
      output    [ID_WIDTH-1:0]    s_axi_awid;
      output    [ADDR_WIDTH-1:0]  s_axi_awaddr;
      output    [7:0]             s_axi_awlen;
      output    [2:0]             s_axi_awsize;
      output    [1:0]             s_axi_awburst;
      output                      s_axi_awlock;
      output    [3:0]             s_axi_awcache;
      output    [2:0]             s_axi_awprot;
      output                      s_axi_awvalid;
      input                     s_axi_awready;
      output    [DATA_WIDTH-1:0]  s_axi_wdata;
      output    [STRB_WIDTH-1:0]  s_axi_wstrb;
      output                      s_axi_wlast;
      output                      s_axi_wvalid;
      input                     s_axi_wready;
      input   [ID_WIDTH-1:0]    s_axi_bid;
      input   [1:0]             s_axi_bresp;
      input                     s_axi_bvalid;
      output                      s_axi_bready;
      output    [ID_WIDTH-1:0]    s_axi_arid;
      output    [ADDR_WIDTH-1:0]  s_axi_araddr;
      output    [7:0]             s_axi_arlen;
      output    [2:0]             s_axi_arsize;
      output    [1:0]             s_axi_arburst;
      output                      s_axi_arlock;
      output    [3:0]             s_axi_arcache;
      output    [2:0]             s_axi_arprot;
      output                      s_axi_arvalid;
      input                     s_axi_arready;
      input   [ID_WIDTH-1:0]    s_axi_rid;
      input   [DATA_WIDTH-1:0]  s_axi_rdata;
      input   [1:0]             s_axi_rresp;
      input                     s_axi_rlast;
      input                     s_axi_rvalid;
      output                    s_axi_rready;
 
     //clocking block for master monitor
 
       clocking axi_master_mo_cb @(posedge clk);
      default input #1 output #1;
       input   [ID_WIDTH-1:0]    s_axi_awid;
       input   [ADDR_WIDTH-1:0]  s_axi_awaddr;
       input   [7:0]             s_axi_awlen;
       input   [2:0]             s_axi_awsize;
       input   [1:0]             s_axi_awburst;
       input                     s_axi_awlock;
       input   [3:0]             s_axi_awcache;
       input   [2:0]             s_axi_awprot;
       input                     s_axi_awvalid;
       input                    s_axi_awready;
       input   [DATA_WIDTH-1:0]  s_axi_wdata;
       input   [STRB_WIDTH-1:0]  s_axi_wstrb;
       input                     s_axi_wlast;
       input                     s_axi_wvalid;
       input                    s_axi_wready;
       input  [ID_WIDTH-1:0]    s_axi_bid;
       input  [1:0]             s_axi_bresp;
       input                    s_axi_bvalid;
       input                     s_axi_bready;
       input   [ID_WIDTH-1:0]    s_axi_arid;
       input   [ADDR_WIDTH-1:0]  s_axi_araddr;
       input   [7:0]             s_axi_arlen;
       input   [2:0]             s_axi_arsize;
       input   [1:0]             s_axi_arburst;
       input                     s_axi_arlock;
       input   [3:0]             s_axi_arcache;
       input   [2:0]             s_axi_arprot;
       input                     s_axi_arvalid;
       input                    s_axi_arready;
       input  [ID_WIDTH-1:0]    s_axi_rid;
       input  [DATA_WIDTH-1:0]  s_axi_rdata;
       input  [1:0]             s_axi_rresp;
       input                    s_axi_rlast;
       input                    s_axi_rvalid;
       input                     s_axi_rready;


      //Declare modports to specify the directions
      //modport for master driver

       modport axi_master_ dr_mp(input clk,rst,clocking axi_master_dr_cb);

       //modport for master monitor
       modport axi_master_mo_mp(input clk,rst,clocking axi_master_ mo_cb);


   endinterface
  `endif
