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
// Filename           : axi_stream_tb_env_pkg.sv                                   :
// Date Last Modified : 2025 SEP 1                                           :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : axi_Stream Testbench Enviroment                            :
// Author(s)          : Juan Doctorovich                                        :
// Email              : jdoctorovich@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axi_stream_tb_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import axi_stream_agent_pkg::*;
  import axi_stream_tb_defn_pkg::*;

  class axi_stream_tb_env_config extends uvm_object;
    // UVM Factory Registration Macro.
    `uvm_object_utils(axi_stream_tb_env_config)

    // Agent usage flags.
    bit has_axi_stream_agent1 = 1'b1;
    bit has_axi_stream_agent2 = 1'b1;

    // Configuration objects for the environment's sub components.
    axi_stream_agent_config #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)) m_axi_stream_agent1_config;
    axi_stream_agent_config #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)) m_axi_stream_agent2_config;

    // Configuration object's constructor.
    function new(string name = "axi_stream_tb_env_config");
      super.new(name);
    endfunction : new

  endclass : axi_stream_tb_env_config

  class axi_stream_tb_env extends uvm_env;
    // UVM Factory Registration Macro.
    `uvm_component_utils(axi_stream_tb_env)

    // Environment's configuration object instantiation.
    axi_stream_tb_env_config m_config;

    // Agents instantiation.
    axi_stream_agent #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)) m_axi_stream_agent1;
    axi_stream_agent #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)) m_axi_stream_agent2;

    virtual axi_stream_if #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)) transmitter;
    virtual axi_stream_if #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)) receiver;

    // Environment's constructor.
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Environment's build phase.
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Get Environment's configuration from database.
      if (m_config == null) begin
        if (!uvm_config_db#(axi_stream_tb_env_config )::get(
                this, "", "axi_stream_tb_env_config", m_config
            )) begin
          `uvm_fatal("axi_Stream TB Env", "No configuration object specified")
        end
      end

      // Create axi_Stream Agent 1 if used.
      if (m_config.has_axi_stream_agent1) begin
        // Create Agent.
        m_axi_stream_agent1 = axi_stream_agent #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2))::type_id::create("m_axi_stream_agent1", this);

        // Get Agent's configuration object from database.
        uvm_config_db#(axi_stream_agent_config #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)))::set(this, "m_axi_stream_agent1", "m_config",
                                                 m_config.m_axi_stream_agent1_config);
      end

      // Create axi_Stream Agent 2 if used.
      if (m_config.has_axi_stream_agent2) begin
        // Create Agent.
        m_axi_stream_agent2 = axi_stream_agent #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2))::type_id::create("m_axi_stream_agent2", this);

        // Get Agent's configuration object from database.
        uvm_config_db#(axi_stream_agent_config #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2), .PARM_ID_WIDTH(PARM_ID_WIDTH_2), .PARM_DEST_WIDTH(PARM_DEST_WIDTH_2), .PARM_USER_WIDTH(PARM_USER_WIDTH_2)))::set(this, "m_axi_stream_agent2", "m_config",
                                                 m_config.m_axi_stream_agent2_config);
      end
    endfunction : build_phase

    // Environment's connect phase.
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // Nothing to connect here at the moment.
    endfunction : connect_phase

  endclass : axi_stream_tb_env

endpackage : axi_stream_tb_env_pkg
