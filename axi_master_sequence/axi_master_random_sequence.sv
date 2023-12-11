//--------------------------------------------------------------------------------------------
// Class: axi_master_random_sequence
// Extends axi_master_base_sequence and randomises the req item
//--------------------------------------------------------------------------------------------
class axi_master_random_sequence extends axi_master_base_sequence;
  `uvm_object_utils(axi_master_random_sequence)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_master_random_sequence");
  extern task body();
endclass : axi_master_random_sequence

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi_master_random_sequence
//--------------------------------------------------------------------------------------------
function axi_master_random_sequence::new(string name = "axi_master_random_sequence");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type master transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi_master_random_sequence::body();
  super.body();
  `uvm_info(get_type_name(),$sformatf("axi_master_random_sequence"),UVM_LOW);
  req=axi_master_sequence_item::type_id::create("req");
  start_item(req);
  req.randomize();
  req.print();
  finish_item(req);
endtask : body
