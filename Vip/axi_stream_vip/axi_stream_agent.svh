// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//                    ______          __            __                         :
//                   / ____/___ ___  / /____  _____/ /_                        :
//                  / __/ / __ `__ \/ __/ _ \/ ___/ __ \                       :
//                 / /___/ / / / / / /_/  __/ /__/ / / /                       :
//                /_____/_/ /_/ /_/\__/\___/\___/_/ /_/                        :
//                                                                             :
// This file contains confidential and proprietary information of Emtech SA.   :
// Any unauthorized copying, alteration, distribution, transmission,           :
// performance, display or other use of this material is prohibited.           :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//                                                                             :
// Client             :                                                        :
// Version            : 1.0                                                    :
// Application        : Generic                                                :
// Filename           : axi_stream_agent.svh                                   :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream agent class                                     :
// Author(s)          : Juan Doctorovich                                       :
// Email              : jdoctorovich@emtech.com.ar                             :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_AGENT_SVH
`define AXI_STREAM_AGENT_SVH

class axi_stream_agent #(parameter PARM_DATA_WIDTH = 512, parameter PARM_ID_WIDTH = 16, parameter PARM_DEST_WIDTH = 8, parameter PARM_USER_WIDTH = 256) extends uvm_agent;
  `uvm_component_param_utils(axi_stream_agent #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)))

  uvm_analysis_port #(axi_stream_seq_item #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH))) aport;

  axi_stream_agent_config       #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)) m_config;
  axi_stream_monitor            #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)) m_monitor;
  axi_stream_sequencer          #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)) m_sequencer;
  axi_stream_driver_receiver    #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)) m_receiver_drv;
  axi_stream_driver_transmitter #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)) m_transmitter_drv;

  extern function new(string name = "", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : axi_stream_agent

function axi_stream_agent::new(string name = "", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void axi_stream_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (m_config == null) begin
    if (!uvm_config_db#(axi_stream_agent_config#( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)))::get(this, "", "m_config", m_config)) begin
      `uvm_fatal(this.get_full_name, "No axi_stream_agent config specified!");
    end
  end

  if (m_config.m_vif == null) begin
    `uvm_fatal("CFGERR", "Interface for axi agent not set");
  end
  if (m_config.active == UVM_ACTIVE) begin
    m_sequencer = axi_stream_sequencer #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH))::type_id::create("m_sequencer", this);
    if (m_config.is_transmitter == TRANSMITTER) begin
      m_transmitter_drv = axi_stream_driver_transmitter #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH))::type_id::create("m_transmitter_drv", this);  
      m_transmitter_drv.m_cfg = m_config;
      m_transmitter_drv.vif = m_config.m_vif;
    end else begin
      m_receiver_drv = axi_stream_driver_receiver #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH))::type_id::create("m_receiver_drv", this);
      m_receiver_drv.m_cfg = m_config;
      m_receiver_drv.vif = m_config.m_vif;
    end
  end
  m_monitor = axi_stream_monitor #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH))::type_id::create("m_monitor", this);
  m_monitor.m_cfg = m_config;
  m_monitor.vif   = m_config.m_vif;
  aport = new("aport", this);

endfunction : build_phase

function void axi_stream_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (m_config.active == UVM_ACTIVE) begin
    if (m_config.is_transmitter == TRANSMITTER) begin
      m_transmitter_drv.seq_item_port.connect(m_sequencer.seq_item_export);
    end else begin
      m_receiver_drv.seq_item_port.connect(m_sequencer.seq_item_export);
    end
  end
  m_monitor.aport.connect(aport);

endfunction : connect_phase

`endif
