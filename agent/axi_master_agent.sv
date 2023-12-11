//-----------------------------------------------------------------------//
//  Class: axi_master_agent
//  axi_master_agent is extended from uvm_agent, uvm_agent is inherited by uvm_component.
//------------------------------------------------------------------------//

class axi_master_agent extends uvm_agent;

  //Factory registration 
  `uvm_component_utils(axi_master_agent)


  //Handles for the driver, monitor, sequencer
   axi_master_driver axi_drv_h;
  axi_master_monitor axi_mon_h;
  axi_master_sequencer axi_seqr_h;


  //---------------------------------------------------------------------
  // Externally defined functions by using extern keyword
  //---------------------------------------------------------------------
  extern function new(string name = "axi_master_agent", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

//-----------------------------------------------------------------------------//
// Constructor: new
// Initializes the master_agent class component
//
// Parameters:
//  name - instance name of the config_template
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------//

function axi_master_agent::new(string name = "axi_master_agent", uvm_component parent);
  super.new(name, parent);
endfunction : new


//------------------------------------------------------------------------//
// Function: build_phase
// Creates the required components
//
// Parameters:
// phase - stores the current phase 
//---------------------------------------------------------------------//

function void axi_master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  //Passive UVM Agent only Monitor is created

  m_mon = axi_master_monitor::type_id::create("m_mon", this);

  //For Active UVM Agent monitor class is created along with the Sequencer and Driver but for the

  if(get_is_active() == UVM_ACTIVE)
  begin
    m_drv  = axi_master_driver::type_id::create("m_drv", this);
    m_seqr = axi_master_sequencer::type_id::create("m_seqr", this);
  end

endfunction : build_phase


//------------------------------------------------------------------------//
//Function: connect_phase
//The connect phase is used to make TLM connections between components
//(driver, sequencer connection)
//------------------------------------------------------------------------//

function void axi_master_agent::connect_phase(uvm_phase phase);
  if(get_is_active() == UVM_ACTIVE) 
    m_drv.seq_item_port.connect(seqr.seq_item_export);
endfunction : connect_phase

///////////////////////////////////////////////////////////////////////////
