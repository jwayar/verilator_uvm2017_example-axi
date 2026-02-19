//----------------------------------------------------------------------
// (c) Copyright 2017 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//----------------------------------------------------------------------
`ifndef _AXI4STREAM_VIP_IF_SV_
`define _AXI4STREAM_VIP_IF_SV_

import xilinxs_vip_pkg::*;


   `define ARESET_XCHECK "ARESET_XCHECK: ARESET_N can't be X/Z after 1 cycle of clock."
   `define ARESET_XCHECK_SOL "Use <hierarchy_path>.IF.set_enable_xchecks_to_warn  to downgrade error message to warning message.Use <hierarchy_path>.IF.clr_enable_xchecks to downgrade error message to information message, <hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF"

  `define XILINX_RESET_PULSE "XILINX_RESET_PULSE_WIDTH: Holding AXI ARESETN asserted for 16 cycles of the slowest AXI clock is generally a sufficient reset pulse width for Xilinx IP. --UG1037."
  `define XILINX_RESET_PULSE_SOL "Use <hierarchy_path>.IF.set_xilinx_reset_check_to_warn() to downgrade this error message to warning message, use <hierarchy_path>.IF.clr_xilinx_reset_check() to downgrade this error message to information message.<hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF"
  `define XILINX_TKEEP_SPARSE "XILINX_TKEEP_SPARSE: Tkeep can not be sparsed."
  `define XILINX_TKEEP_SPARSE_SOL "Use <hierarchy_path>.IF.set_xilinx_tkeep_check_to_warn() to downgrade this error message to warning message, use <hierarchy_path>.IF.clr_xilinx_tkeep_check() to downgrade this error message to information message.<hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF."


 //SEV_NUM is in this order to match legacy APIs
`define REPORT_MACRO(MSG,SOL,SEV_NUM) \
  if(SEV_NUM ==2'b00) $display("INFO: %0t %m : %s",$realtime, MSG); \
  else if(SEV_NUM ==2'b01) $display("WARNING: %0t %m : %s %s",$realtime,MSG,SOL); \
  else if (SEV_NUM ==2'b10) $display("ERROR: %0t %m  : %s %s",$realtime,MSG,SOL);


// import axi4stream_vip_pkg::*;
// workaround for Internal Error: axi4stream_vip_if.sv:73:11 (no working solution found yet)
 (* verilator public *)
interface axi4stream_vip_if  #(
      xil_axi4stream_sigset_t C_AXI4STREAM_SIGNAL_SET         = 8'h0,
      int                     C_AXI4STREAM_DEST_WIDTH         = 4,
                              C_AXI4STREAM_DATA_WIDTH         = 32,
                              C_AXI4STREAM_ID_WIDTH           = 4,
                              C_AXI4STREAM_USER_WIDTH         = 32,
                              C_AXI4STREAM_USER_BITS_PER_BYTE = 0,
                              C_AXI4STREAM_HAS_ARESETN        = 1)
    (
      input bit ACLK, ACLKEN, ARESET_N
    );

  parameter time C_HOLD_TIME      = 1ps;
  parameter integer C_MAXWAITS    = 16;
  wire  TREADY;
  wire  TVALID;
  wire  TLAST;
  wire [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DEST] == 0 ) ? 0 : C_AXI4STREAM_DEST_WIDTH   - 1) : 0] TDEST;
  wire [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_ID  ] == 0 ) ? 0 : C_AXI4STREAM_ID_WIDTH     - 1) : 0] TID;
  wire [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER] == 0 ) ? 0 : C_AXI4STREAM_USER_WIDTH   - 1) : 0] TUSER;
  wire [((C_AXI4STREAM_DATA_WIDTH == 0 ) ? 0 : (C_AXI4STREAM_DATA_WIDTH - 1)) :   0] TDATA;
  wire [((C_AXI4STREAM_DATA_WIDTH == 0 ) ? 0 : ((C_AXI4STREAM_DATA_WIDTH/8)-1)) : 0] TKEEP;
  wire [((C_AXI4STREAM_DATA_WIDTH == 0 ) ? 0 : ((C_AXI4STREAM_DATA_WIDTH/8)-1)) : 0] TSTRB;

  logic  ready = 1'b0;
  logic  valid = 1'b0;
  logic  last;
  logic [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DEST] == 0 ) ? 0 : C_AXI4STREAM_DEST_WIDTH   - 1) : 0] dest;
  logic [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_ID  ] == 0 ) ? 0 : C_AXI4STREAM_ID_WIDTH     - 1) : 0] id;
  logic [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER] == 0 ) ? 0 : C_AXI4STREAM_USER_WIDTH   - 1) : 0] user;
  logic [(C_AXI4STREAM_DATA_WIDTH   - 1) : 0] data;
  logic [((C_AXI4STREAM_DATA_WIDTH/8)-1) : 0] keep;
  logic [((C_AXI4STREAM_DATA_WIDTH/8)-1) : 0] strb;

  logic intf_is_master = 0;
  logic intf_is_slave  = 0;
  logic [1:0] xilinx_reset_check_enable = 2'b10;
  logic [1:0] enable_xchecks = 2'b10;
  logic fake_reset;
  logic real_reset;
  logic reset_for_assert;
  logic [1:0] xilinx_tkeep_check_enable = 2'b00;
  int   tkeep_err_cnt;
  int   reset_cnt;

  assign TVALID =                                               intf_is_master ? valid : 'z;
  assign TREADY = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_READY]) ? (intf_is_slave  ? ready : 'z) : '1;
  assign TDATA  = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DATA])  ? (intf_is_master ? data  : 'z) : '0;
  assign TSTRB  = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DATA])  ? (intf_is_master ? strb  : 'z) : '1;
  assign TKEEP  = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_KEEP])  ? (intf_is_master ? keep  : 'z) : '1;
  assign TUSER  = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER])  ? (intf_is_master ? user  : 'z) : '0;
  assign TLAST  = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_LAST])  ? (intf_is_master ? last  : 'z) : '0;
  assign TID    = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_ID])    ? (intf_is_master ? id    : 'z) : '0;
  assign TDEST  = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DEST])  ? (intf_is_master ? dest  : 'z) : '0;

  wire  TREADY_internal;
  wire  TLAST_internal;


  wire [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DEST] == 0 ) ? 0 : C_AXI4STREAM_DEST_WIDTH   - 1) : 0] TDEST_internal;
  wire [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_ID  ] == 0 ) ? 0 : C_AXI4STREAM_ID_WIDTH     - 1) : 0] TID_internal;
  wire [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER] == 0 ) ? 0 : C_AXI4STREAM_USER_WIDTH   - 1) : 0] TUSER_internal;
  wire [(C_AXI4STREAM_DATA_WIDTH   - 1) : 0] TDATA_internal;
  wire [((C_AXI4STREAM_DATA_WIDTH/8)-1) : 0] TKEEP_internal;
  wire [((C_AXI4STREAM_DATA_WIDTH/8)-1) : 0] TSTRB_internal;

  assign TREADY_internal  = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_READY]== 0) ? 1'b1 : TREADY;
  assign TLAST_internal   = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_LAST] == 0) ? 1'b1 : TLAST;
  assign TDEST_internal   = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DEST] == 0) ? 1'bz : TDEST;
  assign TID_internal     = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_ID]   == 0) ? 1'bz : TID;
  assign TUSER_internal   = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER] == 0) ? 1'bz : TUSER;
  assign TDATA_internal   = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DATA] == 0) ? {C_AXI4STREAM_DATA_WIDTH{1'bz}} : TDATA;
  assign TKEEP_internal   = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_KEEP] == 0) ? {(C_AXI4STREAM_DATA_WIDTH/8){1'bz}} : TKEEP;

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //When there isn't a STRB but there is KEEP then STRB must track KEEP
  assign TSTRB_internal   = (C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_STRB] == 0) ? TKEEP_internal : TSTRB;
  integer unsigned    beat_count = 0;
  integer unsigned    last_count = 0;
  wire ACLK_internal = (ACLKEN == 1'b0) ? 1'b0 : ACLK;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  axi4stream_vip_axi4streampc #(
    .DEST_WIDTH          ((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DEST] == 0 ) ? 0 : C_AXI4STREAM_DEST_WIDTH   ),
    .DATA_WIDTH_BYTES    ((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DATA] == 0 ) ? 0 : C_AXI4STREAM_DATA_WIDTH/8 ),
    .ID_WIDTH            ((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_ID  ] == 0 ) ? 0 : C_AXI4STREAM_ID_WIDTH     ),
    .USER_BITS_PER_BYTE  ((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER] == 0 ) ? 0 : C_AXI4STREAM_USER_BITS_PER_BYTE   ),
    .USER_WIDTH          ((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER] == 0 ) ? 0 : C_AXI4STREAM_USER_WIDTH   ),
    .MAXWAITS            ( C_MAXWAITS ),
    .RecommendOn         ( 1  ),
    .RecMaxWaitOn        ( 0  ),
    .HAS_ARESETN         ( C_AXI4STREAM_HAS_ARESETN)
  ) PC (
    .ACLK               (ACLK             ),
    .ACLKEN             (ACLKEN           ),
    .ARESETn            (ARESET_N         ),
    .TVALID             (TVALID           ),
    .TREADY             (TREADY_internal  ),
    .TDATA              (TDATA_internal[((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DATA] == 0 ) ? 1 : C_AXI4STREAM_DATA_WIDTH)-1:0]),
    .TSTRB              (TSTRB_internal   ),
    .TKEEP              (TKEEP_internal   ),
    .TDEST              (TDEST_internal   ),
    .TID                (TID_internal     ),
    .TLAST              (TLAST_internal   ),
    .TUSER              (TUSER_internal   )
  );

  /*
  *  Function: set_intf_slave
  *  Sets interface to slave mode. When user wants to change passthrough VIP as slave VIP, what they do is to call
  *  <hierarchy_path>.IF.set_intf_slave
  */
  function void set_intf_slave();
    intf_is_master = 0;
    intf_is_slave = 1;
  endfunction : set_intf_slave

  /*
  *  Function: set_intf_master
  *  Sets interface to master mode. When user wants to change passthrough VIP as master VIP, what they do is to call
  *  <hierarchy_path>.IF.set_intf_master
  */
  function void set_intf_master();
    intf_is_master = 1;
    intf_is_slave = 0;
  endfunction : set_intf_master

  /*
  *  Function: set_intf_monitor
  *  Sets interface to monitor mode.Set VIP into runtime passthrough mode.
  *  what they do is to call <hierarchy_path>.IF.set_intf_monitor
  */
  function void set_intf_monitor();
    intf_is_master = 0;
    intf_is_slave = 0;
  endfunction : set_intf_monitor


  /*
  *  Function: set_xilinx_reset_check
  *  Sets xilinx_reset_check_enable to turn on error message when there is a violation of rule which is
  *  holding AXI ARESETN asserted for 16 cycles of the slowest AXI clock is generally a sufficient reset
  *  pulse width for Xilinx IP--UG1037
  */
  function void set_xilinx_reset_check();
    xilinx_reset_check_enable = 2'b10;
  endfunction

  /*
  * Function: set_xilinx_reset_check_to_warn
  * Sets xilinx_reset_check_enable to turn on warning message when there is a violation of rule which is
  * holding AXI ARESETN asserted for 16 cycles of the slowest AXI clock is generally a sufficient reset
  * pulse width for Xilinx IP--UG1037
  */
  function void set_xilinx_reset_check_to_warn();
    xilinx_reset_check_enable = 2'b01;
  endfunction

  /*
  * Function: clr_xilinx_reset_check
  * Sets xilinx_reset_check_enable to turn off warning/error message when there is a violation of rule which is
  * holding AXI ARESETN asserted for 16 cycles of the slowest AXI clock is generally a sufficient reset
  * pulse width for Xilinx IP--UG1037
  */
  function void clr_xilinx_reset_check();
    xilinx_reset_check_enable = 2'b00;
  endfunction

    /*
  *  Function: set_xilinx_tkeep_check
  *  Sets xilinx_tkeep_check_enable to turn on error message when sparse tkeep is being detected
  *  in the transaction.
  */
  function void set_xilinx_tkeep_check();
    xilinx_tkeep_check_enable = 2'b10;
  endfunction

  /*
  * Function: set_xilinx_tkeep_check_to_warn
  * Sets xilinx_tkeep_check_enable to turn off warning/error message when sparse tkeep is
  * being detected in the transaction.
  */
  function void set_xilinx_tkeep_check_to_warn();
    xilinx_tkeep_check_enable = 2'b01;
  endfunction

  /*
  * Function: clr_xilinx_tkeep_check
  * Sets xilinx_tkeep_check_enable to turn off warning/error message when sparse tkeep is
  * being detected in the transaction.
  */
  function void clr_xilinx_tkeep_check();
    xilinx_tkeep_check_enable = 2'b00;
  endfunction

  /*
  * Function: set_enable_xchecks
  * Sets enable_xchecks to turn on error message when reset signal is unknown after 1 cycle of clock.
  */
  function void set_enable_xchecks();
    enable_xchecks = 2'b10;
  endfunction

  /*
  * Function: set_enable_xchecks_to_warn
  * Sets enable_xchecks to downgrade/upgrade into warning message when reset signal is unknown after 1 cycle of clock.
  */
  function void set_enable_xchecks_to_warn();
    enable_xchecks = 2'b01;
  endfunction

  /*
  * Function: clr_enable_xchecks
  * Sets enable_xchecks to downgrade error/warning message into info message when reset signal is unknown after 1 cycle of clock.
  */
  function void clr_enable_xchecks();
    enable_xchecks = 2'b00;
  endfunction

  assign real_reset = !ARESET_N;
  assign reset_for_assert = fake_reset & real_reset;
  initial begin
    fake_reset =0;
    @(posedge ACLK);
    fake_reset =1;
  end

  always @(posedge ACLK) begin
    tkeep_err_cnt =0;
    for(int i=0; i<(C_AXI4STREAM_DATA_WIDTH/8); i++) begin
      if(tkeep_err_cnt ==0) begin
        if(TKEEP_internal[i] & !TKEEP_internal[i+1]) begin
          for(int j= (i+1); j<(C_AXI4STREAM_DATA_WIDTH/8); j++) begin
            if (!TKEEP_internal[j] & TKEEP_internal[j+1] & TVALID) begin
              `REPORT_MACRO(`XILINX_TKEEP_SPARSE,`XILINX_TKEEP_SPARSE_SOL,xilinx_tkeep_check_enable)
              tkeep_err_cnt++;
              break;
            end
          end
        end
      end
    end
  end

   always @(posedge ACLK) begin
     if ($isunknown(ARESET_N)) begin
       `REPORT_MACRO(`ARESET_XCHECK,`ARESET_XCHECK_SOL,enable_xchecks)
     end
   end


  always @(posedge ACLK) begin
    if(reset_for_assert) begin
      reset_cnt =0;
      while(reset_for_assert) begin
        @(posedge ACLK);
        reset_cnt = reset_cnt +1;
      end
      if(reset_cnt <16) begin
        `REPORT_MACRO(`XILINX_RESET_PULSE,`XILINX_RESET_PULSE_SOL,xilinx_reset_check_enable)
      end
    end
  end

  always @(posedge ACLK) begin
    if (~ARESET_N) begin
      beat_count = 0;
      last_count = 0;
    end else if (ACLKEN) begin
      if ((TVALID == 1) && (TREADY_internal == 1)) begin
        beat_count++;
        if ((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_LAST] == 1) && (TLAST_internal == 1)) begin
          last_count++;
        end
      end
    end
  end

  logic                              ACLKEN_O=0;
  logic                              ARESET_N_O=0;
  logic                              TVALID_O;
  logic                              TREADY_O;
  logic                              TLAST_O;
  logic [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_DEST] == 0 ) ? 0 : C_AXI4STREAM_DEST_WIDTH - 1) : 0] TDEST_O;
  logic [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_ID  ] == 0 ) ? 0 : C_AXI4STREAM_ID_WIDTH - 1) : 0] TID_O;
  logic [((C_AXI4STREAM_SIGNAL_SET[XIL_AXI4STREAM_SIGSET_POS_USER] == 0 ) ? 0 : C_AXI4STREAM_USER_WIDTH - 1) : 0] TUSER_O;
  logic [((C_AXI4STREAM_DATA_WIDTH == 0 ) ? 0 : (C_AXI4STREAM_DATA_WIDTH - 1)) :   0] TDATA_O;
  logic [((C_AXI4STREAM_DATA_WIDTH == 0 ) ? 0 : ((C_AXI4STREAM_DATA_WIDTH/8)-1)) : 0] TKEEP_O;
  logic [((C_AXI4STREAM_DATA_WIDTH == 0 ) ? 0 : ((C_AXI4STREAM_DATA_WIDTH/8)-1)) : 0] TSTRB_O;


  default clocking cb @(posedge ACLK_internal);
    default input #1step output #C_HOLD_TIME;
    input   ARESET_N;
    input   ACLKEN;
    inout   TVALID;
    inout   TREADY;
    inout   TDATA;
    inout   TSTRB;
    inout   TKEEP;
    inout   TDEST;
    inout   TID;
    inout   TUSER;
    inout   TLAST;
  endclocking : cb

endinterface : axi4stream_vip_if

`endif
