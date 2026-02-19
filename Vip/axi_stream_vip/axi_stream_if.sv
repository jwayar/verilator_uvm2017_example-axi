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
// Filename           : axi_stream_if.sv                                       :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream interface                                       :
// Author(s)          : Juan Doctorovich                                       :
// Email              : jdoctorovich@emtech.com.ar                             :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_IF_SVH
`define AXI_STREAM_IF_SVH

//  Interface: stream_if
//
interface axi_stream_if #(
    parameter PARM_DATA_WIDTH = 512,
    parameter PARM_USER_WIDTH = 256,
    parameter PARM_DEST_WIDTH = 8,
    parameter PARM_ID_WIDTH   = 16,
    parameter PARM_CHECK_TYPE = 8
) (
    input logic aresetn,
    input logic aclk
);

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import axi_stream_agent_pkg::*;

  wire                             tvalid;
  wire                             tready;
  wire                             tlast;
  //axis_tdata_t
  wire [PARM_DATA_WIDTH    -1 : 0] tdata;
  //axis_tstrb_t
  wire [PARM_DATA_WIDTH/8  -1 : 0] tstrb;
  //axis_tkeep_t
  wire [PARM_DATA_WIDTH/8  -1 : 0] tkeep;
  //axis_tid_t
  wire [PARM_ID_WIDTH      -1 : 0] tid;
  //axis_tdest_t
  wire [PARM_DEST_WIDTH    -1 : 0] tdest;
  //axis_tuser_t
  wire [PARM_USER_WIDTH    -1 : 0] tuser;

  clocking transmitter @(posedge aclk);
    default input #1fs output #1fs;
    output tvalid;
    output tdata;
    output tstrb;
    output tkeep;
    output tlast;
    output tid;
    output tdest;
    output tuser;
    input tready;
  endclocking : transmitter

  clocking receiver @(posedge aclk);
    default input #1fs output #1fs;
    output tready;
    input tvalid;
    input tdata;
    input tstrb;
    input tkeep;
    input tlast;
    input tid;
    input tdest;
    input tuser;
  endclocking : receiver

  clocking mon_cb @(posedge aclk);
    default input #1fs output #1fs;
    input tready;
    input tvalid;
    input tdata;
    input tstrb;
    input tkeep;
    input tlast;
    input tid;
    input tdest;
    input tuser;
  endclocking : mon_cb

  //TODOjw: Unsupported in Verilator, posibles errores x el driver (sincrionismo)
  // default clocking mon_cb;

  // ##0 means wait for next clocking event of the default clocking, only if this clocking event is not happening in current time step.
  task sync_clk();
    ##0;
  endtask : sync_clk
  task automatic wait_ns(int unsigned delay);  //creates delay in ns
    #(delay * 1ns);
  endtask
endinterface : axi_stream_if

`endif  // AXI_STREAM_IF
