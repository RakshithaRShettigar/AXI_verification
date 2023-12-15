`ifndef AXI_MASTER_BASE_SEQ_INCLUDED_
`define AXI_MASTER_BASE_SEQ_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class : axi_master_base_sequence
// Creating master_base_seq extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class axi_master_base_sequence extends uvm_sequence#(axi_master_transaction);
  `uvm_object_utils(axi_master_base_sequence)


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi_master_base_sequence");
//   extern task body();

endclass : axi_master_base_sequence

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi_master_base_sequence
//--------------------------------------------------------------------------------------------
function axi_master_base_sequence::new(string name = "axi_master_base_sequence");
  super.new(name);
endfunction : new

`endif
