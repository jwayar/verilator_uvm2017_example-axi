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
// Filename           : axi_stream_seq.svh                                     :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream sequence classes                                :
// Author(s)          : Juan Doctorovich,            Fernando Gerbino          :
// Email              : jdoctorovich@emtech.com.ar,  fgerbino@emtech.com.ar    :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_SEQ_SVH
`define AXI_STREAM_SEQ_SVH

class axi_stream_seq_base #(
    parameter PARM_DATA_WIDTH = 512,
    parameter PARM_ID_WIDTH   = 16,
    parameter PARM_DEST_WIDTH = 8,
    parameter PARM_USER_WIDTH = 256
) extends uvm_sequence #(axi_stream_seq_item #(
    .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
    .PARM_ID_WIDTH  (PARM_ID_WIDTH),
    .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
    .PARM_USER_WIDTH(PARM_USER_WIDTH)
));
  `uvm_object_param_utils(axi_stream_seq_base#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                               .PARM_ID_WIDTH(PARM_ID_WIDTH),
                                               .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                               .PARM_USER_WIDTH(PARM_USER_WIDTH)))
  `uvm_declare_p_sequencer(axi_stream_sequencer#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                                 .PARM_ID_WIDTH(PARM_ID_WIDTH),
                                                 .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                                 .PARM_USER_WIDTH(PARM_USER_WIDTH)))

  function new(string name = "axi_stream_seq_base");
    super.new(name);
  endfunction : new

endclass : axi_stream_seq_base


class axi_stream_seq_pipeline_receiver #(
    parameter PARM_DATA_WIDTH = 512,
    parameter PARM_ID_WIDTH   = 16,
    parameter PARM_DEST_WIDTH = 8,
    parameter PARM_USER_WIDTH = 256
) extends axi_stream_seq_base #(
    .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
    .PARM_ID_WIDTH  (PARM_ID_WIDTH),
    .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
    .PARM_USER_WIDTH(PARM_USER_WIDTH)
);
  `uvm_object_param_utils(axi_stream_seq_pipeline_receiver#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                                            .PARM_ID_WIDTH(PARM_ID_WIDTH),
                                                            .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                                            .PARM_USER_WIDTH(PARM_USER_WIDTH)));

  rand int tready_high_delay = 0;
  rand int tready_delay_max;
  rand int tready_delay_min;

  // Number of packets
  rand integer n_packets;

  // Number of transfers by packet
  rand int n_transfers_by_packet;

  constraint c_default {
    soft n_packets             inside {[1:128]};
    soft n_transfers_by_packet inside {[1:128]};

    soft tready_delay_min      inside {[1  : 10]};
    soft tready_delay_max      inside {[11 : 64]};
  }

  function new(string name = "axi_stream_seq_pipeline_receiver");
    super.new(name);
  endfunction

  task body;
    axi_stream_seq_item #(
        .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
        .PARM_ID_WIDTH  (PARM_ID_WIDTH),
        .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
        .PARM_USER_WIDTH(PARM_USER_WIDTH)
    ) item;

    repeat(n_packets) begin

      item = axi_stream_seq_item#(
          .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
          .PARM_ID_WIDTH  (PARM_ID_WIDTH),
          .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
          .PARM_USER_WIDTH(PARM_USER_WIDTH)
      )::type_id::create(
          "item"
      );

      start_item(item);

      if (!item.randomize() with {

        trans_length      == n_transfers_by_packet;
        tready_high_delay ==  tready_high_delay;

        tready_delay_max  == tready_delay_max;
        tready_delay_min  == tready_delay_min;

      }) begin
        `uvm_fatal("AXI_STREAM PIPELINE RECEIVER", "Failed to randomize seq!");
      end

      finish_item(item);

    end

  endtask

endclass : axi_stream_seq_pipeline_receiver

class axi_stream_seq_pipelined_transmiter #(
    parameter PARM_DATA_WIDTH = 512,
    parameter PARM_ID_WIDTH   = 16,
    parameter PARM_DEST_WIDTH = 8,
    parameter PARM_USER_WIDTH = 256
) extends axi_stream_seq_base #(
    .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
    .PARM_ID_WIDTH  (PARM_ID_WIDTH),
    .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
    .PARM_USER_WIDTH(PARM_USER_WIDTH)
);

  // Factory Registration
  `uvm_object_param_utils(axi_stream_seq_pipelined_transmiter#(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH(PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)))

  // Number of packets
  rand integer n_packets;

  // Number of transfers by packet
  rand int n_transfers_by_packet;

  rand logic [PARM_ID_WIDTH-1   : 0] my_id;      // Packet TID
  rand logic [PARM_DEST_WIDTH-1 : 0] my_dest;    // Packet TDEST

  rand int delay_cycles_min;
  rand int delay_cycles_max;

  rand int tvalid_delay_min;
  rand int tvalid_delay_max;

  rand bit send_counter_data       = 0;

  constraint c_default {
    // soft n_packets             inside {[1:128]};
    // soft n_transfers_by_packet inside {[1:128]};

    soft delay_cycles_min      inside {[1  : 10]};
    soft delay_cycles_max      inside {[11 : 64]};

    soft tvalid_delay_min      inside {[1  : 10]};
    soft tvalid_delay_max      inside {[11 : 64]};
  }

  function new(string name = "axi_stream_seq_pipelined_transmiter");
    super.new(name);
  endfunction

  task body;

    axi_stream_seq_item #(
        .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
        .PARM_ID_WIDTH  (PARM_ID_WIDTH),
        .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
        .PARM_USER_WIDTH(PARM_USER_WIDTH)
    ) item;

    // Send n_packets
    for (integer i = 0; i < n_packets; i++) begin

      item = axi_stream_seq_item#(
          .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
          .PARM_ID_WIDTH  (PARM_ID_WIDTH),
          .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
          .PARM_USER_WIDTH(PARM_USER_WIDTH)
      )::type_id::create("item");

      start_item(item);

      if (!item.randomize() with {

        // Packet Size
        trans_length      == n_transfers_by_packet;
        send_counter_data == send_counter_data;

        tvalid_delay_max  == tvalid_delay_max;
        tvalid_delay_min  == tvalid_delay_min;

        delay_cycles_max  == delay_cycles_max;
        delay_cycles_min  == delay_cycles_min;

      }) begin
        `uvm_fatal(this.get_name(), "Randomization failed");
      end

      `uvm_info(this.get_name(), $sformatf("Sending Packet %0d/%0d (Length: %0d beats)", i+1, n_packets, item.tdata.size()), UVM_HIGH)

      finish_item(item);
    end
  endtask

endclass : axi_stream_seq_pipelined_transmiter

`endif
