//--------------------------------------------------------------------------------------------
// Class: axi_master_read_8b_transfer
// Extends the axi_master_base_sequence and randomises the req item
//--------------------------------------------------------------------------------------------
class axi_master_read_8b_transfer extends axi_master_base_sequence;
  `uvm_object_utils(axi_master_read_8b_transfer)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_master_read_8b_transfer");
  extern task body();
endclass : axi_master_read_8b_transfer

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi_master_read_8b_transfer
//--------------------------------------------------------------------------------------------
function axi_master_read_8b_transfer::new(string name = "axi_master_read_8b_transfer");
  super.new(name);
endfunction : new
//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type master transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi_master_read_8b_transfer::body();
  super.body();
  
  start_item(req);
  if(!req.randomize() with {req.arsize == READ_1_BYTES;
                            req.tx_type == READ;
                            req.arburst == READ_INCR;}) begin

    `uvm_fatal("axi4","Rand failed");
  end
  req.print();
  finish_item(req);

endtask : body
