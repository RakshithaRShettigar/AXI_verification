  


  1     `ifndef AXI4_IF_INCLUDED_
  2	`define AXI4_IF_INCLUDED_

  3	interface axi_master_interface(input clk,rst);
  4   //Declare all output and ouput signals as logic
  5     logic    [ID_WIDTH-1:0]    s_axi_awid;
  6     logic    [ADDR_WIDTH-1:0]  s_axi_awaddr;
  7     logic    [7:0]             s_axi_awlen;
  8     logic    [2:0]             s_axi_awsize;
  9     logic    [1:0]             s_axi_awburst;
 10     logic                      s_axi_awlock;
 11     logic    [3:0]             s_axi_awcache;
 12     logic    [2:0]             s_axi_awprot;
 13     logic                      s_axi_awvalid;
 14     logic                     s_axi_awready;
 15     logic    [DATA_WIDTH-1:0]  s_axi_wdata;
 16     logic    [STRB_WIDTH-1:0]  s_axi_wstrb;
 17     logic                      s_axi_wlast;
 18     logic                      s_axi_wvalid;
 19     logic                     s_axi_wready;
 20     logic   [ID_WIDTH-1:0]    s_axi_bid;
 21     logic   [1:0]             s_axi_bresp;
 22     logic                     s_axi_bvalid;
 23     logic                      s_axi_bready;
 24     logic    [ID_WIDTH-1:0]    s_axi_arid;
 25     logic    [ADDR_WIDTH-1:0]  s_axi_araddr;
 26     logic    [7:0]             s_axi_arlen;
 27     logic    [2:0]             s_axi_arsize;
 28     logic    [1:0]             s_axi_arburst;
 29     logic                      s_axi_arlock;
 30     logic    [3:0]             s_axi_arcache;
 31     logic    [2:0]             s_axi_arprot;
 32     logic                      s_axi_arvalid;
 33     logic                     s_axi_arready;
 34     logic   [ID_WIDTH-1:0]    s_axi_rid;
 35     logic   [DATA_WIDTH-1:0]  s_axi_rdata;
 36     logic   [1:0]             s_axi_rresp;
 37     logic                     s_axi_rlast;
 38     logic                     s_axi_rvalid;
 39     logic                      s_axi_rready;
 40
 41 //clocking blocks are used for synchronization between DUT and testbench
 42 //Clocking block for master driver
 43     clocking axi_master_dr_cb @(posedge clk);
 44     default output #1 input #1;
 45     output    [ID_WIDTH-1:0]    s_axi_awid;
 46     output    [ADDR_WIDTH-1:0]  s_axi_awaddr;
 47     output    [7:0]             s_axi_awlen;
 48     output    [2:0]             s_axi_awsize;
 49     output    [1:0]             s_axi_awburst;
 50     output                      s_axi_awlock;
 51     output    [3:0]             s_axi_awcache;
 52     output    [2:0]             s_axi_awprot;
 53     output                      s_axi_awvalid;
 54     input                     s_axi_awready;
 55     output    [DATA_WIDTH-1:0]  s_axi_wdata;
 56     output    [STRB_WIDTH-1:0]  s_axi_wstrb;
 57     output                      s_axi_wlast;
 58     output                      s_axi_wvalid;
 59     input                     s_axi_wready;
 60     input   [ID_WIDTH-1:0]    s_axi_bid;
 61     input   [1:0]             s_axi_bresp;
 62     input                     s_axi_bvalid;
 63     output                      s_axi_bready;
 64     output    [ID_WIDTH-1:0]    s_axi_arid;
 65     output    [ADDR_WIDTH-1:0]  s_axi_araddr;
 66     output    [7:0]             s_axi_arlen;
 67     output    [2:0]             s_axi_arsize;
 68     output    [1:0]             s_axi_arburst;
 69     output                      s_axi_arlock;
 70     output    [3:0]             s_axi_arcache;
 71     output    [2:0]             s_axi_arprot;
 72     output                      s_axi_arvalid;
 73     input                     s_axi_arready;
 74     input   [ID_WIDTH-1:0]    s_axi_rid;
 75     input   [DATA_WIDTH-1:0]  s_axi_rdata;
 76     input   [1:0]             s_axi_rresp;
 77     input                     s_axi_rlast;
 78     input                     s_axi_rvalid;
 79     output                    s_axi_rready;
 80
 81    //clocking block for master monitor
 82
 83      clocking axi_master_mo_cb @(posedge clk);
 84     default input #1 output #1;
 85      input   [ID_WIDTH-1:0]    s_axi_awid;
 86     input   [ADDR_WIDTH-1:0]  s_axi_awaddr;
 87     input   [7:0]             s_axi_awlen;
 88     input   [2:0]             s_axi_awsize;
 89     input   [1:0]             s_axi_awburst;
 90     input                     s_axi_awlock;
 91     input   [3:0]             s_axi_awcache;
 92     input   [2:0]             s_axi_awprot;
 93     input                     s_axi_awvalid;
 94     input                    s_axi_awready;
 95     input   [DATA_WIDTH-1:0]  s_axi_wdata;
 96     input   [STRB_WIDTH-1:0]  s_axi_wstrb;
 97     input                     s_axi_wlast;
 98     input                     s_axi_wvalid;
 99     input                    s_axi_wready;
100     input  [ID_WIDTH-1:0]    s_axi_bid;
101     input  [1:0]             s_axi_bresp;
102     input                    s_axi_bvalid;
103     input                     s_axi_bready;
104     input   [ID_WIDTH-1:0]    s_axi_arid;
105     input   [ADDR_WIDTH-1:0]  s_axi_araddr;
106     input   [7:0]             s_axi_arlen;
107     input   [2:0]             s_axi_arsize;
108     input   [1:0]             s_axi_arburst;
109     input                     s_axi_arlock;
110     input   [3:0]             s_axi_arcache;
111     input   [2:0]             s_axi_arprot;
112     input                     s_axi_arvalid;
113     input                    s_axi_arready;
114     input  [ID_WIDTH-1:0]    s_axi_rid;
115     input  [DATA_WIDTH-1:0]  s_axi_rdata;
116     input  [1:0]             s_axi_rresp;
117     input                    s_axi_rlast;
118     input                    s_axi_rvalid;
119     input                     s_axi_rready;
120
121
122     //Declare modports to specify the directions
123     //modport for master driver
124
125     modport axi_master_ dr_mp(input clk,rst,clocking axi_master_dr_cb);
126
127     //modport for master monitor
128     modport axi_master_mo_mp(input clk,rst,clocking axi_master_ mo_cb);
129
130
131 endinterface
132 `endif
