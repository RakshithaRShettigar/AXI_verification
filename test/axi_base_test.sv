
//--------------------------------------------------------------------------------------------
// Class: axi4_base_test
// axi4_base test has the test scenarios for testbench 
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------

class axi4_base_test extends uvm_test;

   // factory registration  
  `uvm_component_utils(axi4_base_test)

  // Variable: axi4_env_h
  // Handle for environment 
  axi4_env axi4_env_h;

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes class object
//
// Parameters:
//  name - axi4_base_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------

function axi4_base_test::new(string name = "axi4_base_test",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

function void axi4_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // Create the environment
  axi4_env_h = axi4_env::type_id::create("axi4_env_h",this);
endfunction : build_phase


   //function for end of elaboration phase
   function void axi4_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
  uvm_test_done.set_drain_time(this,3000ns);
endfunction : end_of_elaboration_phase
//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation 
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

task axi4_base_test::run_phase(uvm_phase phase);

  phase.raise_objection(this, "axi4_base_test");

  `uvm_info(get_type_name(), $sformatf("Inside BASE_TEST"), UVM_NONE);
  super.run_phase(phase);
  #100;
  `uvm_info(get_type_name(), $sformatf("Done BASE_TEST"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase


endclass : axi4_base_test


