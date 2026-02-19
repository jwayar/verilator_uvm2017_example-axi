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
// Filename           : axi_stream_tb_defn_pkg.sv                                  :
// Date Last Modified : 2025 SEP 1                                           :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : axi_Stream Testbench definitions                           :
// Author(s)          : Juan Doctorovich                                        :
// Email              : jdoctorovich@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axi_stream_tb_defn_pkg;

  // TB Top definitions.
  localparam int RESET_CLOCK_COUNT = 10;
  localparam int CLK_FREQ_HZ = 125e6;
  localparam time CLK_PERIOD_NS = 1s / CLK_FREQ_HZ;

  // AGENT definitions.
  localparam PARM_DATA_WIDTH_2  = 1024;
  localparam MAPPED_BITS_WIDTH_2  = 8;
  localparam MAX_DATA_WIDTH_2  = 1024;
  localparam PARM_TSTRB_WIDTH_2 = PARM_DATA_WIDTH_2/8;
  localparam PARM_TKEEP_WIDTH_2 = PARM_DATA_WIDTH_2/8;
  localparam PARM_DEST_WIDTH_2  = 8;
  localparam PARM_USER_WIDTH_2  = 256;
  localparam PARM_ID_WIDTH_2    = 16;
  localparam PARM_CHECK_TYPE_2  = 8;

  typedef struct packed {
    int unsigned DATA_WIDTH;
    int unsigned MAX_DATA_WIDTH;
    int unsigned MAPPED_BITS_WIDTH;
    int unsigned TSTRB_WIDTH;
    int unsigned TKEEP_WIDTH;
    int unsigned ID_WIDTH;
    int unsigned DEST_WIDTH;
    int unsigned USER_WIDTH;
    int unsigned CHECK_TYPE;
  } my_cfg_t;

endpackage : axi_stream_tb_defn_pkg
