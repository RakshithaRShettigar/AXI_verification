//--------------------------------------------------------------------------------------------
// Class: axi4_master_tx
// This class holds the data items required to drive the stimulus to dut
//--------------------------------------------------------------------------------------------
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//import axi4_globals_pkg::*;
class axi_master_transaction extends uvm_sequence_item;
  `uvm_object_utils(axi_master_transaction)
  
  //-----------------Declaration of signals-----------------
  
  //-------------------------------------------------------
  // WRITE ADDRESS CHANNEL SIGNALS
  //------------------------------------------------------- 
  rand awid_e            s_axi_awid;
  rand bit [ADDRESS_WIDTH-1:0]  s_axi_awaddr;
  rand bit [7:0]             s_axi_awlen;
  rand awsize_e              s_axi_awsize;
  rand awburst_e             s_axi_awburst;
  rand awlock_e              s_axi_awlock;
  rand awcache_e             s_axi_awcache;
  rand awprot_e              s_axi_awprot;
  rand bit                   s_axi_awvalid;
  bit                        s_axi_awready;
  //-------------------------------------------------------
  // WRITE DATA CHANNEL SIGNALS
  //-------------------------------------------------------
  rand bit [DATA_WIDTH-1:0]  s_axi_wdata[$:2**LENGTH];
  rand bit [STROBE_WIDTH-1:0]  s_axi_wstrb[$:2**LENGTH];
  rand bit                   s_axi_wlast;
  rand bit                   s_axi_wvalid;
  bit                        s_axi_wready;
  //-------------------------------------------------------
  // WRITE RESPONSE CHANNEL SIGNALS
  //-------------------------------------------------------
  bid_e                      s_axi_bid;
  bresp_e                    s_axi_bresp;
  bit                        s_axi_bvalid;
  rand bit                   s_axi_bready;
  //-------------------------------------------------------
  // READ ADDRESS CHANNEL SIGNALS
  //-------------------------------------------------------
  rand arid_e                s_axi_arid;
  rand bit [ADDRESS_WIDTH-1:0]  s_axi_araddr;
  rand bit [7:0]             s_axi_arlen;
  rand arsize_e              s_axi_arsize;
  rand arburst_e             s_axi_arburst;
  rand arlock_e              s_axi_arlock;
  rand arcache_e             s_axi_arcache;
  rand arprot_e              s_axi_arprot;
  rand bit                   s_axi_arvalid;
  bit                        s_axi_arready;
  //-------------------------------------------------------
  // READ DATA CHANNEL SIGNALS 
  //-------------------------------------------------------
  rand rid_e                      s_axi_rid;
  bit [DATA_WIDTH-1:0]       s_axi_rdata[$:2**LENGTH];
  bit [1:0]                  s_axi_rresp;
  bit                        s_axi_rlast;
  bit                        s_axi_rvalid;
  rand bit                   s_axi_rready;

  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
   
  

  
  //------------------write adresss constraint------------------
 
  
  //constraint to select burt length based on burst type
  constraint burst_length_select_c2 { if(s_axi_awburst== WRITE_FIXED)
                                    s_axi_awlen inside{[0:15]};
                                     else if (s_axi_awburst== WRITE_INCR)
                                    s_axi_awlen inside{[0:255]};}
  //constraint for write address
//constraint for aligned write address
  constraint alligned_write_address {  soft s_axi_awaddr  == (s_axi_awaddr % (2**s_axi_awsize )==0);}
 

  //------------------write data constraint------------------

  
  //Constraint : write_data_c1
  //Adding constraint to restrict the write data based on awlength
constraint write_data_c1 {s_axi_wdata.size() == s_axi_awlen + 1;} 

  //Constraint : write_strobe_c2
  //Adding constraint to restrict the write strobe based on awlength
constraint write_strobe_c2 {s_axi_wstrb.size() == s_axi_awlen + 1;}

 
  //Constraint : write_strobe_c3
  //This constraint is used to decide the s_axi_awdata size based on s_axi_awsize
  constraint write_strobe_c3{if(s_axi_awsize == WRITE_1_BYTE)
  						$countones (s_axi_wstrb) == 1;
                             else if(s_axi_awsize == WRITE_2_BYTES)
                                    $countones (s_axi_wstrb) == 2;
                              else 
                                  $countones (s_axi_wstrb) == 4;
                             }


  //------------------read adresss constraint------------------

  
//constraint for aligned read address
 constraint alligned_read_address {  soft s_axi_araddr  == (s_axi_araddr % (2**s_axi_arsize )==0);}


//constraint for read burst length
  constraint read_burst_length { if(  s_axi_arburst == READ_FIXED ){
                                                    s_axi_arlen  inside { [ 0 : 15] }} ;
                                                   else if (s_axi_arburst == READ_INCR)
                                                       s_axi_arlen  inside { [0:255]}; }   
  
  
  extern function new (string name = "axi_master_transaction");    
endclass

    
//--------------------------------------------------------------------------------------------
function axi_master_transaction::new(string name = "axi_master_transaction");
  super.new(name);
endfunction : new
