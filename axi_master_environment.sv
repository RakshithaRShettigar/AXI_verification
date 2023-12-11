`include "axi_master_agent.sv"
`include "axi_master_scoreboard.sv"
`include "axi_master_coverage.sv"

class axi_master_environment extends uvm_env;
  axi_master_agent axi_master_agt_h;
  axi_master_scoreboard axi_master_scb_h;
  axi_master_coverage axi_master_cov_h;
  `uvm_component_utils(axi_master_environment)

  function new(string name = "axi_master_environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi_master_agt_h = axi_master_agent::type_id::create("axi_master_agt", this);
    axi_master_scb_h = axi_master_scoreboard::type_id::create("axi_master_scb", this);
    axi_master_cov_h = axi_master_coverage::type_id::create("axi_master_cov", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    axi_master_agt_h.axi_master_mon_h.item_got_port.connect(axi_master_scb_h.item_got_export);
    axi_master_agt_h.axi_master_mon_h.item_got_port.connect(axi_master_cov_h.item_got_export_sub);
  endfunction

endclass
