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
// Filename           : axi_stream_monitor.svh                                 :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream monitor class                                   :
// Author(s)          : Juan Doctorovich,            Fernando Gerbino          :
// Email              : jdoctorovich@emtech.com.ar,  fgerbino@emtech.com.ar    :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_MONITOR_SVH
`define AXI_STREAM_MONITOR_SVH 

class axi_stream_monitor #(
    parameter PARM_DATA_WIDTH = 512,
    parameter PARM_ID_WIDTH   = 16,
    parameter PARM_DEST_WIDTH = 8,
    parameter PARM_USER_WIDTH = 256
) extends uvm_monitor;
  `uvm_component_param_utils(axi_stream_monitor#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                                 .PARM_ID_WIDTH(PARM_ID_WIDTH),
                                                 .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                                 .PARM_USER_WIDTH(PARM_USER_WIDTH)));

  virtual axi_stream_if #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH  (PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)
  ) vif;

  axi_stream_agent_config #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH  (PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)
  ) m_cfg;

  uvm_analysis_port #(axi_stream_seq_item #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH  (PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)
  )) aport;

  extern function new(string name = "", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void checkXZ(input axi_stream_seq_item#(
                                       .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                       .PARM_ID_WIDTH  (PARM_ID_WIDTH),
                                       .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                       .PARM_USER_WIDTH(PARM_USER_WIDTH)) item);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task monitor_items();
  extern virtual task handshake();

endclass : axi_stream_monitor

function axi_stream_monitor::new(string name = "", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void axi_stream_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  aport = new("aport", this);
endfunction : build_phase

function void axi_stream_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

task axi_stream_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);

  forever begin
    @vif.mon_cb;
    while (vif.aresetn !== 1'b1) begin
      @vif.mon_cb;
    end

    fork
      monitor_items(); 
    join_none

    @(negedge vif.aresetn);
    disable fork;
  end
endtask : run_phase

task axi_stream_monitor::monitor_items();
  
  axi_stream_seq_item #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH  (PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)
  ) item;

  // Aux queues to store data 
  logic [PARM_DATA_WIDTH-1:0]   q_tdata[$];
  logic [PARM_DATA_WIDTH/8-1:0] q_tkeep[$];
  logic [PARM_DATA_WIDTH/8-1:0] q_tstrb[$];
  logic [PARM_USER_WIDTH-1:0]   q_tuser[$];
  logic [PARM_ID_WIDTH-1:0]     q_tid  [$];
  logic [PARM_DEST_WIDTH-1:0]   q_tdest[$];


  forever begin
    // Waiting handshake
    handshake();

    // Get data and store in aux queues
    q_tdata.push_back(vif.mon_cb.tdata);
    q_tkeep.push_back((m_cfg.tkeep_en)? vif.mon_cb.tkeep : '1);
    q_tstrb.push_back((m_cfg.tstrb_en)? vif.mon_cb.tstrb : ((m_cfg.tkeep_en)? vif.mon_cb.tkeep : '1));
    q_tuser.push_back((m_cfg.tuser_en)? vif.mon_cb.tuser : '0);    
    q_tdest.push_back((m_cfg.tdest_en)? vif.mon_cb.tdest : '0); 
    q_tid.push_back  ((m_cfg.tid_en)? vif.mon_cb.tid   : '0);

    // Verify if is the last transfer of the packet 
    if (vif.mon_cb.tlast === 1'b1) begin
        
      item = axi_stream_seq_item#(
          .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
          .PARM_ID_WIDTH  (PARM_ID_WIDTH),
          .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
          .PARM_USER_WIDTH(PARM_USER_WIDTH)
      )::type_id::create("item", this);

      // Populate item fields from queues
      item.tdata = q_tdata;
      item.tkeep = q_tkeep;
      item.tstrb = q_tstrb;
      item.tuser = q_tuser;
      item.tdest = q_tdest;
      item.tid   = q_tid;
        
      item.timestamp = $realtime();

      // ID of UVM transaction, It's not related AXI protocol
      item.id        = m_cfg.get_id(); 

      if (m_cfg.is_x_z_check) begin
           checkXZ(item);
      end

      // Send data to scoreboard via analysis_port (aport)
      `uvm_info(this.get_name(), $sformatf("Monitored Packet Size: %0d beats", item.tdata.size()), UVM_HIGH)
      aport.write(item);

      // Flush buffers for next packet
      q_tdata.delete();
      q_tkeep.delete();
      q_tstrb.delete();
      q_tuser.delete();
      q_tdest.delete();
      q_tid.delete();
    end
  end
endtask : monitor_items

function void axi_stream_monitor::checkXZ(input axi_stream_seq_item#(
                                          .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                          .PARM_ID_WIDTH  (PARM_ID_WIDTH),
                                          .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                          .PARM_USER_WIDTH(PARM_USER_WIDTH)
                                          ) item);
  string warn_string_x;
  string warn_string_z;

  for (int i = 0; i < PARM_DATA_WIDTH; i++) begin
    if (item.tdata[i] === 1'bX) begin
      warn_string_x = $sformatf({warn_string_x, " %b"}, item.tdata[i]);
    end else if (item.tdata[i] === 1'bZ) begin
      warn_string_z = $sformatf({warn_string_z, " %b"}, item.tdata[i]);
    end
  end

  if (warn_string_x != "") begin
    `uvm_warning("AXI_STREAM_MON", {"Value 'X' detected on pin(s) :", warn_string_x})
  end else if (warn_string_z != "") begin
    `uvm_warning("AXI_STREAM_MON", {"Value 'Z' detected on pin(s) :", warn_string_z})
  end
endfunction : checkXZ

task axi_stream_monitor::handshake();
    
    do begin
      @vif.mon_cb;
    end while ((vif.mon_cb.tvalid & vif.mon_cb.tready) !== 1'b1);

endtask: handshake

`endif
