//axi_MASTER_DRIVER IS THE USER DEFINED CLASS WHICH EXTENDS FROM UVM_DRIVER (PREDEFINED DRIVER CLASS) AND THE axi_MASTER_TRANSACTION IS PASSED AS A PARAMETER

class axi_master_driver extends uvm_driver #(axi_master_transaction); 
  // VIRTUAL INTERFACE HANDLE
  virtual axi_master_interface vif;
  semaphore write_addr_data=new(1);
  // TRANSACTION HANDLE
  axi_master_transaction req;
  
 // FACTORY REGISTRATION
// REGISTERING THE USER DEFINED CLASS IN THE LUT
`uvm_component_utils (axi_master_driver)
  
  // DECLARING FUNCTIONS & TASKS EXTERNALLY
 
extern function new(string name = "axi_master_driver", uvm_component parent = null);
 
extern virtual function void build_phase(uvm_phase phase);
 
extern virtual task run_phase(uvm_phase phase);
 
extern virtual task axi_write_task();
 
extern virtual task axi_read_task();
 
endclass : axi_master_driver
  
  // DEFINING THE CLASS CONSTRUCTOR OUTSIDE THE CLASS USING SCOPE RESOLUTION OPERATOR
 
function axi_master_driver::new(string name = "axi_master_driver", uvm_component parent = null);
	super.new(name, parent);
 
endfunction: new
 
// DEFINING BUILD PHASE OUTSIDE THE CLASS USING SCOPE RESOLUTION OPERATOR
function void axi_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
	if(!uvm_config_db #(virtual axi_master_interface)::get(this, " ", "vif", vif))
      `uvm_fatal("Driver:", "No virtual interface is found!");
 
endfunction: build_phase
 
task axi_master_driver::run_phase(uvm_phase phase);
  forever
    begin
      if(vif.rst) //CHECKING FOR RESET CONDITION
        begin
          $display("reset in driver = %0d at time %0t",vif.rst, $time);
          @(posedge vif.axi_master_dr_mp.clk)
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arvalid <=0;
          //vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_rvalid <=0;
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awvalid <=0;
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wvalid <=0;
          //vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_bvalid <=0;
        end
      else
        begin
          `uvm_info("driver",$sformatf("before get next"),UVM_NONE);
          seq_item_port.get_next_item(req); // SEQUENCE-DRIVER HANDSHAKE MECHANISM
          `uvm_info("driver",$sformatf("AFTER get next"),UVM_NONE);
          
          //WRITE-READ TASK DECLARED INSIDE FORK-JOIN (without begin-end) FOR PARALELL PROCESSING
          fork 
    	    axi_write_task();
    	    axi_read_task();
          join
          `uvm_info("DRIVER after driving",$sformatf("AT TIME %0t virtual interface awvalid %0d, req awvalid %0d",$time, vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awvalid,req.s_axi_awvalid), UVM_NONE);
      seq_item_port.item_done();// SEQUENCE-DRIVER HANDSHAKE MECHANISM
    end
    end
endtask
 
 //axi MASTER DRIVER WRITE TASK 
task axi_master_driver::axi_write_task();
  fork
    //WRITE ADDRESS CHANNEL LOGIC
	begin: WRITE_ADDRESS_CHANNEL
      if(req.s_axi_awvalid)
        begin
         @(posedge vif.axi_master_dr_mp.clk)
         // if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awready)
            begin
               write_addr_data.get(1);
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awaddr <= req.s_axi_awaddr;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awlen <= req.s_axi_awlen;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awid <= req.s_axi_awid;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awsize <= req.s_axi_awsize;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awburst <= req.s_axi_awburst;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awlock <= req.s_axi_awlock;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awcache <= req.s_axi_awcache;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awprot <= req.s_axi_awprot;
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awvalid <= req.s_axi_awvalid;
            end
          end
	end: WRITE_ADDRESS_CHANNEL
 // WRITE DATA CHANNEL LOGIC
	begin: WRITE_DATA_CHANNEL 

      if(req.s_axi_wvalid)
        begin
          begin
           // if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wready)
                  begin
                    int len = int '(req.s_axi_awlen);
                    for(int i=0;i<=len;i++)
                      begin
                      @(posedge vif.axi_master_dr_mp.clk)
                    	vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wdata <= req.s_axi_wdata.pop_front();
                    	vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wstrb <= req.s_axi_wstrb.pop_front();
                  		vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wvalid <= 1'b1;
                    	if(req.s_axi_wdata.size()>0)
                       		vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wlast<= 0;
                    	else
                       		vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wlast<= 1'b1;
                      end
                    write_addr_data.put(1);
                  end
          end
        end
 
    end: WRITE_DATA_CHANNEL
      // WRITE RESPONSE CHANNEL LOGIC
    begin: WRITE_RESPONSE_CHANNEL
     // if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_bvalid)
        begin
  //        @(posedge vif.axi_master_dr_mp.clk)
          begin
           // if(req.s_axi_bvalid)
              begin
               vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_bready <= 1'b1;
              end
          end
        end
	end: WRITE_RESPONSE_CHANNEL
join
 
endtask: axi_write_task
 
      // axi READ TASK
 
task axi_master_driver::axi_read_task();
begin
fork
  // READ ADDRESS CHANNEL LOGIC
	begin: READ_ADDRESS_CHANNEL
      if(req.s_axi_arvalid)
        begin
          @(posedge vif.axi_master_dr_mp.clk)
          begin
           // if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arready)
              begin
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arid <= req.s_axi_arid;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_araddr <= req.s_axi_araddr;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arlen <= req.s_axi_arlen;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arsize <= req.s_axi_arsize;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arburst <= req.s_axi_arburst;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arlock <= req.s_axi_arlock;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arcache <= req.s_axi_arcache;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arprot <= req.s_axi_arprot;
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arvalid <= 1'b1;
            end
        end
      end
    end: READ_ADDRESS_CHANNEL
      
 // READ DATA CHANNEL LOGIC
	begin: READ_DATA_CHANNEL
      if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_rvalid)
        begin
         // if(req.s_axi_rready)
            begin
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_rready <= 1'b1;
            end
        end
    end: READ_DATA_CHANNEL
 
join
end 
endtask : axi_read_task
