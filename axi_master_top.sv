module axi_master_top;

import uvm_pkg::*;
import axi_test_pkg::*;

bit clk;
bit rst;
always #5 clk = ~clk;
initial begin
  clk = 1;
  rst = 0;
  #5;
  rst = 1;
end

axi_master_interface tif (clk, rst);

axi_ram dut(
      .clk,
      .rst,

      .s_axi_awid     (tif.awid   ),
      .s_axi_awaddr   (tif.awaddr ),
      .s_axi_awlen    (tif.awlen  ),
      .s_axi_awsize   (tif.awsize ),
      .s_axi_awburst  (tif.awburst),
      .s_axi_awlock   (tif.awlock ),
      .s_axi_awcache  (tif.awcache),
      .s_axi_awprot   (tif.awprot ),
      .s_axi_awvalid  (tif.awvalid),
      .s_axi_awready  (tif.awready),
      .s_axi_wdata    (tif.wdata  ),
      .s_axi_wstrb    (tif.wstrb  ),
      .s_axi_wlast    (tif.wlast  ),
      .s_axi_wvalid   (tif.wvalid ),
      .s_axi_wready   (tif.wready ),
      .s_axi_bid      (tif.bid    ),
      .s_axi_bresp    (tif.bresp  ),
      .s_axi_bvalid   (tif.bvalid ),
      .s_axi_bready   (tif.bready ),
      .s_axi_arid     (tif.arid   ),
      .s_axi_araddr   (tif.araddr ),
      .s_axi_arlen    (tif.arlen  ),
      .s_axi_arsize   (tif.arsize ),
      .s_axi_arburst  (tif.arburst),
      .s_axi_arlock   (tif.arlock ),
      .s_axi_arcache  (tif.arcache),
      .s_axi_arprot   (tif.arprot ),
      .s_axi_arvalid  (tif.arvalid),
      .s_axi_arready  (tif.arready),
      .s_axi_rid      (tif.rid    ),
      .s_axi_rdata    (tif.rdata  ),
      .s_axi_rresp    (tif.rresp  ),
      .s_axi_rlast    (tif.rlast  ),
      .s_axi_rvalid   (tif.rvalid ),
      .s_axi_rread    (tif.rread  )
      );

  initial begin
    uvm_config_db#(virtual axi_interface)::set(null, "", "vif", tif);
    run_test("axi_base_test");
  end
endmodule
