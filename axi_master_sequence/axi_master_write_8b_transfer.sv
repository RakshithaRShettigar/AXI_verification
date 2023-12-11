//--------------------------------------------------------------------------------------------
// Class: axi_master_write_8b_transfer
// Extends the axi_master_base_sequence and randomises the req item
//--------------------------------------------------------------------------------------------
class axi_master_write_8b_transfer extends axi_master_base_sequence;
  `uvm_object_utils(axi_master_write_8b_transfer)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_master_write_8b_transfer");
  extern task body();
endclass : axi_master_write_8b_transfer

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi4_master_bk_write_8b_transfer_seq
//--------------------------------------------------------------------------------------------
    function axi_master_write_8b_transfer::new(string name = "axi_master_write_8b_transfer");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type master transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi_master_write_8b_transfer::body();
  super.body();
  `uvm_info(get_type_name(), $sformatf("DEBUG_MSHA :: BEFORE axi_master_write_8b_transfer"), UVM_NONE); 

  start_item(req);
  if(!req.randomize() with {req.s_axi_awsize == WRITE_1_BYTE;
                            req.s_axi_arvalid == 0;
                            req.s_axi_awvalid == 1;
                            req.awburst == WRITE_INCR;}) begin
    `uvm_fatal("axi4","Rand failed");
  end 
  finish_item(req);

endtask : body

