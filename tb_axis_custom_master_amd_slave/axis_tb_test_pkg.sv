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

      // Must always call parent method's build phase.
      super.build_phase(phase);

      // Create environment and its configuration object.
      m_env = axis_tb_env::type_id::create("m_env", this);
      env_config = axis_tb_env_config::type_id::create("env_config");

      // Create AXIs config classes and define configuration
      // Configure AXIS MASTER
      env_config.m_axis_master_agent_config = axis_agent_config::type_id::create(
        "m_axis_master_agent_config"
      );
      
      env_config.m_axis_master_agent_config.active = UVM_ACTIVE;
      env_config.m_axis_master_agent_config.is_transmitter = TRANSMITTER;
      env_config.m_axis_master_agent_config.set_id(0);  // Set agent ID to 0

      if (!uvm_config_db#(axis_master_if)::get(this, "", "master_if", env_config.m_axis_master_agent_config.m_vif)) begin
        `uvm_fatal(this.get_name(), "No interface specified for m_axis_master_agent!")
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

    int low_time_max                = 20;   // Maximum delay cycles for TREADY=0
    int low_time_min                = 1 ;   // Minimum delay cycles for TREADY=0
    bit set_random_tready_ena       = 0 ;   // Enable random TREADY generation policy
    bit set_counter_data            = 0 ;   // Selector: 0=Random Data, 1=Counter Data
    
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
      super.configure_env(env_config);
      // Enable axi_Stream Agent usage.
      env_config.has_axis_master_agent = 1'b1;
      env_config.has_axis_slave_agent  = 1'b1;
      // example of how disable signals
      env_config.m_axis_master_agent_config.tkeep_en = 1'b0;
      env_config.m_axis_master_agent_config.tstrb_en = 1'b0;
    endfunction : configure_env

    // Main task executed by the test.
    task run_phase(uvm_phase phase);

      axi_stream_seq_pipelined_transmiter #(
        .PARM_DATA_WIDTH(AXIS_MASTER_DATA_WIDTH),
        .PARM_ID_WIDTH  (AXIS_MASTER_ID_WIDTH),
        .PARM_DEST_WIDTH(AXIS_MASTER_DEST_WIDTH),
        .PARM_USER_WIDTH(AXIS_MASTER_USER_WIDTH)
      ) transmitter_seq;
      
      axi4stream_ready_gen_t  ready_gen;

      transmitter_seq = axi_stream_seq_pipelined_transmiter#(
        .PARM_DATA_WIDTH(AXIS_MASTER_DATA_WIDTH),
        .PARM_ID_WIDTH  (AXIS_MASTER_ID_WIDTH),
        .PARM_DEST_WIDTH(AXIS_MASTER_DEST_WIDTH),
        .PARM_USER_WIDTH(AXIS_MASTER_USER_WIDTH)
      )::type_id::create(
          "transmitter_seq"
      );

      uvm_test_done.raise_objection(this);
    
      fork
        begin // SLAVE AGENT  
       
          // Initialization of the AMD slave agent
          m_env.m_axis_slave_agent.start_slave();
          // Ready generation object
          ready_gen = m_env.m_axis_slave_agent.driver.create_ready("ready_gen_config");
       
          // Manual configuration of generation of the tready_signal
          if(set_random_tready_ena == 1) begin 
            // RANDOM POLICY: TREADY low time will vary randomly
            ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_RANDOM);
            // Set constraints to TREADY=0 (min and max cycles low)
            ready_gen.set_low_time_range (low_time_min,low_time_max);
            // Set TREADY=1 to be fixed at 1 cycle
            ready_gen.set_high_time_range(1,1); 
          end
          else begin 
            // FIXED/PERIODIC POLICY: TREADY low/high cycle is fixed 
            ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_OSC);
            // Set TREADY=0 to a constant N cycles (Fixed delay)
            ready_gen.set_low_time(low_time_max); 
            // Set TREADY=1 to be fixed at 1 cycle
            ready_gen.set_high_time(1); 
          end 
        
          // Send the configured policy to the AMD Slave Driver to begin TREADY generation
          m_env.m_axis_slave_agent.driver.send_tready(ready_gen);

        end // end SLAVE AGENT

        begin // MASTER AGENT

          if (!transmitter_seq.randomize() with {
                
            send_counter_data     == set_counter_data;

          }) begin
            `uvm_fatal(this.get_name(), $sformatf("Unable to randomize transmitter_seq"))
          end

          transmitter_seq.start(m_env.m_axis_master_agent.m_sequencer);
        
        end
      join

      #100ns;
      uvm_test_done.drop_objection(this);

    endtask : run_phase


  endclass : axis_tb_main_test


endpackage : axis_tb_test_pkg
