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
// Filename           : axi_stream_agent_pkg.sv                                :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : axi_Stream agent package                               :
// Author(s)          : Juan Doctorovich                                       :
// Email              : jdoctorovich@emtech.com.ar                             :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

package axi_stream_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "axi_stream_parameters.svh"
  `include "axi_stream_enum.svh"
  `include "axi_stream_agent_config.svh"

  `include "axi_stream_seq_item.svh"

  `include "axi_stream_sequencer.svh"
  `include "axi_stream_driver_receiver.svh"
  `include "axi_stream_driver_transmitter.svh"
  `include "axi_stream_monitor.svh"
  `include "axi_stream_agent.svh"

  // Utility sequences
  `include "axi_stream_seq.svh"
endpackage
