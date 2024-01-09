`timescale 1ns/1ps
import uvm_pkg::*;
 `include "uvm_macros.svh"
`include "axi4_globals_pkg.sv"
import axi4_globals_pkg::*;
//`include "axi4_globals_pkg.sv"
`include "axi_ram.v"
`include "axi_master_interface.sv"
`include "axi_master_transaction.sv"
`include "axi_master_sequence/axi_master_base_sequence.sv"
`include "axi_master_sequence/axi_master_write_16b_transfer.sv"
`include "axi_master_sequencer.sv"
`include "axi_master_driver.sv"
`include "monitor/axi_master_monitor.sv"
`include "agent/axi_master_agent.sv"
`include "axi_master_scoreboard.sv"
`include "axi_master_environment.sv"
`include "test/axi_base_test.sv"
`include "test/axi_master_write_16b_test.sv"


module axi_master_top;

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

      .s_axi_awid     (tif.s_axi_awid   ),
      .s_axi_awaddr   (tif.s_axi_awaddr ),
      .s_axi_awlen    (tif.s_axi_awlen  ),
      .s_axi_awsize   (tif.s_axi_awsize ),
      .s_axi_awburst  (tif.s_axi_awburst),
      .s_axi_awlock   (tif.s_axi_awlock ),
      .s_axi_awcache  (tif.s_axi_awcache),
      .s_axi_awprot   (tif.s_axi_awprot ),
      .s_axi_awvalid  (tif.s_axi_awvalid),
      .s_axi_awready  (tif.s_axi_awready),
      .s_axi_wdata    (tif.s_axi_wdata  ),
      .s_axi_wstrb    (tif.s_axi_wstrb  ),
      .s_axi_wlast    (tif.s_axi_wlast  ),
      .s_axi_wvalid   (tif.s_axi_wvalid ),
      .s_axi_wready   (tif.s_axi_wready ),
      .s_axi_bid      (tif.s_axi_bid    ),
      .s_axi_bresp    (tif.s_axi_bresp  ),
      .s_axi_bvalid   (tif.s_axi_bvalid ),
      .s_axi_bready   (tif.s_axi_bready ),
      .s_axi_arid     (tif.s_axi_arid   ),
      .s_axi_araddr   (tif.s_axi_araddr ),
      .s_axi_arlen    (tif.s_axi_arlen  ),
      .s_axi_arsize   (tif.s_axi_arsize ),
      .s_axi_arburst  (tif.s_axi_arburst),
      .s_axi_arlock   (tif.s_axi_arlock ),
      .s_axi_arcache  (tif.s_axi_arcache),
      .s_axi_arprot   (tif.s_axi_arprot ),
      .s_axi_arvalid  (tif.s_axi_arvalid),
      .s_axi_arready  (tif.s_axi_arready),
      .s_axi_rid      (tif.s_axi_rid    ),
      .s_axi_rdata    (tif.s_axi_rdata  ),
      .s_axi_rresp    (tif.s_axi_rresp  ),
      .s_axi_rlast    (tif.s_axi_rlast  ),
      .s_axi_rvalid   (tif.s_axi_rvalid ),
      .s_axi_rready    (tif.s_axi_rready  )
      );

  initial begin
  `uvm_info("TOP",$sformatf("in top"),UVM_NONE);
    uvm_config_db#(virtual axi_master_interface)::set(null, "", "vif", tif);
    run_test("axi_master_write_16b_test");
  end
endmodule
