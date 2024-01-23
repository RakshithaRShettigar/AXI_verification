//--------------------------------------------------------------------------------------------
// Class: axi_master_write_16b_transfer
// Extends the axi_master_base_sequence and randomises the req item
//--------------------------------------------------------------------------------------------
class axi_master_write_16b_transfer extends axi_master_base_sequence;
  `uvm_object_utils(axi_master_write_16b_transfer)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_master_write_16b_transfer");
  extern task body();
endclass : axi_master_write_16b_transfer

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes new memory for the object
//
// Parameters:
//  name - axi_master_write_16b_transfer
//--------------------------------------------------------------------------------------------
function axi_master_write_16b_transfer::new(string name = "axi_master_write_16b_transfer");
  super.new(name);
endfunction : new
//--------------------------------------------------------------------------------------------
// Task: body
// Creates the req of type master transaction and randomises the req
//--------------------------------------------------------------------------------------------
task axi_master_write_16b_transfer::body();
  super.body();
  req = axi_master_transaction::type_id::create("req"); 
  start_item(req);
  $display("write tr");
  if(!req.randomize() with {req.s_axi_awsize == WRITE_2_BYTES;
                            req.s_axi_arvalid == 0;
                            req.s_axi_awvalid == 1;
                            req.s_axi_wvalid ==  1;
                            req.s_axi_awburst == WRITE_INCR;}) begin

    `uvm_fatal("axi4","Rand failed");
  end
  req.print();
  finish_item(req);
  req = axi_master_transaction::type_id::create("req"); 
  start_item(req);
  $display("read tr");
  if(!req.randomize() with {req.s_axi_arsize == READ_2_BYTES;
                            req.s_axi_arvalid == 1;
                            req.s_axi_awvalid == 0;
                            req.s_axi_wvalid ==  0;
                            req.s_axi_arburst == READ_INCR;}) begin

    `uvm_fatal("axi","Rand failed");
  end
  req.print();
  finish_item(req);


endtask : body
