//--------------------------------------------------------------------------------------------
// Class: axi_master_write_16b_test
//  Extends the base test and starts the sequence of 16 bit write
//--------------------------------------------------------------------------------------------
class axi_master_write_16b_test extends axi_base_test;
  `uvm_component_utils(axi_master_write_16b_test)
  
  //Variable: axi_master_write_16b_transfer_h
  //Instantiation of axi_master_write_16b_transfer
  axi_master_write_16b_transfer axi_master_write_16b_transfer_h; 

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi_master_write_16b_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function new(string name = "axi_master_write_16b_test",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: run_phase
//  Creates the axi_master_write_16b_transfer sequence and starts the 16b write sequences
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task run_phase(uvm_phase phase);
  
  super.run_phase(phase);
  axi_master_write_16b_transfer_h = axi_master_write_16b_transfer::type_id::create("axi_master_write_16b_transfer_h");
  `uvm_info(get_type_name(),$sformatf("axi_master_write_16b_test"),UVM_LOW);
  phase.raise_objection(this);
    axi_master_write_16b_transfer_h .start(axi_master_env_h.axi_master_agt_h.axi_master_seqr_h);
    #100;
  phase.drop_objection(this);

endtask : run_phase

endclass : axi_master_write_16b_test
