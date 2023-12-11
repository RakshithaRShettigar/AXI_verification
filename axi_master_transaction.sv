//--------------------------------------------------------------------------------------------
// Class: axi4_master_tx
// This class holds the data items required to drive the stimulus to dut
//--------------------------------------------------------------------------------------------

class axi_master_transaction extends uvm_sequence_item;
  `uvm_object_utils(axi_master_transaction)
  
  //-----------------Declaration of signals-----------------
  
  //-------------------------------------------------------
  // WRITE ADDRESS CHANNEL SIGNALS
  //------------------------------------------------------- 
  rand bit [ID_WIDTH-1:0]    s_axi_awid;
  rand bit [ADDR_WIDTH-1:0]  s_axi_awaddr;
  rand bit [7:0]             s_axi_awlen;
  rand bit [2:0]             s_axi_awsize;
  rand bit [1:0]             s_axi_awburst;
  rand bit                   s_axi_awlock;
  rand bit [3:0]             s_axi_awcache;
  rand bit [2:0]             s_axi_awprot;
  rand bit                   s_axi_awvalid;
  bit                        s_axi_awready;
  //-------------------------------------------------------
  // WRITE DATA CHANNEL SIGNALS
  //-------------------------------------------------------
  rand bit [DATA_WIDTH-1:0]  s_axi_wdata;
  rand bit [STRB_WIDTH-1:0]  s_axi_wstrb;
  rand bit                   s_axi_wlast;
  rand bit                   s_axi_wvalid;
  bit                        s_axi_wready;
  //-------------------------------------------------------
  // WRITE RESPONSE CHANNEL SIGNALS
  //-------------------------------------------------------
  bit [ID_WIDTH-1:0]         s_axi_bid;
  bit [1:0]                  s_axi_bresp;
  bit                        s_axi_bvalid;
  rand bit                   s_axi_bready;
  //-------------------------------------------------------
  // READ ADDRESS CHANNEL SIGNALS
  //-------------------------------------------------------
  rand bit [ID_WIDTH-1:0]    s_axi_arid;
  rand bit [ADDR_WIDTH-1:0]  s_axi_araddr;
  rand bit [7:0]             s_axi_arlen;
  rand bit [2:0]             s_axi_arsize;
  rand bit [1:0]             s_axi_arburst;
  rand bit                   s_axi_arlock;
  rand bit [3:0]             s_axi_arcache;
  rand bit [2:0]             s_axi_arprot;
  rand bit                   s_axi_arvalid;
  bit                        s_axi_arready;
  //-------------------------------------------------------
  // READ DATA CHANNEL SIGNALS 
  //-------------------------------------------------------
  bit [ID_WIDTH-1:0]         s_axi_rid;
  bit [DATA_WIDTH-1:0]       s_axi_rdata;
  bit [1:0]                  s_axi_rresp;
  bit                        s_axi_rlast;
  bit                        s_axi_rvalid;
  rand bit                   s_axi_rready;

  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
   
  `uvm_object_utils_begin(axi_master_transaction)
  `uvm_field_int(s_axi_awid, UVM_ALL_ON)
  `uvm_field_int(s_axi_awaddr, UVM_ALL_ON)
  `uvm_field_int(s_axi_awlen, UVM_ALL_ON)
  `uvm_field_int(s_axi_awsize, UVM_ALL_ON)
  `uvm_field_int(s_axi_awburst, UVM_ALL_ON)
  `uvm_field_int(s_axi_awlock, UVM_ALL_ON)
  `uvm_field_int(s_axi_awcache, UVM_ALL_ON)
  `uvm_field_int(s_axi_awprot, UVM_ALL_ON)
  `uvm_field_int(s_axi_awvalid, UVM_ALL_ON)
  `uvm_field_int(s_axi_awready, UVM_ALL_ON)

  `uvm_field_int(s_axi_wdata, UVM_ALL_ON)
  `uvm_field_int(s_axi_wstrb, UVM_ALL_ON)
  `uvm_field_int(s_axi_wlast, UVM_ALL_ON)
  `uvm_field_int(s_axi_wvalid, UVM_ALL_ON)
  `uvm_field_int(s_axi_wready, UVM_ALL_ON)

  `uvm_field_int(s_axi_bid, UVM_ALL_ON)
  `uvm_field_int(s_axi_bresp, UVM_ALL_ON)
  `uvm_field_int(s_axi_bvalid, UVM_ALL_ON)
  `uvm_field_int(s_axi_bready, UVM_ALL_ON)

  `uvm_field_int(s_axi_arid, UVM_ALL_ON)
  `uvm_field_int(s_axi_araddr, UVM_ALL_ON)
  `uvm_field_int(s_axi_arlen, UVM_ALL_ON)
  `uvm_field_int(s_axi_arsize, UVM_ALL_ON)
  `uvm_field_int(s_axi_arburst, UVM_ALL_ON)
  `uvm_field_int(s_axi_arlock, UVM_ALL_ON)
  `uvm_field_int(s_axi_arcache, UVM_ALL_ON)
  `uvm_field_int(s_axi_arprot, UVM_ALL_ON)
  `uvm_field_int(s_axi_arvalid, UVM_ALL_ON)
  `uvm_field_int(s_axi_arready, UVM_ALL_ON)

  `uvm_field_int(s_axi_rid, UVM_ALL_ON)
  `uvm_field_int(s_axi_rdata, UVM_ALL_ON)
  `uvm_field_int(s_axi_rresp, UVM_ALL_ON)
  `uvm_field_int(s_axi_rlast, UVM_ALL_ON)
  `uvm_field_int(s_axi_rvalid, UVM_ALL_ON)
  `uvm_field_int(s_axi_rready, UVM_ALL_ON)
  `uvm_object_utils_end

  
  //------------------constraint------------------
 
  
  //constraint to select burt length based on burst type
  constraint burst_length_select_c2 { if(s_axi_awburst==e_WRAP)
                                    s_axi_awlen inside{[0:15]};
                                    else if (s_axi_awburst==e_INCR)
                                    s_axi_awlen inside{[0:255]};}
 
 // WRITE DATA Constraints
  //-------------------------------------------------------
  //Constraint : write_data_c1
  //Adding constraint to restrict the write data based on awlength
constraint write_data_c1 {s_axi_wdata.size() == s_axi_awlen + 1;} 

  //Constraint : write_strobe_c2
  //Adding constraint to restrict the write strobe based on awlength
constraint write_strobe_c2 {s_axi_wstrb.size() == s_axi_awlen + 1;}

 
  //Constraint : write_strobe_c3
  //This constraint is used to decide the s_axi_awdata size based on s_axi_awsize
constraint write_strobe_c3{if(s_axi_awsize == 32'd8)
  						$countones (s_axi_wstrb) == 1;
                             else if(s_axi_awsize == 32'd16)
                                    $countones (s_axi_wstrb) == 2;
                              else if(s_axi_awsize == 32'd24)
                                    $countones (s_axi_wstrb) == 3;
                              else 
                                  $countones (s_axi_wstrb) == 4;
                             }

 //constraint for read address
//constraint for aligned read address
 constraint alligned_read_address {  soft s_axi_araddr  == (s_axi_araddr % (2**s_axi_arsize )==0);}

// constraint for read burst type
constraint read_burst_type { s_axi_arburst inside { 2’b00, 2’b01};}

//constraint for read burst length
constraint read_burst_length { if(  s_axi_arburst == ( 2’b00 ) 
                                                    s_axi_arlen  inside { [ 0 : 15] } ;
                                                   else if s_axi_arburst == 2’b10
                                                       s_axi_arlen  inside { [0:255]}; }  
  
  
  extern function new (string name = "axi_master_trasaction");
  extern function void do_print(uvm_printer printer);
    
endclass
