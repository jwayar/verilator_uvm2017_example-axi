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
// Filename           : stream_agent_config.svh                                :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream agent config                                    :
// Author(s)          : Juan Doctorovich,           Fernando Gerbino           :
// Email              : jdoctorovich@emtech.com.ar, fgerbino@emtech.com.ar     :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// CLASS: axi_stream_agent_config
//--------------------------------------------------------------------------------------------------
// AXI Agent Configuration Object
//--------------------------------------------------------------------------------------------------

`ifndef AXI_STREAM_AGENT_CONFIG_SVH
`define AXI_STREAM_AGENT_CONFIG_SVH 

class axi_stream_agent_config #(
    parameter PARM_DATA_WIDTH = 512,
    parameter PARM_ID_WIDTH   = 16,
    parameter PARM_DEST_WIDTH = 8,
    parameter PARM_USER_WIDTH = 256
) extends uvm_object;
  // UVM Factory Registration Macro.
  `uvm_object_param_utils(axi_stream_agent_config#(.PARM_DATA_WIDTH(PARM_DATA_WIDTH),
                                                   .PARM_ID_WIDTH(PARM_ID_WIDTH),
                                                   .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
                                                   .PARM_USER_WIDTH(PARM_USER_WIDTH)))

  virtual axi_stream_if #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH  (PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)
  ) m_vif;

  //set active id
  int agent_id = 0;

  //set active agent
  uvm_active_passive_enum active = UVM_ACTIVE;
  
  //check if theres is x or z in the values
  bit is_x_z_check = 1'b0;

  rec_tran_e is_transmitter;

  bit tvalid_delay_en = 1'b1;

  bit tready_always_on = 1'b1;
  bit tready_delay_en = 1'b1;

  bit          tid_en   = 1'b1;
  bit          tdest_en = 1'b1;
  bit          tuser_en = 1'b1;
  bit          tlast_en = 1'b1;
  bit          tkeep_en = 1'b1;
  bit          tstrb_en = 1'b1;

  bit          tready_timeout_fail;
  int unsigned tready_timeout;

  bit          tvalid_timeout_fail;
  int unsigned tvalid_timeout;

  extern function void set_id(int id);
  extern function int get_id();
  extern function new(string name = "");

endclass : axi_stream_agent_config

function axi_stream_agent_config::new(string name = "");
  super.new(name);

  is_transmitter      = TRANSMITTER;

  tready_timeout_fail = 1;
  tready_timeout      = TREADY_TIMEOUT_DEFAULT;

  tvalid_timeout_fail = 1;
  tvalid_timeout      = TVALID_TIMEOUT_DEFAULT;

endfunction : new

/*
 * Function: set_id
 * To set the agent ID.
 * Parameters:
 *   id: Integer agent ID to set.
 */
function void axi_stream_agent_config::set_id(int id);
  this.agent_id = id;
endfunction : set_id

/*
 * Function: get_id
 * To obtain the agent ID.
 * Returns:
 *   Integer agent ID.
 */
function int axi_stream_agent_config::get_id();
  return this.agent_id;
endfunction : get_id

`endif
