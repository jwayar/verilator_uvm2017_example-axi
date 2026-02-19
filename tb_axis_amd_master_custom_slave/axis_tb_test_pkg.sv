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
// Filename           : axi4full_test_pkg.sv                                   :
// Date Last Modified : 2021 SEP 20                                            :
// Date Created       : 2021 SEP 20                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : AXI4full TB Test Package                               :
// Author(s)          : Fernando Gerbino                                           :
// Email              : fgerbino@emtech.com.ar                                  :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axis_tb_test_pkg;

  // Package imports.
  import uvm_pkg::*;
  import axis_tb_defn_pkg::*;
  import axis_tb_env_pkg::*;
  import xilinxs_vip_pkg::*;

  `include "uvm_macros.svh"

  // Agent package imports.
  import axi_stream_agent_pkg::*;

  class axis_tb_test_base extends uvm_test;
    // UVM Factory Registration Macro
    `uvm_component_utils(axis_tb_test_base)

    // Environment class instantiation.
    axis_tb_env m_env;
    axis_tb_env_config env_config;

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create environment and its configuration object.
      m_env = axis_tb_env::type_id::create("m_env", this);
      env_config = axis_tb_env_config::type_id::create("env_config");

      // Create AXIs config classes and define configuration
      // Configure AXIS MASTER
      env_config.m_axis_slave_agent_config = axis_agent_config::type_id::create(
        "m_axis_slave_agent_config"
      );

      env_config.m_axis_slave_agent_config.active = UVM_ACTIVE;
      env_config.m_axis_slave_agent_config.is_transmitter = RECEIVER;
      env_config.m_axis_slave_agent_config.set_id(0);  // Set agent ID to 0
      env_config.m_axis_slave_agent_config.tready_delay_en = 1;
      env_config.m_axis_slave_agent_config.tready_always_on = 0;

      if (!uvm_config_db#(axis_slave_if)::get(this, "", "slave_if", env_config.m_axis_slave_agent_config.m_vif)) begin
        `uvm_fatal(this.get_name(), "No interface specified for m_axis_slave_agent!")
      end

      // Environment post configuration
      configure_env(env_config);

      // Set configuration object to database
      uvm_config_db#(axis_tb_env_config)::set(this, "*", "axis_tb_env_config", env_config);

    endfunction : build_phase

    // Convenience method used by test sub-classes to modify the environment.
    virtual function void configure_env(axis_tb_env_config env_config);
      // Environment post config here (if needed).
    endfunction : configure_env

  endclass : axis_tb_test_base

  class axis_tb_main_test extends axis_tb_test_base;
    // UVM Factory Registration Macro
    `uvm_component_utils(axis_tb_main_test)

    rand int set_n_packets               ;
    rand int set_n_transfers_per_packet  ;
    int      set_random_data           = 1;    // Selector between random_data or counter data

    constraint c_packets_range {
      set_n_packets inside {[1:128]};
    }

    constraint c_transfers_range {
      set_n_transfers_per_packet inside {[1:128]};
    }

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    // Environment configuration for current test.
    function void configure_env(axis_tb_env_config env_config);
      // Enable axi_Stream Agent usage.
      env_config.has_axis_master_agent = 1'b1;
      env_config.has_axis_slave_agent  = 1'b1;
    endfunction : configure_env

    // Main task executed by the test.
    task run_phase(uvm_phase phase);

      axi_stream_seq_pipeline_receiver #(
        .PARM_DATA_WIDTH(AXIS_SLAVE_DATA_WIDTH),
        .PARM_ID_WIDTH  (AXIS_SLAVE_ID_WIDTH),
        .PARM_DEST_WIDTH(AXIS_SLAVE_DEST_WIDTH),
        .PARM_USER_WIDTH(AXIS_SLAVE_USER_WIDTH)
      ) receiver_seq;

      if (!this.randomize()) begin
        `uvm_fatal(this.get_full_name(), "Fail in randomization of n_packets and n_transfers_per_packet")
      end

      `uvm_info("TEST_CONFIG", $sformatf("n_packets= %d \t n_transfers_per_packet= %d\n", set_n_packets, set_n_transfers_per_packet), UVM_LOW)

      receiver_seq = axi_stream_seq_pipeline_receiver#(
        .PARM_DATA_WIDTH(AXIS_SLAVE_DATA_WIDTH),
        .PARM_ID_WIDTH  (AXIS_SLAVE_ID_WIDTH),
        .PARM_DEST_WIDTH(AXIS_SLAVE_DEST_WIDTH),
        .PARM_USER_WIDTH(AXIS_SLAVE_USER_WIDTH)
      )::type_id::create(
          "receiver_seq"
      );

      phase.raise_objection(this);

      fork
        begin // SLAVE AGENT

          if (!receiver_seq.randomize() with {
            n_packets              == set_n_packets;
            n_transfers_by_packet  == set_n_transfers_per_packet;
            tready_high_delay      == 0;
          }) begin
            `uvm_fatal(this.get_name(), $sformatf("Unable to randomize receiver_seq"))
          end

          receiver_seq.start(m_env.m_axis_slave_agent.m_sequencer);

        end

        begin // MASTER AGENT

          send_master_transaction(set_n_packets,set_n_transfers_per_packet,set_random_data);

        end
      join

      #100ns;
      phase.drop_objection(this);

    endtask : run_phase

    task send_master_transaction(int n_packets, int n_transfers_per_packet, bit random_data);

      axi4stream_transaction wr_trans;

      localparam int NUM_BYTES = AXIS_MASTER_DATA_WIDTH / 8;

      // Variables sized automatically based on TOP parameters
      bit [AXIS_MASTER_DATA_WIDTH-1 : 0] tdata;
      bit [NUM_BYTES-1              : 0] tkeep;
      bit [NUM_BYTES-1              : 0] tstrb;
      bit [AXIS_MASTER_ID_WIDTH-1   : 0] tid;
      bit [AXIS_MASTER_DEST_WIDTH-1 : 0] tdest;
      bit [AXIS_MASTER_USER_WIDTH-1 : 0] tuser;

      m_env.m_axis_master_agent.vif_proxy.set_dummy_drive_type(XIL_AXI4STREAM_VIF_DRIVE_NONE);
      m_env.m_axis_master_agent.start_master();

      repeat(n_packets) begin

        // Randomize ID and DEST once per packet
        void'(std::randomize(tid, tdest));

        for(int i = 0; i < n_transfers_per_packet; i++) begin

          wr_trans = m_env.m_axis_master_agent.driver.create_transaction("single_trans");

          // Randomize data, user, keep, and strb for every transfer
          void'(std::randomize(tdata, tuser, tkeep, tstrb) with {
            // Strobe cannot be 1 if Keep is 0
            (tstrb & ~tkeep) == 0;
            // Force full beats (no sparse keep)
            tkeep == '1;
          });

          if (!random_data) begin
            tdata = i + 1;
            tstrb = '1; // Force all bytes valid for counter mode
          end

          // set transfer signals
          wr_trans.set_data_beat(tdata);
          wr_trans.set_keep_beat(tkeep);
          wr_trans.set_strb_beat(tstrb);
          wr_trans.set_id(tid);
          wr_trans.set_dest(tdest);
          wr_trans.set_user_beat(tuser);
          // TLAST and Delay control
          wr_trans.set_last( (i == n_transfers_per_packet - 1) ? 1'b1 : 1'b0 );
          wr_trans.set_delay( (i == 0) ? 15 : 2 );

          m_env.m_axis_master_agent.driver.send(wr_trans);
        end
      end
    endtask

  endclass : axis_tb_main_test

endpackage : axis_tb_test_pkg
