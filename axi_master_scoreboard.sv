`ifndef AXI_MASTER_SCOREBOARD_INCLUDED_
`define AXI_MASTER_SCOREBOARD_INCLUDED_

  import uvm_pkg::*;
 `include "uvm_macros.svh"
//--------------------------------------------------------------------------------------------
// Class: axi_master_scoreboard
// Scoreboard will get the data from the analysis port of the  monitor that goes into the implementation port
//--------------------------------------------------------------------------------------------

parameter OKAY=0;
parameter SLVERR=1;

// AXI MASTER SCOREBOARD IS THE USER DEFINED CLASS WHICH EXTENDS FROM UVM SCOREBOARD (PREDEFINED SCOREBOARD CLASS)
class axi4_master_scoreboard extends uvm_scoreboard;

// FACTORY REGISTRATION
// REGISTERING THE USER DEFINED CLASS IN THE LUT
`uvm_component_utils (axi4_master_scoreboard)

// PORT DECLARATIONS FOR CONNECTION BETWEEN MONITOR AND SCOREBOARD
uvm_analysis_imp#(req, axi4_master_scoreboard)axi_seq_item_imp;

// DECLARING EXTERNAL FUNCTION "NEW" (CLASS CONSTRUCTOR)
extern function new(string name = " axi4_master_scoreboard ", uvm_component parent = null);

// DECLARING EXTERNAL FUNCTION WRITE
extern virtual function void write(input axi_master_sequence_item req);

// DEFINING THE CLASS CONSTRUCTOR OUTSIDE THE CLASS USING SCOPE RESOLUTION OPERATOR

function axi4_master_scoreboard::new(string name = " axi4_master_scoreboard ", uvm_component parent = null);
super.new(name, parent);
// CREATING ANALYSIS IMPORT
axi_seq_item_imp = new("axi_seq_item_imp",this);
endfunction: new

//DECLARE ASSOCIATIVE ARRAY OF INDEX INT TYPE
bit[127:0] write_success[int];
bit[127:0] read_success[int];
bit[127:0] write_fail[int];
bit[127:0] read_fail[int];

int temp_write[$];
int temp_read[$];
int burst_size;
int success_count;
int failure_count;

function axi_master_scoreboard::write(input axi_master_sequence_item req);
//WRITE
if(req.s_axi_awburst == 0) begin
  if(req.s_axi_bresp == OKAY) begin
    write_success[req.s_axi_awaddr] = req.s_axi_wdata[req.s_axi_awlen];
  end
  else if(req.s_axi_bresp == SLVERR) begin
        write_fail[req.s_axi_awaddr] = req.s_axi_wdata[req.s_axi_awlen];
   end
end
  
else if(req.s_axi_awburst == 1) begin
  temp_write.push(req.s_axi_awaddr);
  for(int i = 1; i <= req.s_axi_awlen; i++) begin
    burst_size = 2**req.s_axi_awsize;
    temp_write.push(req.s_axi_awaddr + (temp_write.size())*burst_size);
   end
   if(req.s_axi_bresp == OKAY) begin
        for(int i = 0; i <= req.s_axi_awlen; i++) begin
          write_success[temp_write.pop_front()] = req.s_axi_wdata[i];
        end
   else if(req.s_axi_bresp == SLVERR) begin
        for(int i = 0; i <= req.s_axi_awlen; i++) begin
          write_fail[temp_write.pop_front()] = req.s_axi_wdata[i];
        end
   end
end


//READ
if(req.s_axi_arburst == 0) begin
  if(req.s_axi_rresp == OKAY) begin
    read_success[s_axi_araddr] = s_axi_rddata[s_axi_arlen];
    check_1();
    check_3();
    end
  end
 else if(s_axi_rresp == SLVERR) begin
        read_fail[s_axi_araddr] = s_axi_rddata[s_axi_arlen];
   check_2();
   end 
end
else if(s_axi_arburst == 1) begin
  temp_read.push(s_axi_araddr);
  for(int i = 1; i <= s_axi_arlen; i++) begin
    burst_size = 2**s_axi_arsize;
    temp_read.push(s_axi_araddr + (temp_read.size())*burst_size);
   end
   if(s_axi_rresp == OKAY) begin
        for(int i = 0; i <= s_axi_arlen; i++) begin
          read_success[temp_read.pop_front()] = s_axi_rddata[i];
          check_1();
          check_3();
        end
  else if(s_axi_rresp == SLVERR) begin
        read_fail[temp_read.pop_front()] = s_axi_rddata[i];
    check_2();
   end 
end
  
endfunction
 
       
 function void check_1();
   foreach(write_success[i]) begin
      if(read_success.exits(i))begin
        if(read_success[i] == write_success[i]) begin
        success_count++;
          `uvm_info("SUCCESS", $sformatf("write_success[%0h]: %0d read_success[%0h]: %0d success_count: %0d failure_count: %0d",i,write_success[i],i,read_success[i], success_count, failure_count), UVM_LOW);
        end
        else begin
          failure_count++;
            `uvm_info("FAIL", $sformatf("write_success[%0h]: %0d read_success[%0h]: %0d success_count: %0d failure_count: %0d",i,write_success[i],i,read_success[i], success_count, failure_count), UVM_LOW);
        end
          read_success.delete(i);
        `uvm_info("Deleted Address",$sformatf("read_success[%0h]: %0d",i,read_success[i]),UVM_LOW);
     end
   end
    `uvm_info("WRITE_SUCCESS",$sformat("write_success:%0p",write_success),UVM_LOW);
     `uvm_info("READ_SUCCESS",$sformat("read_success:%0p",read_success),UVM_LOW);
 endfunction

function void check_2();
         foreach(write_success[i]) begin
           if(read_fail.exits(i))begin
             if(read_fail[i] != write_success[i]) begin
        success_count++;
               `uvm_info("SLAVE_ERROR SUCCESS", $sformatf("write_success[%0h]: %0d read_fail[%0h]: %0d success_count: %0d failure_count: %0d",i,write_success[i],i,read_fail[i], success_count, failure_count), UVM_LOW);
        end
        else begin
          failure_count++;
          `uvm_info("SLAVE_ERROR FAIL", $sformatf("write_success[%0h]: %0d read_fail[%0h]: %0d success_count: %0d failure_count: %0d",i,write_success[i],i,read_fail[i], success_count, failure_count), UVM_LOW);
        end
          read_fail.delete(i);
             `uvm_info("Deleted Address",$sformatf("read_fail[%0h]: %0d",i,read_fail[i]),UVM_LOW);
             
  end
     `uvm_info("WRITE_SUCCESS",$sformat("write_success:%0p",write_success),UVM_LOW);
           `uvm_info("READ_FAIL",$sformat("read_fail:%0p",read_fail),UVM_LOW);
  end    
endfunction

  function void check_3();
    foreach(write_fail[i]) begin
      if(read_success.exits(i))begin
        if(read_success[i] != write_fail[i]) begin
        success_count++;
          `uvm_info("SLAVE_ERROR SUCCESS", $sformatf("write_fail[%0h]: %0d read_success[%0h]: %0d success_count: %0d failure_count: %0d",i,write_fail[i],i,read_success[i], success_count, failure_count), UVM_LOW);
        end
        else begin
          failure_count++;
          `uvm_info("SLAVE_ERROR FAIL", $sformatf("write_fail[%0h]: %0d read_success[%0h]: %0d success_count: %0d failure_count: %0d",i,write_fail[i],i,read_success[i], success_count, failure_count), UVM_LOW);
        end
          read_success.delete(i);
             `uvm_info("Deleted Address",$sformatf("read_success[%0h]: %0d",i,read_success[i]),UVM_LOW);
             
  end
      `uvm_info("WRITE_FAIL",$sformat("write_fail:%0p",write_fail),UVM_LOW);
      `uvm_info("READ_SUCCESS",$sformat("read_success:%0p",read_success),UVM_LOW);
  end    
endfunction
  endclass : axi4_master_scoreboard
