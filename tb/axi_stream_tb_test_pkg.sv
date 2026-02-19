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
// Filename           : axi_stream_tb_test_pkg.sv                                  :
// Date Last Modified : 2025 SEP 1                                           :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : axi_Stream Testbench tests package                         :
// Author(s)          : Juan Doctorovich                                        :
// Email              : jdoctorovich@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axi_stream_tb_test_pkg;

  // Package imports.
  import uvm_pkg::*;
  import axi_stream_tb_defn_pkg::*;
  import axi_stream_tb_env_pkg::*;
  import axi_stream_tb_seq_pkg::*;
  `include "uvm_macros.svh"

  // Agent package imports.
  import axi_stream_agent_pkg::*;

  class axi_stream_tb_test_base extends uvm_test;
    // UVM Factory Registration Macro
    `uvm_component_utils(axi_stream_tb_test_base)

    // Environment class instantiation.
    axi_stream_tb_env m_env;

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      // Environment configuration object instantiation.
      axi_stream_tb_env_config env_config;

      // Must always call parent method's build phase.
      super.build_phase(phase);

      // Create environment and its configuration object.
      m_env = axi_stream_tb_env::type_id::create("m_env", this);
      env_config = axi_stream_tb_env_config::type_id::create("env_config");

      // Configure axi_Stream Agent.
      env_config.m_axi_stream_agent1_config = axi_stream_agent_config
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("m_axi_stream_agent1_config");
      env_config.m_axi_stream_agent1_config.active = UVM_ACTIVE;
      env_config.m_axi_stream_agent1_config.is_transmitter = TRANSMITTER;
      env_config.m_axi_stream_agent1_config.set_id(0);  // Set agent ID to 0
      env_config.m_axi_stream_agent1_config.tready_delay_en  = 1'b1;  //receiver
      env_config.m_axi_stream_agent1_config.tready_always_on = 1'b1;  //receiver

      if (!uvm_config_db#(virtual axi_stream_if #(
              .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)
          ))::get(
              this, "", "transmitter_if", env_config.m_axi_stream_agent1_config.m_vif
          )) begin
        `uvm_fatal("transmitter_if TB", "No interface specified for axi_Stream Agent 1")
      end

      env_config.m_axi_stream_agent2_config = axi_stream_agent_config
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("m_axi_stream_agent2_config");
      env_config.m_axi_stream_agent2_config.active = UVM_ACTIVE;
      env_config.m_axi_stream_agent2_config.is_transmitter = RECEIVER;

      env_config.m_axi_stream_agent2_config.tvalid_delay_en = 1'b1;  //transmiter
      env_config.m_axi_stream_agent2_config.set_id(1);  // Set agent ID to 1

      if (!uvm_config_db#(virtual axi_stream_if #(
              .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)
          ))::get(
              this, "", "receiver_if", env_config.m_axi_stream_agent2_config.m_vif
          )) begin
        `uvm_fatal("receiver_if TB", "No interface specified for axi_Stream Agent 2")
      end
      // Environment post configuration
      configure_env(env_config);

      // Post configure and set configuration object to database
      uvm_config_db#(axi_stream_tb_env_config)::set(this, "*", "axi_stream_tb_env_config",
                                                    env_config);
    endfunction : build_phase

    // Convenience method used by test sub-classes to modify the environment.
    virtual function void configure_env(axi_stream_tb_env_config env_config);
      // Environment post config here (if needed).
    endfunction : configure_env

  endclass : axi_stream_tb_test_base

  //------------------------------------------------------------------------------
  // CLASS: axi_stream_tb_main_ready_all_one_test
  //------------------------------------------------------------------------------
  // Testcase 1: Test ready always on
  //------------------------------------------------------------------------------
  // Description : receive with a ready always on
  //------------------------------------------------------------------------------
  class axi_stream_tb_main_ready_all_one_test extends axi_stream_tb_test_base;
    // UVM Factory Registration Macro
    `uvm_component_utils(axi_stream_tb_main_ready_all_one_test)

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    // Environment configuration for current test.
    function void configure_env(axi_stream_tb_env_config env_config);
      // Enable axi_Stream Agent usage.
      env_config.has_axi_stream_agent1 = 1'b1;
      env_config.has_axi_stream_agent2 = 1'b1;
    endfunction : configure_env

    // Main task executed by the test.
    task run_phase(uvm_phase phase);
      axi_stream_tb_receiver_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))   receiver_seq;
      axi_stream_tb_transmiter_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)) transmitter_seq;

      receiver_seq = axi_stream_tb_receiver_seq
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("receiver_seq");
      transmitter_seq = axi_stream_tb_transmiter_seq
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("transmitter_seq");

      uvm_test_done.raise_objection(this);
      fork
        begin
          receiver_seq.transfers = 8;
          receiver_seq.tready_delay = 2;
          receiver_seq.tready_high_delay = 2;
          transmitter_seq.transfers = 5;
          transmitter_seq.delay_cycles = 3;
          transmitter_seq.tvalid_delay = 3;
          receiver_seq.start(m_env.m_axi_stream_agent2.m_sequencer);
          transmitter_seq.start(m_env.m_axi_stream_agent1.m_sequencer);
        end
      join
      uvm_test_done.drop_objection(this);

    endtask : run_phase

  endclass : axi_stream_tb_main_ready_all_one_test
  //------------------------------------------------------------------------------
  // CLASS: axi_stream_tb_main_tready_delay_test
  //------------------------------------------------------------------------------
  // Testcase 2: Test ready with delay to cero
  //------------------------------------------------------------------------------
  // Description : receive with ready on one and delays set a set cero
  //------------------------------------------------------------------------------
  class axi_stream_tb_main_tready_delay_test extends axi_stream_tb_test_base;
    // UVM Factory Registration Macro
    `uvm_component_utils(axi_stream_tb_main_tready_delay_test)

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    // Environment configuration for current test.
    function void configure_env(axi_stream_tb_env_config env_config);
      // Enable axi_Stream Agent usage.
      env_config.has_axi_stream_agent1 = 1'b1;
      env_config.has_axi_stream_agent2 = 1'b1;
      env_config.m_axi_stream_agent2_config.tready_always_on    = 1'b0;//receptor
    endfunction : configure_env

    // Main task executed by the test.
    task run_phase(uvm_phase phase);
      axi_stream_tb_receiver_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))   receiver_seq;
      axi_stream_tb_transmiter_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)) transmitter_seq;

      receiver_seq = axi_stream_tb_receiver_seq
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("receiver_seq");
      transmitter_seq = axi_stream_tb_transmiter_seq
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("transmitter_seq");

      uvm_test_done.raise_objection(this);
      fork
        begin
          receiver_seq.transfers = 8;
          receiver_seq.tready_delay = 2;
          receiver_seq.tready_high_delay = 2;
          transmitter_seq.transfers = 8;
          transmitter_seq.delay_cycles = 2;
          transmitter_seq.tvalid_delay = 7;
          receiver_seq.start(m_env.m_axi_stream_agent2.m_sequencer);
          transmitter_seq.start(m_env.m_axi_stream_agent1.m_sequencer);
        end
      join
      uvm_test_done.drop_objection(this);

    endtask : run_phase

  endclass : axi_stream_tb_main_tready_delay_test
  //------------------------------------------------------------------------------
  // CLASS: axi_stream_tb_main_tready_step_test
  //------------------------------------------------------------------------------
  // Testcase 3: Test ready with delay
  //------------------------------------------------------------------------------
  // Description : receive with ready delay on one and delays set a set cero
  //------------------------------------------------------------------------------
  class axi_stream_tb_main_tready_step_test extends axi_stream_tb_test_base;
    // UVM Factory Registration Macro
    `uvm_component_utils(axi_stream_tb_main_tready_step_test)

    // Constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Test's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    // Environment configuration for current test.
    function void configure_env(axi_stream_tb_env_config env_config);
      // Enable axi_Stream Agent usage.
      env_config.has_axi_stream_agent1 = 1'b1;
      env_config.has_axi_stream_agent2 = 1'b1;
      env_config.m_axi_stream_agent2_config.tready_always_on    = 1'b0;//receptor
      env_config.m_axi_stream_agent2_config.tready_delay_en    = 1'b0;//receptor
    endfunction : configure_env

    // Main task executed by the test.
    task run_phase(uvm_phase phase);
      axi_stream_tb_receiver_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))   receiver_seq;
      axi_stream_tb_transmiter_seq #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)) transmitter_seq;

      receiver_seq = axi_stream_tb_receiver_seq
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("receiver_seq");
      transmitter_seq = axi_stream_tb_transmiter_seq
          #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2))::type_id::create("transmitter_seq");

      uvm_test_done.raise_objection(this);
      fork
        begin
          receiver_seq.transfers = 8;
          receiver_seq.tready_delay = 2;
          receiver_seq.tready_high_delay = 2;
          transmitter_seq.transfers = 13;
          transmitter_seq.delay_cycles = 4;
          transmitter_seq.tvalid_delay = 5;
          receiver_seq.start(m_env.m_axi_stream_agent2.m_sequencer);
          transmitter_seq.start(m_env.m_axi_stream_agent1.m_sequencer);
        end
      join
      uvm_test_done.drop_objection(this);

    endtask : run_phase
  endclass : axi_stream_tb_main_tready_step_test

endpackage : axi_stream_tb_test_pkg
