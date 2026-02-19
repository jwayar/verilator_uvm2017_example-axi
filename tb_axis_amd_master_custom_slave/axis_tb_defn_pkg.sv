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
// Filename           : axi4full_defn_pkg.sv                                   :
// Date Last Modified : 2021 SEP 20                                            :
// Date Created       : 2021 SEP 20                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : AXI4full TB Definitions Package                        :
// Author(s)          : Fernando Gerbino                                           :
// Email              : fgerbino@emtech.com.ar                                  :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axis_tb_defn_pkg;

  import axi_stream_agent_pkg::*;
  import xilinxs_vip_pkg::*;
  import utils_pkg::*; 
  
  // TB Top definitions.
  localparam int RESET_CLOCK_COUNT = 90;
  localparam int CLK_FREQ_HZ = 125e6;
  localparam time CLK_PERIOD_NS = 1s / CLK_FREQ_HZ;

  // Parameters of Agents definitions
  
  // NOTE: The set of C_XIL* parameters can be found in the following path:
  // amd_axi_stream_vip\xillinxs_vip\axi_vip\xilinxs_vip_pkg.sv

  localparam int AXIS_MASTER_SIGNAL_SET = C_XIL_AXI4STREAM_SIGNAL_SET;
  localparam int AXIS_MASTER_DATA_WIDTH = C_XIL_AXI4STREAM_DATA_WIDTH;
  localparam int AXIS_MASTER_ID_WIDTH   = C_XIL_AXI4STREAM_ID_WIDTH;
  localparam int AXIS_MASTER_DEST_WIDTH = C_XIL_AXI4STREAM_DEST_WIDTH;
  localparam int AXIS_MASTER_USER_WIDTH = C_XIL_AXI4STREAM_USER_WIDTH;

  localparam int AXIS_SLAVE_DATA_WIDTH = C_XIL_AXI4STREAM_DATA_WIDTH;
  localparam int AXIS_SLAVE_ID_WIDTH   = C_XIL_AXI4STREAM_ID_WIDTH;
  localparam int AXIS_SLAVE_DEST_WIDTH = C_XIL_AXI4STREAM_DEST_WIDTH;
  localparam int AXIS_SLAVE_USER_WIDTH = C_XIL_AXI4STREAM_USER_WIDTH;

  // Typedefs used to simplify code 
  // (avoid adding all parameters to each agent instance, interface, or sequence item)

  typedef axi4stream_mst_agent #(
      .C_XIL_AXI4STREAM_SIGNAL_SET        (AXIS_MASTER_SIGNAL_SET), 
      .C_XIL_AXI4STREAM_DEST_WIDTH        (AXIS_MASTER_DEST_WIDTH), 
      .C_XIL_AXI4STREAM_DATA_WIDTH        (AXIS_MASTER_DATA_WIDTH), 
      .C_XIL_AXI4STREAM_ID_WIDTH          (AXIS_MASTER_ID_WIDTH), 
      .C_XIL_AXI4STREAM_USER_WIDTH        (AXIS_MASTER_USER_WIDTH), 
      .C_XIL_AXI4STREAM_USER_BITS_PER_BYTE(1'b0), 
      .C_XIL_AXI4STREAM_HAS_ARESETN       (1'b1) 
  )  axis_master_agent;

  typedef virtual axi4stream_vip_if  #(
     .C_AXI4STREAM_SIGNAL_SET        (AXIS_MASTER_SIGNAL_SET), 
     .C_AXI4STREAM_DEST_WIDTH        (AXIS_MASTER_DEST_WIDTH), 
     .C_AXI4STREAM_DATA_WIDTH        (AXIS_MASTER_DATA_WIDTH), 
     .C_AXI4STREAM_ID_WIDTH          (AXIS_MASTER_ID_WIDTH), 
     .C_AXI4STREAM_USER_WIDTH        (AXIS_MASTER_USER_WIDTH), 
     .C_AXI4STREAM_USER_BITS_PER_BYTE(1'b0), 
     .C_AXI4STREAM_HAS_ARESETN       (1'b1)  
  ) axis_master_if;

  typedef axi_stream_agent #(
      .PARM_DATA_WIDTH(AXIS_SLAVE_DATA_WIDTH),
      .PARM_ID_WIDTH  (AXIS_SLAVE_ID_WIDTH),
      .PARM_DEST_WIDTH(AXIS_SLAVE_DEST_WIDTH),
      .PARM_USER_WIDTH(AXIS_SLAVE_USER_WIDTH)
  ) axis_slave_agent;

  typedef virtual axi_stream_if #(
      .PARM_DATA_WIDTH(AXIS_SLAVE_DATA_WIDTH),
      .PARM_ID_WIDTH  (AXIS_SLAVE_ID_WIDTH),
      .PARM_DEST_WIDTH(AXIS_SLAVE_DEST_WIDTH),
      .PARM_USER_WIDTH(AXIS_SLAVE_USER_WIDTH)
  ) axis_slave_if;

  typedef axi_stream_seq_item #(.PARM_DATA_WIDTH(AXIS_SLAVE_DATA_WIDTH),
                                .PARM_ID_WIDTH  (AXIS_SLAVE_ID_WIDTH),
                                .PARM_DEST_WIDTH(AXIS_SLAVE_DEST_WIDTH),
                                .PARM_USER_WIDTH(AXIS_SLAVE_USER_WIDTH)) axi_st_seq_item;

  typedef axi_stream_agent_config #(
      .PARM_DATA_WIDTH(AXIS_MASTER_DATA_WIDTH),
      .PARM_ID_WIDTH  (AXIS_MASTER_ID_WIDTH),
      .PARM_DEST_WIDTH(AXIS_MASTER_DEST_WIDTH),
      .PARM_USER_WIDTH(AXIS_MASTER_USER_WIDTH)
  ) axis_agent_config;

  typedef in_order_comparator #(axi_st_seq_item) axis_tb_comparator;

endpackage : axis_tb_defn_pkg
