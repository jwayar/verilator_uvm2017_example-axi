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
// Filename           : axi4full_env_pkg.sv                                    :
// Date Last Modified : 2021 SEP 20                                            :
// Date Created       : 2021 SEP 20                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : AXI4full TB Environment Package                        :
// Author(s)          : Fernando Gerbino                                           :
// Email              : fgerbino@emtech.com.ar                                  :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axis_tb_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import axi_stream_agent_pkg::*;
  import axis_tb_defn_pkg::*;
  import axis_tb_scoreboard_pkg::*;
  import xilinxs_vip_pkg::*;

  class axis_tb_env_config extends uvm_object;
    // UVM Factory Registration Macro.
    `uvm_object_utils(axis_tb_env_config)

    // Agent usage flags.
    bit has_axis_master_agent = 1'b1;
    bit has_axis_slave_agent  = 1'b1;

    // Configuration objects for the environment's sub components.
    axis_agent_config m_axis_master_agent_config;

    // Configuration object's constructor.
    function new(string name = "axis_tb_env_config");
      super.new(name);
    endfunction : new

  endclass : axis_tb_env_config

  class axis_tb_env extends uvm_env;
    // UVM Factory Registration Macro.
    `uvm_component_utils(axis_tb_env)

    // Environment's configuration object instantiation.
    axis_tb_env_config m_config;

    // Agents instantiation.
    axis_master_agent m_axis_master_agent;
    axis_master_if    master_vif;

    axis_slave_agent m_axis_slave_agent;
    axis_slave_if    slave_vif;

    // Scoreboard instatiation
    axis_tb_scoreboard m_scoreboard;

    // Environment's constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Environment's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Get Environment's configuration from database.
      if (m_config == null) begin
        if (!uvm_config_db#(axis_tb_env_config)::get(
                this, "", "axis_tb_env_config", m_config
            )) begin
          `uvm_fatal(this.get_name(), "No env configuration object specified")
        end
      end

      // Create axi_Stream Agent 1 if used.
      if (m_config.has_axis_master_agent) begin
        // Create Agent.
        m_axis_master_agent = axis_master_agent::type_id::create(
            "m_axis_master_agent", this
        );

        // Get Agent's configuration object from database.
        uvm_config_db#(axis_agent_config)::set(this, "m_axis_master_agent", "m_config",
          m_config.m_axis_master_agent_config);
      end

      // Create axi_Stream Agent 2 if used.
      if (m_config.has_axis_slave_agent) begin
         // Get interface needed to construct the slave agent
         if (!uvm_config_db#(axis_slave_if)::get(this, "", "slave_if", slave_vif)) begin
             `uvm_fatal("NOVIF", " axis_slave_if not founded")
         end
          // Create slave agent 
          m_axis_slave_agent = new("m_axis_slave_agent", slave_vif);
      end

      // Create scoreboard 
      m_scoreboard = axis_tb_scoreboard::type_id::create("m_scoreboard", this);

    endfunction : build_phase

    // Environment's connect phase.
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      // Conection between scoreboard and slave agent
      if(m_config.has_axis_slave_agent) begin 
        m_scoreboard.prd.m_axis_slave_agent = m_axis_slave_agent;
      end
      // Conection between master agent and scoreboard
      if(m_config.has_axis_master_agent) begin 
        m_axis_master_agent.aport.connect(m_scoreboard.after_aexp);
      end 

    endfunction : connect_phase

    task run_phase(uvm_phase phase);
    endtask: run_phase

  endclass : axis_tb_env

endpackage : axis_tb_env_pkg
