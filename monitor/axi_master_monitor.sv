//AXI_MASTER_MONITOR PSEUDOCODE:
//-----------------------------------------------------------------------------------
//axi_master_monitor is user-defined class which is extended from uvm_monitor which is a pre-defined uvm class
class axi_master_monitor extends uvm_monitor 

//Factory registration
`uvm_component_utils(axi_master_monitor)

//Handle to virtual interface
virtual axi_master_interface vif;
  
//Declaring a handle of axi_master_sequence_item
axi_master_sequence_item req_op;

//Declaring 5 analysis ports to put 5 channel signals to 5 different FIFOs in scoreboard
uvm_analysis_port#(axi4_master_tx) axi4_master_write_analysis_port;
uvm_analysis_port#(axi4_master_tx) axi4_master_read_analysis_port;

//Different methods present in the class that are defined outside class using extern keyword
extern function new(string name = "axi4_master_monitor_proxy", uvm_component parent = null);
extern virtual function void build_phase(uvm_phase phase);
extern virtual function void connect_phase(uvm_phase phase);
extern virtual function void end_of_elaboration_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass : axi_master_monitor_

//--------------------------------------------------------------------------------
//Function: class constructor
function axi_master_monitor::new(string name = "axi_master_monitor", uvm_component parent = null);
  super.new(name, parent)
  axi4_master_read_analysis_port   = new("axi4_master_read_analysis_port",this);
  axi4_master_write_analysis_port  = new("axi4_master_write_analysis_port",this);
endfunction : new

//Function: Build phase
function void axi4_master_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual axi_master_interface)::get(this, "", "vif", vif))a
      `uvm_fatal("Monitor: ", "No vif is found!")
  end 
endfunction : build_phase 

//Function: connect phase
function void axi4_master_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//Task: run phase
task axi_master_monitor::run_phase(uvm_phase phase);
  if(vif.aresetn) begin
    fork  //to ensure both read and write signals are monitored parallely
      begin
        forever begin
          fork 
            begin
              //Taking data of write address channel
              do begin
                @(posedge vif.m_mp.clk);
              end
              while(vif_m_mp.m_cb.awvalid != 1 && vif.m_mp.m_cb.awready != 1);
              req_op.awid    = vif.m_mp.m_cb.awid ;
              req_op.awaddr  = vif.m_mp.m_cb.awaddr;
              req_op.awlen   = vif.m_mp.m_cb.awlen;
              req_op.awsize  = vif.m_mp.m_cb.awsize;
              req_op.awburst =vif.m_mp.m_cb.vawburst;
              req_op.awlock  = vif.m_mp.m_cb.awlock;
              req_op.awcache = vif.m_mp.m_cb.awcache;
              req_op.awprot  = vif.m_mp.m_cb.awprot;
            end
            begin
              static int i;
              //Taking data of write data channel
              forever begin
              do begin
                @(posedge vif.m_mp.clk);
              end
                while(vif.m_mp.m_cb.wvalid != 1 && vif.m_mp.m_cb.wready != 1);
               req_op.wdata[i] = vif.m_mp.m_cb.wdata;
               req_op.wstrb[i] = vif.m_mp.m_cb.wstrb;
               req_op.wuser[i] = vif.m_mp.m_cb.wuser;
               req_op.wlast = vif.m_mp.m_cb.wlast;
                if(req_op.wlast == 1) begin
                  i = 0;
                  break;
                end
                  i++;
              end
            end   
          join
          begin
          //Taking data of write response channel
          do begin
            @(posedge vif.m_mp.clk);
          end
          while(vif.m_mp.m_cb.bvalid != 1 && bready != 1);
         req_op.bid      = bid;
         req_op.bresp    = bresp;
          end
         
        end
      end

        begin
          forever begin
            //Taking data of read address channel
              do begin
                @(posedge vif.m_mp.clk);
              end
                while(awvalid != 1 && awready != 1);
              req_op.rwid    = vif.m_mp.m_cb.rwid ;
              req_op.rwaddr  = vif.m_mp.m_cb.rwaddr;
              req_op.rwlen   = vif.m_mp.m_cb.rwlen;
              req_op.rwsize  = vif.m_mp.m_cb.rwsize;
              req_op.rwburst = vif.m_mp.m_cb.rwburst;
              req_op.rwlock  = vif.m_mp.m_cb.rwlock;
              req_op.rwcache = vif.m_mp.m_cb.rwcache;
              req_op.rwprot  = vif.m_mp.m_cb.rwprot;
        
              static int j;
              //Taking data of read data channel
              forever begin
              do begin
                @(posedge vif.m_mp.clk);
              end
              while(rvalid != 1 && rready != 1);
               req_op.rid = vif.m_mp.m_cb.rid;
                req_op.rdata[j] = vif.m_mp.m_cb.rdata;
               req_op.ruser = vif.m_mp.m_cb.ruser;
               req_op.rresp = vif.m_mp.m_cb.rresp;
               req_op.rlast = vif.m_mp.m_cb.rlast;
                if(req_op.rlast == 1) begin
                  j = 0;
                  break;
                end
                  j++;
              end
            
          end
        end
    join_any
     axi4_master_analysis_port.write(req_op);
    wait fork;
  end
endtask
