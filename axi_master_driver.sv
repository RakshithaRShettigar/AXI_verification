//AXI MASTER DRIVER IS THE USER DEFINED CLASS WHICH EXTENDS FROM UVM DRIVER (PREDEFINED DRIVER CLASS) AND THE MASTER TRANSACTION IS PASSED AS A PARAMETER

class axi4_master_driver extends uvm_driver #(axi4_master_transaction);
  // VIRTUAL INTERFACE HANDLE
  virtual axi_master_interface vif;
  semaphore write_addr_data=new(1);
  // TRANSACTION HANDLE
  axi4_master_transaction req;

// FACTORY REGISTRATION
// REGISTERING THE USER DEFINED CLASS IN THE LUT
`uvm_component_utils (axi4_master_driver)
  

// DECLARING FUNCTIONS & TASKS EXTERNALLY
extern function new(string name = "axi4_master_driver", uvm_component parent = null);

extern virtual function void build_phase(uvm_phase phase);

extern virtual task run_phase(uvm_phase phase);

extern virtual task axi4_write_task();

extern virtual task axi4_read_task();

endclass : axi4_master_driver 
  
// DEFINING THE CLASS CONSTRUCTOR OUTSIDE THE CLASS USING SCOPE RESOLUTION OPERATOR

function axi4_master_driver::new(string name = "axi4_master_driver", uvm_component parent = null);
	super.new(name, parent);

endfunction: new

// DEFINING BUILD PHASE OUTSIDE THE CLASS USING SCOPE RESOLUTION OPERATOR

function void axi4_master_driver::build_phase(uvm_phase phase);
  	
  super.build_phase(phase);
	
  if(!uvm_config_db #(virtual axi4_interface)::get(this, " ", "virtual_interface", vif))
      `uvm_fatal("Driver:", "No virtual interface is found!");

endfunction: build_phase

// DEFINING RUN PHASE OUTSIDE THE CLASS USING SCOPE RESOLUTION OPERATOR

// GETS THE SEQUENCER ITEMS FROM THE SEQUENCER AND THEN CONVERTS IT TO PIN LEVEL AND SENDS IT TO THE DUT

task axi4_master_driver::run_phase(uvm_phase phase);
  forever
    begin
      if(!vif.rst) // CHECKING FOR RESET CONDITION
        begin
          @(posedge vif.axi_master_dr_mp.clk)
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arvalid <=0;
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_rvalid <=0;
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awvalid <=0;
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wvalid <=0;
          vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_bvalid <=0;
        end
      else
        begin
          seq_item_port.get_next_item(req); //SEQUENCE-DRIVER HANDSHAKING MECHANISM
          
//THE WRITE AND READ TASK DECLARED INSIDE THE FORK-JOIN (without begin end) STATEMENT FOR PARALLEL PROCESSING
          fork 
            axi4_write_task();
    	    axi4_read_task();
          join
        end
      seq_item_port.item_done(); //SEQUENCE-DRIVER HANDSHAKING MECHANISM
    end
endtask

  //MASTER DRIVER WRITE TASK
task axi4_master_driver::axi4_write_task();
  fork
    //WRITE ADDRESS CHANNEL LOGIC
	begin: WRITE ADDRESS CHANNEL
      if(req.s_axi_awvalid)
        begin
          
         @(posedge vif.axi_master_dr_mp.clk)
          
          if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awready)
            begin
              
              int len = int `(req.s_axi_awlen);
              int size = int `(req.s_axi_awsize);
              int totalBytes = 2**size;
              for(int i=0;i<=len;i++)
                begin
                  
                  @(posedge vif.axi_master_dr_mp.clk)
                  begin
                    write_addr_data.get(1);
                    if(req.s_axi_awburst==2'b00) //fixed type
                      begin
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
                    else if(req.s_axi_burst==2'b01)  //Incr type
                      begin
                        vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awaddr <= req.s_axi_awaddr+((i)*totalBytes);
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
                end
            end
        end

	end: WRITE ADDRESS CHANNEL
// WRITE DATA LOGIC
	begin: WRITE DATA 
      
     
      if(req.s_axi_wvalid)
        begin
          @(posedge vif.axi_master_dr_mp.clk)
          begin
            if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wready)
                  begin
                    vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wdata <= req.s_axi_wdata.pop_front();
                    vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wstrb <= req.s_axi_wstrb.pop_front();
                    vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wvalid <= 1'b1;
                    if(req.s_axi_wdata.size()>0)
                       vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wlast<= 0;
                    else
                       vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wlast<= 1'b1;
                    write_addr_data.put(1);
                  end
          end
        end

    end: WRITE DATA 
      // WRITE RESPONSE CHANNEL LOGIC
    begin: WRITE RESPONSE CHANNEL
      if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_bvalid)
        begin
          @(posedge vif.axi_master_dr_mp.clk)
          begin
            if(req.s_axi_bready)
              begin
               req.s_axi_bvalid <= 1'b1;
              end
          end
	
	end: WRITE RESPONSE CHANNEL
join

endtask: axi4_write_task

 // MASTER DRIVER READ TASK

task axi4_master_driver::axi4_read_task();
begin
fork
  // READ ADDRESS CHANNEL LOGIC
	begin: READ ADDRESS CHANNEL
      if(req.s_axi_arvalid)
        begin
          @(posedge vif.axi_master_dr_mp.clk)
          begin
            if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_arready)
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
    end: READ ADDRESS CHANNEL
 
 // READ DATA CHANNEL LOGIC     

	begin: READ DATA CHANNEL
      if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_rvalid)
        begin
          if(req.s_axi_rready)
            begin
              vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_rready <= 1'b1;
            end
        end
    end: READ DATA CHANNEL

join

endtask : axi4_read_task

