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
// Filename           : axi_stream_driver_transmitter.svh                      :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream driver transmitter class                        :
// Author(s)          : Juan Doctorovich,            Fernando Gerbino          :
// Email              : jdoctorovich@emtech.com.ar,  fgerbino@emtech.com.ar    :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_DRIVER_TRANSMITTER_SVH
`define AXI_STREAM_DRIVER_TRANSMITTER_SVH 

class axi_stream_driver_transmitter #(
    parameter PARM_DATA_WIDTH = 512,
    parameter PARM_ID_WIDTH   = 16,
    parameter PARM_DEST_WIDTH = 8,
    parameter PARM_USER_WIDTH = 256
) extends uvm_driver #(axi_stream_seq_item #(
    .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
    .PARM_ID_WIDTH  (PARM_ID_WIDTH),
    .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
    .PARM_USER_WIDTH(PARM_USER_WIDTH)
));
  `uvm_component_param_utils(axi_stream_driver_transmitter#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH),
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

  extern function new(string name = "", uvm_component parent);
  extern virtual task reset_data();
  extern virtual task send_data(axi_stream_seq_item#(
                                .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                .PARM_ID_WIDTH  (PARM_ID_WIDTH),
                                .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                .PARM_USER_WIDTH(PARM_USER_WIDTH)) item);
  extern virtual task run_phase(uvm_phase phase);

endclass : axi_stream_driver_transmitter

function axi_stream_driver_transmitter::new(string name = "", uvm_component parent);
  super.new(name, parent);
endfunction : new

task axi_stream_driver_transmitter::run_phase(uvm_phase phase);
  axi_stream_seq_item #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH  (PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)
  ) item;
  super.run_phase(phase);

  forever begin
    reset_data();
    do begin
      @vif.transmitter;
    end while (vif.aresetn !== 1'b1);
    @vif.transmitter;

    fork
      forever begin  
        seq_item_port.get_next_item(item);
        send_data(item);
        `uvm_info("AXI_STREAM_DRV", "Processed Get Pin OP", UVM_HIGH)
        seq_item_port.item_done();
      end
    join_none

    @(negedge vif.aresetn);
    disable fork;
  end
endtask : run_phase

task axi_stream_driver_transmitter::send_data(axi_stream_seq_item#(
    .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
    .PARM_ID_WIDTH  (PARM_ID_WIDTH),
    .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
    .PARM_USER_WIDTH(PARM_USER_WIDTH)
) item);

  // Variable used to check the timeout
  int current_tready_delay = 0;

  `uvm_info(this.get_full_name, item.convert2string(), UVM_HIGH)
  `uvm_info("AXI_STREAM Driver", $sformatf("Sending Packet of size: %0d beats", item.tdata.size()), UVM_HIGH)


  foreach (item.tdata[i]) begin
    
    current_tready_delay = 0;

    // Set tvalid delay
    if (m_cfg.tvalid_delay_en == 1'b1) begin
      vif.transmitter.tvalid <= 1'b0;
      repeat (item.tvalid_delay) @vif.transmitter;
    end 

    vif.transmitter.tvalid <= 1'b1;
    vif.transmitter.tdata  <= item.tdata[i];
    vif.transmitter.tkeep  <= (m_cfg.tkeep_en)? item.tkeep[i] : '1;
    vif.transmitter.tstrb  <= (m_cfg.tstrb_en)? item.tstrb[i] : ((m_cfg.tkeep_en)? item.tkeep[i] : '1);
    vif.transmitter.tuser  <= (m_cfg.tuser_en)? item.tuser[i] : '0;
    vif.transmitter.tdest  <= (m_cfg.tdest_en)? item.tdest[i] : '0; 
    vif.transmitter.tid    <= (m_cfg.tid_en  )? item.tid[i]   : '0;   

    // TLAST logic (only is high if it's the final transfer of the packet)
    if(m_cfg.tlast_en) begin 
      if   (i == item.tdata.size() - 1) vif.transmitter.tlast <= 1'b1; 
      else vif.transmitter.tlast <= 1'b0;
    end
    else begin 
      vif.transmitter.tlast <= 1'b1;
    end

    // Wait Handshake
    do 
      begin
        @vif.transmitter;
        current_tready_delay++;
      end
    while (vif.transmitter.tready !== 1'b1 && current_tready_delay < m_cfg.tready_timeout);

    if (vif.transmitter.tready !== 1) begin
      if(m_cfg.tready_timeout_fail) begin
        `uvm_fatal(get_full_name(), "tready timeout")
      end else begin
        `uvm_warning(get_full_name(), "tready timeout")
        break;
      end
    end

  end

  // Finish transaction
  item.timestamp = $realtime; 
  if(m_cfg.tlast_en) vif.transmitter.tlast  <= 1'b0;
  vif.transmitter.tvalid <= 1'b0;

  // Delay Post_packet
  repeat (item.delay_cycles) @vif.transmitter;

endtask : send_data

//------------------------------------------------------------------//
task axi_stream_driver_transmitter::reset_data();
  vif.transmitter.tvalid                    <= 1'b0;
  vif.transmitter.tlast                     <= 1'b0; 
  vif.transmitter.tdata                     <= 'x; 
  vif.transmitter.tkeep                     <= '0;
  vif.transmitter.tstrb                     <= '0; 
  vif.transmitter.tuser                     <= '0;
  vif.transmitter.tdest                     <= '0;
  vif.transmitter.tid                       <= '0;
endtask : reset_data

`endif
