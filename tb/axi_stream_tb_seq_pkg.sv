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
// Filename           : axi_stream_tb_seq_pkg.sv                                   :
// Date Last Modified : 2025 SEP 1                                           :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : axi_Stream Testbench sequences                             :
// Author(s)          : Juan Doctorovich                                        :
// Email              : jdoctorovich@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axi_stream_tb_seq_pkg;

  // Package imports.
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import axi_stream_agent_pkg::*;
  import axi_stream_tb_defn_pkg::*;

  class axi_stream_tb_receiver_seq #(parameter PARM_DATA_WIDTH = 512)  extends axi_stream_seq_base#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH));
    // UVM Factory Registration Macro.
    `uvm_object_param_utils(axi_stream_tb_receiver_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH)))
    rand integer transfers = 1;
    rand integer tready_delay = 1;
    rand integer tready_high_delay = 1;

    // Sequence's constructor.
    function new(string name = "axi_stream_tb_receiver_seq");
      super.new(name);
    endfunction : new

    // Main task executed by the sequence.
    task body();
      axi_stream_seq_constant_delay_receiver #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH)) const_delay_seq;

      // Create main sequences.
      const_delay_seq = axi_stream_seq_constant_delay_receiver #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH))::type_id::create("const_delay_seq");

      const_delay_seq.transfers = transfers;
      const_delay_seq.tready_delay = tready_delay;
      const_delay_seq.tready_high_delay = tready_high_delay;
      const_delay_seq.start(p_sequencer);

    endtask : body

  endclass : axi_stream_tb_receiver_seq

  class axi_stream_tb_transmiter_seq #(parameter PARM_DATA_WIDTH = 512) extends axi_stream_seq_base #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH));
    // UVM Factory Registration Macro.
    `uvm_object_param_utils(axi_stream_tb_transmiter_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH)))
    rand integer transfers = 1;
    rand int delay_cycles = 0;
    rand int tvalid_delay = 0;

    // Sequence's constructor.
    function new(string name = "axi_stream_tb_transmiter_seq");
      super.new(name);
    endfunction : new

    // Main task executed by the sequence.
    task body();
      axi_stream_seq_burst_write #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH)) fwd_seq;

      // Create main sequences.
      fwd_seq = axi_stream_seq_burst_write #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH))::type_id::create("fwd_seq");

      if (!fwd_seq.randomize() with {
        }) begin
      `uvm_error("AXI_STREAM TRANSMITTER", "Failed to randomize seq!");
      end
      fwd_seq.word_data_inc = 1;
      fwd_seq.word_data     ='0;
      fwd_seq.delay_cycles  = delay_cycles;
      fwd_seq.tvalid_delay  = tvalid_delay;
      fwd_seq.transfers     = transfers;
      fwd_seq.start(p_sequencer, this);

    endtask : body

  endclass : axi_stream_tb_transmiter_seq

endpackage : axi_stream_tb_seq_pkg
