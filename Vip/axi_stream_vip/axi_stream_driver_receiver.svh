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
// Filename           : axi_stream_driver_receiver.svh                         :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream driver receiverclass                            :
// Author(s)          : Juan Doctorovich, Fernando Gerbino                     :
// Email              : jdoctorovich@emtech.com.ar,  fgerbino@emtech.com.ar    :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_DRIVER_RECEIVER_SVH
`define AXI_STREAM_DRIVER_RECEIVER_SVH 

class axi_stream_driver_receiver #(
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
  `uvm_component_param_utils(axi_stream_driver_receiver#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                                         .PARM_ID_WIDTH(PARM_ID_WIDTH),
                                                         .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                                         .PARM_USER_WIDTH(PARM_USER_WIDTH)));

  // Components
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
  extern virtual task receive_data(axi_stream_seq_item#(
                                   .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                   .PARM_ID_WIDTH  (PARM_ID_WIDTH),
                                   .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                   .PARM_USER_WIDTH(PARM_USER_WIDTH)) item);

  extern virtual task run_phase(uvm_phase phase);

endclass : axi_stream_driver_receiver

function axi_stream_driver_receiver::new(string name = "", uvm_component parent);
  super.new(name, parent);
endfunction : new

task axi_stream_driver_receiver::run_phase(uvm_phase phase);
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
      @vif.receiver;
    end while (vif.aresetn !== 1'b1);

    fork
      forever begin
        seq_item_port.get_next_item(item);
        if (m_cfg.tready_always_on == 1'b1) begin
          vif.receiver.tready <= 1'b1;
        end else begin
          receive_data(item);
        end
        `uvm_info("AXI_STREAM_DRV", "Processed Get Pin OP", UVM_HIGH)
        seq_item_port.item_done();
      end
    join_none

    @(negedge vif.aresetn);
    disable fork;
    reset_data();
  end
endtask : run_phase

task axi_stream_driver_receiver::receive_data(axi_stream_seq_item#(
                                              .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                              .PARM_ID_WIDTH  (PARM_ID_WIDTH),
                                              .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                              .PARM_USER_WIDTH(PARM_USER_WIDTH)
                                              ) item);

  // Variable used to check the timeout
  int current_tvalid_delay = 0;

  vif.sync_clk();

  repeat(item.trans_length) begin 
    
    current_tvalid_delay = 0;

    if (m_cfg.tready_delay_en == 1'b1) begin
      vif.receiver.tready <= 1'b0;
      repeat (item.tready_delay) @vif.receiver;
    end

    vif.receiver.tready <= 1'b1;

    do begin
      @vif.receiver;
      current_tvalid_delay++;
    end while (vif.receiver.tvalid !== 1'b1 && current_tvalid_delay < m_cfg.tvalid_timeout);

    if (vif.receiver.tvalid !== 1) begin
      if(m_cfg.tvalid_timeout_fail) begin
        `uvm_fatal(get_full_name(), "tvalid timeout")
      end else begin
        `uvm_warning(get_full_name(), "tvalid timeout")
        break;
      end
    end

    repeat (item.tready_high_delay) @vif.receiver;
    vif.receiver.tready <= 1'b0;

  end

endtask : receive_data

//------------------------------------------------------------------//
task axi_stream_driver_receiver::reset_data();
  vif.receiver.tready <= 1'b0;
endtask : reset_data

`endif
