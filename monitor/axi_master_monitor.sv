// Code your testbench here
// or browse Examples
//AXI_MASTER_MONITOR PSEUDOCODE:
//-----------------------------------------------------------------------------------
//axi_master_monitor is user-defined class which is extended from uvm_monitor which is a pre-defined uvm class
//import uvm_pkg::*;
//`include "uvm_macros.svh"
class axi_master_monitor extends uvm_monitor;

//Factory registration
`uvm_component_utils(axi_master_monitor)

//Handle to virtual interface
virtual axi_master_interface vif;
  
//Declaring a handle of axi_master_sequence_item
axi_master_transaction req_op;

//Declaring 5 analysis ports to put 5 channel signals to 5 different FIFOs in scoreboard
  uvm_analysis_port#(axi_master_transaction) item_got_port;
static int j;


//Different methods present in the class that are defined outside class using extern keyword
extern function new(string name = "axi_master_monitor", uvm_component parent = null);
extern virtual function void build_phase(uvm_phase phase);
extern virtual function void connect_phase(uvm_phase phase);
//extern virtual function void end_of_elaboration_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);
//extern function void from_class(input axi_master_transaction req_in, output axi_master_struct
//req_op);
//extern function void to_class(input axi_master_struct req_op, output axi_master_transaction
//req_in)
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
      else
        `uvm_info("Monitor: ","Vif found",UVM_NONE)
  req_op = axi_master_transaction::type_id::create("req_op");
   
endfunction : build_phase 

//Function: connect phase
function void axi_master_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//Task: run phase
task axi_master_monitor::run_phase(uvm_phase phase);

  forever begin : FOREVER
     @(posedge vif.axi_master_mo_mp.clk);
    if(!vif.axi_master_mo_mp.rst) begin : LOW_RESET
      $display("at time %0t reset is %0d",$time, vif.rst);
    fork  //to ensure both read and write signals are monitored parallely
      begin : WRITE_PROCESS
          fork 
            begin : WRITE_ADDRESS
              //Taking data of write address channel
              do begin
              `uvm_info("VALID READY", $sformatf("awvalid = %0d, awready = %0d",vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awready),UVM_NONE);

                @(posedge vif.axi_master_mo_mp.clk);
              end
              while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awvalid !== 1 || vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awready !== 1);
              `uvm_info("VALID READY", $sformatf("awvalid = %0d, awready = %0d",vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awready),UVM_NONE);
//               req_op.s_axi_awid    = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awid ;
//               req_op.s_axi_awaddr  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awaddr;
//               req_op.s_axi_awlen   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awlen;
//               req_op.s_axi_awsize  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awsize;
//               req_op.s_axi_awburst =vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awburst;
//               req_op.s_axi_awlock  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awlock;
//               req_op.s_axi_awcache = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awcache;
//               req_op.s_axi_awprot  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awprot;
              
//              $cast(req_op.s_axi_awid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awid);
              $cast(req_op.s_axi_awaddr, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awaddr);
              $cast(req_op.s_axi_awlen, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awlen);
              $cast(req_op.s_axi_awsize, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awsize);
              $cast(req_op.s_axi_awburst, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awburst);
              $cast(req_op.s_axi_awlock, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awlock);
              $cast(req_op.s_axi_awcache, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awcache);
              $cast(req_op.s_axi_awprot, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awprot);
              
            end : WRITE_ADDRESS
            
            begin : WRITE_DATA
              static int i;
              //Taking data of write data channel
              //forever begin
              do begin
                @(posedge vif.axi_master_mo_mp.clk);
              end
                while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wvalid !== 1 || vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wready !== 1);
              while(1) begin: WHILE_LOOP_WRITE
//                req_op.s_axi_wdata[i] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wdata;
//                req_op.s_axi_wstrb[i] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wstrb;
//                //req_op.s_axi_wuser[i] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wuser;
//                req_op.s_axi_wlast = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wlast;
//                req_op.s_axi_wvalid  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wvalid;
//                req_op.s_axi_wready  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wready;
               $cast(req_op.s_axi_wdata[i], vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wdata);
               $cast(req_op.s_axi_wstrb[i], vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wstrb);
               //req_op.s_axi_wuser[i] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wuser;
               $cast(req_op.s_axi_wlast ,vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wlast);
               //$cast(req_op.s_axi_wvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wvalid);
               //$cast(req_op.s_axi_wready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wready);
               `uvm_info("Monitor", $sformatf("wlast = %0d", vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wlast), UVM_NONE);
                if(req_op.s_axi_wlast == 1) begin
                  i = 0;
                  break;
                end
                  i++;
                    
                @(posedge vif.axi_master_mo_mp.clk);
              end: WHILE_LOOP_WRITE   
               
            end : WRITE_DATA  
          join
          begin : WRITE_RESPONSE
          //Taking data of write response channel
          do begin
            @(posedge vif.axi_master_mo_mp.clk);
          end
          while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bvalid !== 1 || vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bready !== 1);
//          req_op.s_axi_bid      = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bid;
//          req_op.s_axi_bresp    = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bresp;
//          req_op.s_axi_bvalid   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bvalid;
//          req_op.s_axi_bready   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bready;
            $cast(req_op.s_axi_bid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bid);
            $cast(req_op.s_axi_bresp, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bresp);
            //$cast(req_op.s_axi_bvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bvalid);
            //$cast(req_op.s_axi_bready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bready);
            
          end : WRITE_RESPONSE  
          $display("BEFORE WRITE PROCESS ENDS");
      end : WRITE_PROCESS
      
        begin : READ_PROCESS
            //Taking data of read address channel
              do begin
                @(posedge vif.axi_master_mo_mp.clk);
              end
              while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arvalid != 1 || vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arready != 1);
//               req_op.s_axi_arid    = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arid ;
//               req_op.s_axi_araddr  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_araddr;
//               req_op.s_axi_arlen   = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arlen;
//               req_op.s_axi_arsize  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arsize;
//               req_op.s_axi_arburst = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arburst;
//               req_op.s_axi_arlock  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arlock;
//               req_op.s_axi_arcache = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arcache;
//               req_op.s_axi_arprot  = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arprot;
//               req_op.s_axi_arvalid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arvalid;
//               req_op.s_axi_arready = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arready;
//         $cast(req_op.s_axi_arid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arid);
          $cast(req_op.s_axi_araddr, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_araddr);
          $cast(req_op.s_axi_arlen, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arlen);
          $cast(req_op.s_axi_arsize, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arsize);
          $cast(req_op.s_axi_arburst, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arburst);
          $cast(req_op.s_axi_arlock, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arlock);
          $cast(req_op.s_axi_arcache, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arcache);
          $cast(req_op.s_axi_arprot, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arprot);
          //$cast(req_op.s_axi_arvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arvalid);
          //$cast(req_op.s_axi_arready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arready);
          
              //static int j;
              //Taking data of read data channel
              do begin
                @(posedge vif.axi_master_mo_mp.clk);
              end
              while(vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid != 1 || vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rready != 1);
            while(1) begin: WHILE_LOOP_READ
//                req_op.s_axi_rid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rid;
//                req_op.s_axi_rdata[j] = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rdata;
//               // req_op.s_axi_ruser = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_ruser;
//                req_op.s_axi_rresp = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rresp;
//                req_op.s_axi_rlast = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rlast;
//                req_op.s_axi_rvalid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid;
//                req_op.s_axi_rvalid = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid;
 //             $cast(req_op.s_axi_rid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rid);
              $cast(req_op.s_axi_rdata[j], vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rdata);
              // req_op.s_axi_ruser = vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_ruser;
              $cast(req_op.s_axi_rresp, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rresp);
              $cast(req_op.s_axi_rlast, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rlast);
              //$cast(req_op.s_axi_rvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid);
              //$cast(req_op.s_axi_rvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid);
                if(req_op.s_axi_rlast == 1) begin
                  j = 0;
                  break;
                end
                  j++;
                @(posedge vif.axi_master_mo_mp.clk);

                end: WHILE_LOOP_READ
              end : READ_PROCESS
            join_any
          //end : LOW_RESET
       // end : FOREVER
    //join_any
      $cast(req_op.s_axi_awvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awvalid);
      $cast(req_op.s_axi_awready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_awready);
      $cast(req_op.s_axi_wvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wvalid);
      $cast(req_op.s_axi_wready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_wready);
      $cast(req_op.s_axi_bvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bvalid);
      $cast(req_op.s_axi_bready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_bready);
      $cast(req_op.s_axi_arvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arvalid);
      $cast(req_op.s_axi_arready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_arready);
      $cast(req_op.s_axi_rvalid, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rvalid);
      $cast(req_op.s_axi_rready, vif.axi_master_mo_mp.axi_master_mo_cb.s_axi_rready);
      $display("AFTER FORK JOIN ANY OF MONITOR(BEFORE WRITE CALL");
      $display("BVALID AND BREADY %0d %0d",req_op.s_axi_bvalid, req_op.s_axi_bready);
        item_got_port.write(req_op);
   // wait fork;
   end : LOW_RESET
  end : FOREVER

endtask
      
