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
// Filename           : axi_stream_sequencer.svh                               :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream sequencer class                                 :
// Author(s)          : Juan Doctorovich,            Fernando Gerbino          :
// Email              : jdoctorovich@emtech.com.ar,  fgerbino@emtech.com.ar    :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_SEQUENCER_SVH
`define AXI_STREAM_SEQUENCER_SVH

class axi_stream_sequencer #(parameter PARM_DATA_WIDTH = 512, parameter PARM_ID_WIDTH = 16, parameter PARM_DEST_WIDTH = 8, parameter PARM_USER_WIDTH = 256) extends uvm_sequencer #(axi_stream_seq_item #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)));
  `uvm_component_param_utils(axi_stream_sequencer #( .PARM_DATA_WIDTH(PARM_DATA_WIDTH), .PARM_ID_WIDTH(PARM_ID_WIDTH), .PARM_DEST_WIDTH(PARM_DEST_WIDTH), .PARM_USER_WIDTH(PARM_USER_WIDTH)))

  extern function new(string name, uvm_component parent);

endclass : axi_stream_sequencer

function axi_stream_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

`endif
