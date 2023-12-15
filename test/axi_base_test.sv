
//--------------------------------------------------------------------------------------------
// Class: axi_base_test
// axi_base test has the test scenarios for testbench 
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------

class axi_base_test extends uvm_test;

   // factory registration  
  `uvm_component_utils(axi_base_test)

  // Variable: axi_master_environmet_h
  // Handle for environment 
  axi_master_environmet axi_env_h;

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes class object
//
// Parameters:
//  name - axi_base_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------

function axi_base_test::new(string name = "axi_base_test",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

function void axi_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // Create the environment
  axi_master_environmet_h = axi_env::type_id::create("axi_env_h",this);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation 
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

task axi_base_test::run_phase(uvm_phase phase);

  phase.raise_objection(this, "axi_base_test");

  `uvm_info(get_type_name(), $sformatf("Inside BASE_TEST"), UVM_NONE);
  super.run_phase(phase);
  #100;
  `uvm_info(get_type_name(), $sformatf("Done BASE_TEST"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase


endclass : axi_base_test
