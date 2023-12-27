//AXI_MASTER_MONITOR PSEUDOCODE:
//-----------------------------------------------------------------------------------
//axi_master_monitor is user-defined class which is extended from uvm_monitor which is a pre-defined uvm class
import uvm_pkg::*;
`include "uvm_macros.svh"
class axi_master_monitor extends uvm_monitor;

//Factory registration
`uvm_component_utils(axi_master_monitor)

//Handle to virtual interface
virtual axi_master_interface vif;
  
//Declaring a handle of axi_master_sequence_item
axi_master_transaction req_in;

//Declaring a structure hnadle
axi_master_struct req_op;

//Declaring 5 analysis ports to put 5 channel signals to 5 different FIFOs in scoreboard
  uvm_analysis_port#(axi_master_transaction) item_got_port;
static int j;


//Different methods present in the class that are defined outside class using extern keyword
extern function new(string name = "axi_master_monitor", uvm_component parent = null);
extern virtual function void build_phase(uvm_phase phase);
extern virtual function void connect_phase(uvm_phase phase);
//extern virtual function void end_of_elaboration_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);
extern function void from_class(input axi_master_transaction req_in, output axi_master_struct
req_op);
extern function void to_class(input axi_master_struct req_op, output axi_master_transaction
req_in)
endclass : axi_master_monitor

//--------------------------------------------------------------------------------
//Function: class constructor
function axi_master_monitor::new(string name = "axi_master_monitor", uvm_component parent = null);
  super.new(name, parent);
  item_got_port   = new("item_got_port",this);
endfunction : new

//Function: Build phase
function void axi_master_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual axi_master_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Monitor: ", "No vif is found!")
   
endfunction : build_phase 

//Function: connect phase
function void axi_master_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//Function: from_class
function void axi_master_monitor::from_class(input axi_master_transaction req_in, output axi_master_struct req_op);
  $cast(req_op.s_axi_awid,req_in.s_axi_awid);
  $cast(req_op.s_axi_awlen,req_in.s_axi_awlen);
  $cast(req_op.s_axi_awsize,req_in.s_axi_awsize);
  $cast(req_op.s_axi_awburst,req_in.s_axi_awburst);
  $cast(req_op.s_axi_awlock,req_in.s_axi_awlock);
  $cast(req_op.s_axi_awcache,req_in.s_axi_awcache);
  $cast(req_op.s_axi_awprot,req_in.s_axi_awprot);
  $cast(req_op.s_axi_bid,req_in.s_axi_bid);
  $cast(req_op.s_axi_bresp,req_in.s_axi_bresp);
  req_op.s_axi_awaddr=req_in.s_axi_awaddr;

  foreach(req_in.wdata[i]) begin
    if(req_in.wdata[i] != 0)begin
      req_op.wdata[i] = req_in.wdata[i];
     // `uvm_info("axi_master_seq_item_conv_class",$sformatf("After converting wdata =  %0p",req_op.wdata),UVM_HIGH);
    end
  end

  foreach(req_in.wdata[i]) begin
    if(req_in.wdata[i] != 0)begin
      req_op.wstrb[i] = req_in.wstrb[i];
      //  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wstrb = %0p",req_op.wstrb[i]),UVM_HIGH);
    end
  end


    req_op.wlast = req_in.wlast;
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting wlast =  %0h",req_op.wlast),UVM_HIGH);


  //read channel
  $cast(req_op.arid,req_in.arid);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arid =  %b",req_op.arid),UVM_HIGH);

  $cast(req_op.arlen,req_in.arlen);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After conrveting arlen =  %b",req_op.arlen),UVM_HIGH);

  $cast(req_op.arsize,req_in.arsize);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arsize =  %b",req_op.arsize),UVM_HIGH);

  $cast(req_op.arburst,req_in.arburst);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arburst =  %b",req_op.arburst),UVM_HIGH);

  $cast(req_op.arlock,req_in.arlock);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arlock =  %b",req_op.arlock),UVM_HIGH);

  $cast(req_op.arcache,req_in.arcache);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arcache =  %b",req_op.arcache),UVM_HIGH);

  $cast(output_conv_h.arprot,req_in.arprot);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting arprot =  %b",req_op.arprot),UVM_HIGH);

  $cast(req_op.rresp,req_in.rresp);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting rresp =  %b",req_op.rresp),UVM_HIGH);
  
  req_op.araddr = req_in.araddr;
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting araddr =  %0h",req_op.araddr),UVM_HIGH);

  $cast(req_op.rid,input_conv_h.rid);
  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting rid =  %b",req_op.rid),UVM_HIGH);

  foreach(req_in.rdata[i]) begin
    if(req_in.rdata[i] != 0)begin
      req_op.rdata[i] = req_in.rdata[i];
      `uvm_info("axi4_master_seq_item_conv_class",$sformatf("After converting rdata = %0p",req_op.rdata[i]),UVM_HIGH);
    end
  end

  

//  `uvm_info("axi4_master_seq_item_conv_class",$sformatf("----------------------------------------------------------------------"),UVM_HIGH);
endfunction



//Task: run phase
task axi_master_monitor::run_phase(uvm_phase phase);
  forever begin : FOREVER
    if(!vif.aresetn) begin : LOW_RESET
      axi_master_monitor::from_class(req_in,req_op);
    fork  //to ensure both read and write signals are monitored parallely
      begin : WRITE_PROCESS
          fork 
            begin : WRITE_ADDRESS
              //Taking data of write address channel
              do begin
                @(posedge vif.axi_master_mo_mp.clk);
              end
              while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awvalid != 1 && vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awready != 1);
              req_op.s_axi_awid    = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awid ;
              req_op.s_axi_awaddr  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awaddr;
              req_op.s_axi_awlen   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awlen;
              req_op.s_axi_awsize  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awsize;
              req_op.s_axi_awburst =vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awburst;
              req_op.s_axi_awlock  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awlock;
              req_op.s_axi_awcache = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awcache;
              req_op.s_axi_awprot  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awprot;
            end : WRITE_ADDRESS
            
            begin : WRITE_DATA
              static int i;
              //Taking data of write data channel
              //forever begin
              do begin
                @(posedge vif.axi_master_mo_mp.clk);
              end
                while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wvalid != 1 && vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wready != 1);
              while(1) begin: WHILE_LOOP_WRITE
               req_op.s_axi_wdata[i] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wdata;
               req_op.s_axi_wstrb[i] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wstrb;
               //req_op.s_axi_wuser[i] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wuser;
               req_op.s_axi_wlast = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wlast;
               req_op.s_axi_wvalid  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wvalid;
               req_op.s_axi_wready  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wready;
                if(req_op.s_axi_wlast == 1) begin
                  i = 0;
                  break;
                end
                  i++;
              end: WHILE_LOOP_WRITE   
            end : WRITE_DATA  
          join
          begin : WRITE_RESPONSE
          //Taking data of write response channel
          do begin
            @(posedge vif.axi_master_mo_mp.clk);
          end
          while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bvalid != 1 && vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bready != 1);
         req_op.s_axi_bid      = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bid;
         req_op.s_axi_bresp    = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bresp;
         req_op.s_axi_bvalid   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bvalid;
         req_op.s_axi_bready   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bready;
          end : WRITE_RESPONSE   
      end : WRITE_PROCESS
      
        begin : READ_PROCESS
            //Taking data of read address channel
              do begin
                @(posedge vif.axi_master_mo_mp.clk);
              end
              while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arvalid != 1 && vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arready != 1);
              req_op.s_axi_arid    = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arid ;
              req_op.s_axi_araddr  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_araddr;
              req_op.s_axi_arlen   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arlen;
              req_op.s_axi_arsize  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arsize;
              req_op.s_axi_arburst = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arburst;
              req_op.s_axi_arlock  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arlock;
              req_op.s_axi_arcache = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arcache;
              req_op.s_axi_arprot  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arprot;
              req_op.s_axi_arvalid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arvalid;
              req_op.s_axi_arready = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arready;
          
              //static int j;
              //Taking data of read data channel
              do begin
                @(posedge vif.axi_master_mo_mp.clk);
              end
              while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid != 1 && vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rready != 1);
            while(1) begin: WHILE_LOOP_READ
               req_op.s_axi_rid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rid;
               req_op.s_axi_rdata[j] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rdata;
              // req_op.s_axi_ruser = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_ruser;
               req_op.s_axi_rresp = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rresp;
               req_op.s_axi_rlast = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rlast;
               req_op.s_axi_rvalid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid;
               req_op.s_axi_rvalid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid;
                if(req_op.s_axi_rlast == 1) begin
                  j = 0;
                  break;
                end
                  j++;
                end: WHILE_LOOP_READ
              end : READ_PROCESS
            join_any
  axi_master_monitor::to_class(req_op,req_in);
          //end : LOW_RESET
       // end : FOREVER
    //join_any
     item_got_port.write(req_in);
    wait fork;
   end : LOW_RESET
  end : FOREVER

endtask
      
