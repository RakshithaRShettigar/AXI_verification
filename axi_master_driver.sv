

class axi4_master_driver extends uvm_driver #(axi4_master_transaction); 
  virtual axi_master_interface vif;
  axi4_master_transaction req;

`uvm_component_utils (axi4_master_driver)

extern function new(string name = "axi4_master_driver", uvm_component parent = null);

extern virtual function void build_phase(uvm_phase phase);

extern virtual task run_phase(uvm_phase phase);

extern virtual task axi4_write_task();

extern virtual task axi4_read_task();

endclass : axi4_master_driver 

function axi4_master_driver::new(string name = "axi4_master_driver", uvm_component parent = null);
	super.new(name, parent);

endfunction: new


function void axi4_master_driver::build_phase(uvm_phase phase);
  	
  super.build_phase(phase);
	
  if(!uvm_config_db #(virtual axi4_interface)::get(this, " ", "virtual_interface", vif))
      `uvm_fatal("Driver:", "No virtual interface is found!");

endfunction: build_phase

task axi4_master_driver::run_phase(uvm_phase phase);
  forever
    begin
      if(!vif.rst)
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
          seq_item_port.get_next_item(req);
          fork 
    	    axi4_write_task();
    	    axi4_read_task();
          join
        end
      seq_item_port.item_done();
    end
endtask

task axi4_master_driver::axi4_write_task();
  fork
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
                        vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_awaddr <= req.s_axi_awaddr+((len+1)*totalBytes);
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

	begin: WRITE DATA 
      
     
      if(req.s_axi_wvalid)
        begin
          @(posedge vif.axi_master_dr_mp.clk)
          begin
            if(vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wready)
              begin
                foreach(s_axi_wstrb)
                  begin
                    if(s_axi_wstrb[i]==0)
                      begin
                        vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wdata[8*(i+1)-1 : 8*(i+1)-8] <= req.s_axi_wdata[8*(i+1)-1 : 8*(i+1)-8];
                        vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wvalid <= req.s_axi_wvalid;
                        vif.axi_master_dr_mp.axi_master_dr_cb.s_axi_wlast <= req.s_axi_wlast;
                      end
                  end
              end
          end
          
        end

    end: WRITE DATA CHANNEL

	begin: WRITE RESPONSE CHANNEL
	
	end: WRITE RESPONSE CHANNEL
join

endtask: axi4_write_task


task axi4_master_driver::axi4_read_task();

axi_read_seq_item_port.get_next_item(req_rd);
begin
fork
	begin: READ ADDRESS CHANNEL
      if(req.s_axi_arvalid)
        begin
          if(vif.s_axi_arready)
            begin
              vif.s_axi_arid <= req.s_axi_arid;
              vif.s_axi_araddr <= req.s_axi_araddr;
              vif.s_axi_arlen <= req.s_axi_arlen;
              vif.s_axi_arsize <= req.s_axi_arsize;
              vif.s_axi_arburst <= req.s_axi_arburst;
              vif.s_axi_arlock <= req.s_axi_arlock;
              vif.s_axi_arcache <= req.s_axi_arcache;
              vif.s_axi_arprot <= req.s_axi_arprot;
              vif.s_axi_arvalid <= 1'b1;
            end
        end
    end: READ ADDRESS CHANNEL

	begin: READ DATA CHANNEL
      if(req.s_axi_rvalid)
        begin
          if(vif.s_axi_rready)
            begin
              vif.s_axi_rid <= req.s_axi_rid;
              vif.s_axi_rdata <= req.s_axi_rdata;
              vif.s_axi_rresp <= req.s_axi_rresp;
              vif.s_axi_rlast <= req.s_axi_rlast;
              vif.s_axi_rvalid <= 1'b1;
            end
        end
    end: READ DATA CHANNEL

join
  
axi4_read_seq_item_port.item_done();

endtask : axi4_read_task

