//  (c) Copyright 2016 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES. 
`ifndef _AXI_VIP_IF_SV_
`define _AXI_VIP_IF_SV_
`timescale 1ps/1ps
import axi_vip_pkg::*;

  `define XILINX_AW_SUPPORTS_NARROW_BURST  "XILINX_AW_SUPPORTS_NARROW_BURST: AW Narrow burst issued from MASTER. Connection has been declared to NOT support narrow bursts."
  `define XILINX_AR_SUPPORTS_NARROW_BURST  "XILINX_AR_SUPPORTS_NARROW_BURST: AR Narrow burst issued from MASTER. Connection has been declared to NOT support narrow bursts."
  `define XILINX_AX_SUPPORTS_NARROW_BURST_SOL  "Use <hierarchy_path>.IF.set_xilinx_supports_narrow_burst_check_to_warn() to downgrade this error message to warning message, use <hierarchy_path>.IF.clr_xilinx_supports_narrow_burst_check() to downgrade this error message to information message.<hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF"

  `define XILINX_RESET_PULSE "XILINX_RESET_PULSE_WIDTH: Holding AXI ARESETN asserted for 16 cycles of the slowest AXI clock is generally a sufficient reset pulse width for Xilinx IP. --UG1037."
  `define XILINX_RESET_PULSE_SOL "Use <hierarchy_path>.IF.set_xilinx_reset_check_to_warn() to downgrade this error message to warning message, use <hierarchy_path>.IF.clr_xilinx_reset_check() to downgrade this error message to information message.<hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF"

  `define  XILINX_NO_STRB_ADDRESS "XILINX_NO_STRB_ADDRESS: Address is not aligned with data width. Connection has been declared to No STRB."
  `define  XILINX_NO_STRB_ADDRESS_SOL "Use <hierarchy_path>.IF.set_xilinx_no_strb_address_check_to_warn() to downgrade this error message to warning message, use <hierarchy_path>.IF.clr_xilinx_no_strb_address_check() to downgrade this error message to information message.<hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF.x"

  `define XILINX_AWREADY_RESET "XILINX_AWREADY_RESET: AWREADY must be low for the first clock edge that ARESETn goes high--PG101 XILINX_AWREADY_RESET."
  `define XILINX_ARREADY_RESET "XILINX_ARREADY_RESET: ARREADY must be low for the first clock edge that ARESETn goes high--PG101 XILINX_ARREADY_RESET."
  `define XILINX_WREADY_RESET "XILINX_WREADY_RESET: WREADY must be low for the first clock edge that ARESETn goes high--PG101 XILINX_WREADY_RESET."
  `define XILINX_XREADY_RESET_SOL "Use <hierarchy_path>.IF.clr_xilinx_slave_ready_check to downgrade the warning message to information message.<hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF"

  `define XILINX_WREADY_MAX_RESET "XILINX_WREADY_MAX_RESET: WREADY must go low after 8 cycles following the first clock edge that ARESETn goes low--UG1037 Xilinx IP generally deasserts all VALID and READY outputs within eight cycles of reset."
  `define XILINX_ARREADY_MAX_RESET "XILINX_ARREADY_MAX_RESET: ARREADY must go low after 8 cycles following the first clock edge that ARESETn goes low--UG1037 Xilinx IP generally deasserts all VALID and READY outputs within eight cycles of reset."
  `define XILINX_AWREADY_MAX_RESET "XILINX_AWREADY_MAX_RESET: AWREADY must go low after 8 cycles following the first clock edge that ARESETn goes low--UG1037 Xilinx IP generally deasserts all VALID and READY outputs within eight cycles of reset."
   `define XILINX_AR_SUPPORTS_NARROW_CACHE    "XILINX_AR_SUPPORTS_NARROW_CACHE: AR Non-modifiable burst issued from MASTER. Connection has been declared to NOT support narrow bursts."
    `define XILINX_AW_SUPPORTS_NARROW_CACHE    "XILINX_AW_SUPPORTS_NARROW_CACHE: AW Non-modifiable burst issued from MASTER. Connection has been declared to NOT support narrow bursts."
   `define XILINX_AX_SUPPORTS_NARROW_CACHE_SOL    "Use <hierarchy_path>.IF.clr_xilinx_supports_narrow_cache_check to downgrade the warning message to information message.<hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF"

   `define ARESET_XCHECK "ARESET_XCHECK: ARESET_N can't be X/Z after 1 cycle of clock."
   `define ARESET_XCHECK_SOL "Use <hierarchy_path>.IF.set_enable_xchecks_to_warn  to downgrade error message to warning message.Use <hierarchy_path>.IF.clr_enable_xchecks to downgrade error message to information message, <hierarchy_path> shown at the begining of this message in the format of x.x.inst.IF"

   //SEV_NUM is in this order to match legacy APIs
`define REPORT_MACRO(MSG,SOL,SEV_NUM) \
  if(SEV_NUM ==2'b00) $display("INFO: %0t %m : %s",$realtime, MSG); \
  else if(SEV_NUM ==2'b01) $display("WARNING: %0t %m : %s %s",$realtime,MSG,SOL); \
  else if (SEV_NUM ==2'b10) $display("ERROR: %0t %m  : %s %s",$realtime,MSG,SOL); \
 


`define RESET_EIGHT_PULSE(CLK,RST,SUPPORT,CLKEN,READY,MESSAGE,SOL,ENABLE) \
  always @(posedge CLK) begin :``READY``_eight_cycle_chk \
    if((RST ==0) && (SUPPORT ==1) && (CLKEN ==1)) begin \
      repeat(7) @(posedge CLK); \
      while((RST ==0) && (SUPPORT ==1) && (CLKEN ==1)) begin \
        if((READY ==1)) begin \
          `REPORT_MACRO(MESSAGE,SOL,ENABLE) \
        end \
        @(posedge CLK); \
      end \
    end \
  end  \

`define RESET_ONE_PULSE(CLK,RST,SUPPORT,CLKEN,CNT,READY,MESSAGE,SOL,ENABLE) \
  always @(posedge CLK) begin :``READY``_one_cycle_chk \
    if((RST==1) && (SUPPORT ==1) && (CLKEN ==1)) begin \
      CNT =0; \
      while((RST==1) && (SUPPORT ==1) && (CLKEN ==1)) begin \
        if((CNT ==0) &&(READY ==1)) begin \
          `REPORT_MACRO(MESSAGE,SOL,ENABLE) \
        CNT = CNT +1; \
        end else begin \
        CNT = CNT +1; \
        end \
        @(posedge CLK); \
      end \
    end \
  end  \



interface axi_vip_if #(
  int C_AXI_PROTOCOL              = 0, 
      C_AXI_ADDR_WIDTH            = 32, 
      C_AXI_WDATA_WIDTH           = 32, 
      C_AXI_RDATA_WIDTH           = 32, 
      C_AXI_WID_WIDTH             = 0,
      C_AXI_RID_WIDTH             = 0, 
      C_AXI_AWUSER_WIDTH          = 0, 
      C_AXI_WUSER_WIDTH           = 0, 
      C_AXI_BUSER_WIDTH           = 0, 
      C_AXI_ARUSER_WIDTH          = 0, 
      C_AXI_RUSER_WIDTH           = 0,
      C_AXI_SUPPORTS_NARROW       = 1,
      C_AXI_HAS_BURST             = 1,
      C_AXI_HAS_LOCK              = 1,
      C_AXI_HAS_CACHE             = 1,
      C_AXI_HAS_REGION            = 1,
      C_AXI_HAS_PROT              = 1,
      C_AXI_HAS_QOS               = 1,
      C_AXI_HAS_WSTRB             = 1,
      C_AXI_HAS_BRESP             = 1,
      C_AXI_HAS_RRESP             = 1,
      C_AXI_HAS_ARESETN           = 1
  ) 
  (input logic ACLK, ACLKEN, ARESET_N);
  parameter time C_HOLD_TIME        = 1ps;
  parameter integer C_MAXRBURSTS    = 64;
  parameter integer C_MAXWBURSTS    = 64;
  parameter integer C_MAXWAITS      = 64;
  parameter integer C_MAXSTALLWAITS = 1024;

  // write address channel
  wire  [(C_AXI_ADDR_WIDTH-1):0]                                          AWADDR;
  wire  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  AWID;
  wire  [7:0]                                                             AWLEN;
  wire  [2:0]                                                             AWSIZE;
  wire  [1:0]                                                             AWBURST;
  wire  [1:0]                                                             AWLOCK;
  wire  [3:0]                                                             AWCACHE;
  wire  [2:0]                                                             AWPROT;
  wire                                                                    AWVALID;
  wire                                                                    AWREADY;
  wire  [3:0]                                                             AWREGION;
  wire  [3:0]                                                             AWQOS;
  wire  [((C_AXI_AWUSER_WIDTH == 0) ? 0 : C_AXI_AWUSER_WIDTH -1):0]       AWUSER;

  // write data channel
  wire  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  WID;
  wire                                                                    WLAST;
  wire  [(C_AXI_WDATA_WIDTH-1):0]                                         WDATA;
  wire  [(C_AXI_WDATA_WIDTH/8 ==0 ? 0: C_AXI_WDATA_WIDTH/8)-1:0]          WSTRB;
  wire                                                                    WVALID;
  wire                                                                    WREADY;
  wire  [((C_AXI_WUSER_WIDTH == 0) ? 0 : C_AXI_WUSER_WIDTH -1):0]         WUSER;

  // write response channel
  wire  [1:0]                                                             BRESP;
  wire  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  BID;
  wire                                                                    BVALID;
  wire                                                                    BREADY;
  wire  [((C_AXI_BUSER_WIDTH == 0) ? 0 : C_AXI_BUSER_WIDTH -1):0]         BUSER;

  // read address channel
  wire  [(C_AXI_ADDR_WIDTH-1):0]                                          ARADDR;
  wire  [((C_AXI_RID_WIDTH==0) ? 1:C_AXI_RID_WIDTH)-1:0]                  ARID;
  wire  [7:0]                                                             ARLEN;
  wire  [2:0]                                                             ARSIZE;
  wire  [1:0]                                                             ARBURST;
  wire  [1:0]                                                             ARLOCK;
  wire  [3:0]                                                             ARCACHE;
  wire  [2:0]                                                             ARPROT;
  wire                                                                    ARVALID;
  wire                                                                    ARREADY;
  wire  [3:0]                                                             ARREGION;
  wire  [3:0]                                                             ARQOS;
  wire  [((C_AXI_ARUSER_WIDTH == 0) ? 0 : C_AXI_ARUSER_WIDTH -1):0]       ARUSER;

  // read data  channel
  wire  [((C_AXI_RID_WIDTH==0) ? 1:C_AXI_RID_WIDTH)-1:0]                  RID;
  wire                                                                    RLAST;
  wire  [(C_AXI_RDATA_WIDTH-1):0]                                         RDATA;
  wire  [1:0]                                                             RRESP;
  wire                                                                    RVALID;
  wire                                                                    RREADY;
  wire  [((C_AXI_RUSER_WIDTH == 0) ? 0 : C_AXI_RUSER_WIDTH -1):0]         RUSER;

  integer unsigned  awcmd_id = 0;
  integer unsigned  arcmd_id = 0;
  integer unsigned  rcmd_id = 0;
  integer unsigned  wcmd_id = 0;
  integer unsigned  bcmd_id = 0;
  logic intf_is_master = 0;
  logic intf_is_slave  = 0;

  logic supports_write = 1;
  logic supports_read = 1;
  logic [1:0] xilinx_slave_ready_check_enable = 2'b01;
  logic [1:0] xilinx_reset_check_enable = 2'b10;
  logic [1:0] xilinx_supports_narrow_cache_check_enable = 2'b01;
  logic [1:0] xilinx_supports_narrow_burst_check_enable = 2'b10;
  logic [1:0] xilinx_no_strb_address_check_enable = 2'b10;
  logic [1:0] enable_xchecks = 2'b10;

  integer reset_cnt;
  integer awready_one_pulse_cnt;
  integer wready_one_pulse_cnt;
  integer arready_one_pulse_cnt;

  logic  aw_burst_report_set =1;
  logic  ar_burst_report_set =1;
  logic  aw_cache_report_set =1;
  logic  ar_cache_report_set =1;
  logic  strb_report_set =1;
  logic fake_reset;
  logic real_reset;
  logic reset_for_assert;


  /*
  * Function: set_supports_write
  * Sets supports_write to be 1, when supports_write is being set, ARM protocol Checker will check AW/W channel  
  */
  function void set_supports_write();
    supports_write = 1;
  endfunction

  /*
  * Function: clr_supports_write
  * Sets supports_write to be 0, when supports_write is not being set, ARM protocol Checker will not check AW/W channel 
  */
  function void clr_supports_write();
    supports_write = 0;
  endfunction

  /*
  * Function: set_supports_read
  * Sets supports_read to be 1, when supports_read is being set, ARM protocol Checker will check AR/R channel 
  */
  function void set_supports_read();
    supports_read = 1;
  endfunction

  /*
  * Function: clr_supports_read
  * Sets supports_read to be 0,when supports_read is not being set, ARM protocol Checker will not check AR/R channel
  */
  function void clr_supports_read();
    supports_read = 0;
  endfunction

 /*
  *  Function: set_xilinx_slave_ready_check
  *  Sets xilinx_slave_ready_check_enable to turn on warning message when there is a violation of rules which arready/awready/wready 
  *  should follow when the VIP goes into reset mode or comes out of reset mode. Which are 
  *  1).any READY must be low for the first clock edge that ARESETn goes high--PG101 XILINX_READY_RESET
  *  2).READY must go low after 8 cycles following the first clock edge that ARESETn goes low--UG1037 Xilinx IP
  *    generally deasserts all VALID and READY outputs within eight cycles of reset.
  */
  function void set_xilinx_slave_ready_check();
    xilinx_slave_ready_check_enable = 2'b01;
  endfunction

  /*
  * Function: clr_xilinx_slave_ready_check
  * Sets xilinx_slave_ready_check_enable to turn off warning message when there is a violation of rules which arready/awready/wready 
  * should follow when the VIP goes into reset mode or comes out of reset mode.Which are 
  *  1).any READY must be low for the first clock edge that ARESETn goes high--PG101 XILINX_READY_RESET
  *  2).READY must go low after 8 cycles following the first clock edge that ARESETn goes low--UG1037 Xilinx IP
  *    generally deasserts all VALID and READY outputs within eight cycles of reset.
  */
  function void clr_xilinx_slave_ready_check();
    xilinx_slave_ready_check_enable = 2'b00;
  endfunction

  
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
  *  Function: set_xilinx_supports_narrow_burst_check
  *  Sets xilinx_supports_narrow_burst_check_enable to turn on error message when a narrow burst is being
  *  detected while this VIP is in not support narrow burst mode.
  */
  function void set_xilinx_supports_narrow_burst_check();
    xilinx_supports_narrow_burst_check_enable = 2'b10;
  endfunction

  /*
  * Function: set_xilinx_supports_narrow_burst_check_to_warn
  * Sets xilinx_supports_narrow_burst_check_enable to downgrade/upgrade to warning message when a narrow burst 
  * is being detected while this VIP is in not support narrow burst mode.
  */
  function void set_xilinx_supports_narrow_burst_check_to_warn();
    xilinx_supports_narrow_burst_check_enable = 2'b01;
  endfunction

  /*
  * Function: clr_xilinx_supports_narrow_burst_check
  * Sets xilinx_supports_narrow_burst_check_enable to downgrade error/warning into info message when a narrow burst 
  * is being detected while this VIP is in not support narrow burst mode.
  */
  function void clr_xilinx_supports_narrow_burst_check();
    xilinx_supports_narrow_burst_check_enable = 2'b00;
  endfunction

 /*
  *  Function: set_xilinx_no_strb_address_check
  *  Sets xilinx_no_strb_address_check_enable to turn on error message when address is being detected not aligned with 
  *  data width while this VIP is in no strobe mode. 
  */
  function void set_xilinx_no_strb_address_check();
    xilinx_no_strb_address_check_enable = 2'b10;
  endfunction

 /*
  * Function: set_xilinx_no_strb_address_check_to_warn
  * Sets xilinx_no_strb_address_check_enable to downgrade/upgrade to warning message when address is being detected 
  * not aligned with data width while this VIP is in no strobe mode. 
  */
  function void set_xilinx_no_strb_address_check_to_warn();
    xilinx_no_strb_address_check_enable = 2'b01;
  endfunction

  /*
  * Function: clr_xilinx_no_strb_address_check
  * Sets xilinx_no_strb_address_check_enable to downgrade error/warning into info message when address is being detected 
  * not aligned with data width while this VIP is in no strobe mode. 
  */
  function void clr_xilinx_no_strb_address_check();
    xilinx_no_strb_address_check_enable = 2'b00;
  endfunction


  /*
  *  Function: set_xilinx_supports_narrow_cache_check
  *  Sets xilinx_supports_narrow_cache_check_enable to turn on warning message when Cache[1] is not 1 while VIP is in
  *  no supports_narrow, has_cache mode.
  */
  function void set_xilinx_supports_narrow_cache_check();
    xilinx_supports_narrow_cache_check_enable = 2'b01;
  endfunction

  /*
  * Function: clr_xilinx_supports_narrow_cache_check
  * Sets xilinx_supports_narrow_cache_check_enable to downgrade warning into info message when Cache[1] is not 1
  * while VIP is in no supports_narrow, has_cache mode.
  */
  function void clr_xilinx_supports_narrow_cache_check();
    xilinx_supports_narrow_cache_check_enable = 2'b00;
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

  // Internal ports 
  bit                                                                      areset_n;
  bit                                                                      aclk;

  // write address channel
  logic  [(C_AXI_ADDR_WIDTH-1):0]                                          awaddr;
  logic  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  awid;
  logic  [7:0]                                                             awlen;
  logic  [2:0]                                                             awsize;
  logic  [1:0]                                                             awburst;
  logic  [1:0]                                                             awlock;
  logic  [3:0]                                                             awcache;
  logic  [2:0]                                                             awprot;
  logic                                                                    awvalid = 1'b0;
  logic                                                                    awready = 1'b0;
  logic  [3:0]                                                             awregion;
  logic  [3:0]                                                             awqos;
  logic  [((C_AXI_AWUSER_WIDTH == 0) ? 0 : C_AXI_AWUSER_WIDTH -1):0]       awuser;

  // write data channel
  logic  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  wid;
  logic                                                                    wlast;
  logic  [(C_AXI_WDATA_WIDTH-1):0]                                         wdata;
  logic  [(C_AXI_WDATA_WIDTH/8)-1:0]                                       wstrb;
  logic                                                                    wvalid = 1'b0;
  logic                                                                    wready = 1'b0;
  logic  [((C_AXI_WUSER_WIDTH == 0) ? 0 : C_AXI_WUSER_WIDTH -1):0]         wuser;

  // write response channel
  logic  [1:0]                                                             bresp;
  logic  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  bid;
  logic                                                                    bvalid = 1'b0;
  logic                                                                    bready = 1'b0;
  logic  [((C_AXI_BUSER_WIDTH == 0) ? 0 : C_AXI_BUSER_WIDTH -1):0]         buser;

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // read address channel
  logic  [(C_AXI_ADDR_WIDTH-1):0]                                          araddr;
  logic  [((C_AXI_RID_WIDTH==0) ? 1:C_AXI_RID_WIDTH)-1:0]                  arid;
  logic  [7:0]                                                             arlen;
  logic  [2:0]                                                             arsize;
  logic  [1:0]                                                             arburst;
  logic  [1:0]                                                             arlock;
  logic  [3:0]                                                             arcache;
  logic  [2:0]                                                             arprot;
  logic                                                                    arvalid = 1'b0;
  logic                                                                    arready = 1'b0;
  logic  [3:0]                                                             arregion;
  logic  [3:0]                                                             arqos;
  logic  [((C_AXI_ARUSER_WIDTH == 0) ? 0 : C_AXI_ARUSER_WIDTH -1):0]       aruser;

  // read data  channel
  logic  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  rid;
  logic                                                                    rlast;
  logic  [(C_AXI_RDATA_WIDTH-1):0]                                         rdata;
  logic  [1:0]                                                             rresp;
  logic                                                                    rvalid = 1'b0;
  logic                                                                    rready = 1'b0;
  logic  [((C_AXI_RUSER_WIDTH == 0) ? 0 : C_AXI_RUSER_WIDTH -1):0]         ruser;

  /*
  *  Function: set_intf_slave
  *  Sets interface to runtime slave mode.When user wants to change passthrough VIP as slave VIP, what they do is to call
  *  <hierarchy_path>.IF.set_intf_slave 
  */
  function void set_intf_slave();
    intf_is_master = 0;
    intf_is_slave = 1;
  endfunction : set_intf_slave

  /*
  *  Function: set_intf_master
  *  Sets interface to runtime master mode. When user wants to change passthrough VIP as master VIP, what they do is to call
  *  <hierarchy_path>.IF.set_intf_master 
  */
  function void set_intf_master();
    intf_is_master = 1;
    intf_is_slave = 0;
  endfunction : set_intf_master

  /*
  *  Function: set_intf_monitor
  *  Sets interface to runtime monitor mode. Set VIP into runtime passthrough mode.
  *  what they do is to call <hierarchy_path>.IF.set_intf_monitor
  */
  function void set_intf_monitor();
    intf_is_master = 0;
    intf_is_slave = 0;
  endfunction : set_intf_monitor

  assign areset_n = ARESET_N;
  assign aclk     = ACLK;
  assign AWADDR   = intf_is_master ? awaddr   : 'z;
  assign AWID     =  ((C_AXI_PROTOCOL == 2) || (C_AXI_WID_WIDTH == 0)) ? 1'b0 : intf_is_master ? awid     : 'z;
  assign AWLEN    = intf_is_master ? awlen    : 'z;
  assign AWSIZE   = intf_is_master ? awsize   : 'z;
  assign AWBURST  = intf_is_master ? awburst  : 'z;
  assign AWLOCK   = intf_is_master ? awlock   : 'z;
  assign AWCACHE  = intf_is_master ? awcache  : 'z;
  assign AWPROT   = intf_is_master ? awprot   : 'z;
  assign AWVALID  = intf_is_master ? awvalid  : 'z;
  assign AWREADY  = intf_is_slave  ? awready  : 'z;
  assign AWREGION = intf_is_master ? awregion : 'z;
  assign AWQOS    = intf_is_master ? awqos    : 'z;
  assign AWUSER   = (C_AXI_AWUSER_WIDTH == 0) ? 1'b0 : intf_is_master ? awuser   : 'z;
  assign WID      =  ((C_AXI_PROTOCOL == 2) || (C_AXI_WID_WIDTH == 0)) ? 1'b0 : intf_is_master ? wid      : 'z;
  assign WLAST    = intf_is_master ? wlast    : 'z;
  assign WDATA    = intf_is_master ? wdata    : 'z;
  assign WSTRB    = intf_is_master ? wstrb    : 'z;
  assign WVALID   = intf_is_master ? wvalid   : 'z;
  assign WREADY   = intf_is_slave  ? wready   : 'z;
  assign WUSER    = (C_AXI_WUSER_WIDTH == 0) ? 1'b0 :intf_is_master ? wuser   : 'z;
  assign BRESP    = intf_is_slave  ? bresp    : 'z;
  assign BID      = ((C_AXI_PROTOCOL == 2) || (C_AXI_WID_WIDTH == 0)) ? 1'b0 : intf_is_slave  ? bid      : 'z;
  assign BVALID   = intf_is_slave  ? bvalid   : 'z;
  assign BREADY   = intf_is_master ? bready   : 'z;
  assign BUSER    = (C_AXI_BUSER_WIDTH == 0)  ? 1'b0 : intf_is_slave  ? buser   : 'z;
  assign ARADDR   = intf_is_master ? araddr   : 'z;
  assign ARID     = ((C_AXI_PROTOCOL == 2) || (C_AXI_RID_WIDTH == 0)) ? 1'b0 : intf_is_master ? arid     : 'z;
  assign ARLEN    = intf_is_master ? arlen    : 'z;
  assign ARSIZE   = intf_is_master ? arsize   : 'z;
  assign ARBURST  = intf_is_master ? arburst  : 'z;
  assign ARLOCK   = intf_is_master ? arlock   : 'z;
  assign ARCACHE  = intf_is_master ? arcache  : 'z;
  assign ARPROT   = intf_is_master ? arprot   : 'z;
  assign ARVALID  = intf_is_master ? arvalid  : 'z;
  assign ARREADY  = intf_is_slave  ? arready  : 'z;
  assign ARREGION = intf_is_master ? arregion : 'z;
  assign ARQOS    = intf_is_master ? arqos    : 'z;
  assign ARUSER   = (C_AXI_ARUSER_WIDTH == 0) ? 1'b0 : intf_is_master ? aruser   : 'z;
  assign RID      = ((C_AXI_PROTOCOL == 2) || (C_AXI_RID_WIDTH == 0)) ? 1'b0 : intf_is_slave  ? rid      : 'z;
  assign RLAST    = intf_is_slave  ? rlast    : 'z;
  assign RDATA    = intf_is_slave  ? rdata    : 'z;
  assign RRESP    = intf_is_slave  ? rresp    : 'z;
  assign RVALID   = intf_is_slave  ? rvalid   : 'z;
  assign RREADY   = intf_is_master ? rready   : 'z;
  assign RUSER    = (C_AXI_RUSER_WIDTH == 0) ? 1'b0 :intf_is_slave  ? ruser   : 'z;

  wire   awready_internal = (supports_write == 0) ? 1'b0 : AWREADY;
  wire   arready_internal = (supports_read == 0)  ? 1'b0 : ARREADY;
  wire   wready_internal  = (supports_write == 0) ? 1'b0 : WREADY;
  wire   rready_internal  = (supports_read == 0)  ? 1'b0 : RREADY;
  wire   bready_internal  = (supports_write == 0) ? 1'b0 : BREADY;
  wire   awvalid_internal = (supports_write == 0) ? 1'b0 : AWVALID;
  wire   arvalid_internal = (supports_read == 0)  ? 1'b0 : ARVALID;
  wire   wvalid_internal  = (supports_write == 0) ? 1'b0 : WVALID;
  wire   rvalid_internal  = (supports_read == 0)  ? 1'b0 : RVALID;
  wire   bvalid_internal  = (supports_write == 0) ? 1'b0 : BVALID;

  wire  [((C_AXI_RID_WIDTH==0) ? 1:C_AXI_RID_WIDTH)-1:0]      arid_internal;
  wire  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]      wid_internal;
  wire  [((C_AXI_RID_WIDTH==0) ? 1:C_AXI_RID_WIDTH)-1:0]      rid_internal;
  wire  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]      awid_internal;
  wire  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]      bid_internal;

  assign arid_internal  = (C_AXI_RID_WIDTH==0) ? 1'b0 : ARID;
  assign wid_internal   = (C_AXI_WID_WIDTH==0) ? 1'b0 : WID;
  assign rid_internal   = (C_AXI_RID_WIDTH==0) ? 1'b0 : RID;
  assign awid_internal  = (C_AXI_WID_WIDTH==0) ? 1'b0 : AWID;
  assign bid_internal   = (C_AXI_WID_WIDTH==0) ? 1'b0 : BID;

  localparam  LP_ADDR_WIDTH = (C_AXI_ADDR_WIDTH > 12) ? C_AXI_ADDR_WIDTH : 13;
  wire [LP_ADDR_WIDTH-1:0] scaled_awaddr = {LP_ADDR_WIDTH{1'b0}} | AWADDR[C_AXI_ADDR_WIDTH-1:0];
  wire [LP_ADDR_WIDTH-1:0] scaled_araddr = {LP_ADDR_WIDTH{1'b0}} | ARADDR[C_AXI_ADDR_WIDTH-1:0];
  wire aclk_internal = (ACLKEN == 1'b0) ? 1'b0 : aclk;

  wire        wlast_internal  = (C_AXI_PROTOCOL == 2) ? 1'b1 : WLAST;
  wire        rlast_internal  = (C_AXI_PROTOCOL == 2) ? 1'b1 : RLAST;

  wire [7:0]  awlen_internal  = (C_AXI_PROTOCOL == 0) ? AWLEN :
                                (C_AXI_PROTOCOL == 1) ? {4'h0,AWLEN[3:0]} :
                                8'h00;
  wire [7:0]  arlen_internal  = (C_AXI_PROTOCOL == 0) ? ARLEN :
                                (C_AXI_PROTOCOL == 1) ? {4'h0,ARLEN[3:0]} :
                                8'h00;
  wire [3:0]  arregion_internal = (C_AXI_PROTOCOL == 0) ? ARREGION :
                                  (C_AXI_PROTOCOL == 1) ? 4'h0 :
                                  4'h0;
  wire [3:0]  awregion_internal = (C_AXI_PROTOCOL == 0) ? AWREGION :
                                  (C_AXI_PROTOCOL == 1) ? 4'h0 :
                                  4'h0;
  wire [3:0]  arqos_internal =  (C_AXI_PROTOCOL == 0) ? ARQOS :
                                (C_AXI_PROTOCOL == 1) ? 4'h0 :
                                4'h0;
  wire [3:0]  awqos_internal =  (C_AXI_PROTOCOL == 0) ? AWQOS :
                                (C_AXI_PROTOCOL == 1) ? 4'h0 :
                                4'h0;
  wire [1:0]  awlock_internal = (C_AXI_PROTOCOL == 0) ? {1'b0,AWLOCK[0]} :
                                (C_AXI_PROTOCOL == 1) ? AWLOCK :
                                2'h0;
  wire [1:0]  arlock_internal = (C_AXI_PROTOCOL == 0) ? {1'b0,ARLOCK[0]} :
                                (C_AXI_PROTOCOL == 1) ? ARLOCK :
                                2'h0;
  wire [1:0]  awburst_internal =  (C_AXI_PROTOCOL == 0) ? AWBURST :
                                  (C_AXI_PROTOCOL == 1) ? AWBURST :
                                  2'h0;
  wire [1:0]  arburst_internal =  (C_AXI_PROTOCOL == 0) ? ARBURST :
                                  (C_AXI_PROTOCOL == 1) ? ARBURST :
                                  2'h0;
  wire [3:0]  awcache_internal =  (C_AXI_PROTOCOL == 0) ? AWCACHE :
                                  (C_AXI_PROTOCOL == 1) ? AWCACHE :
                                  4'h0;
  wire [3:0]  arcache_internal =  (C_AXI_PROTOCOL == 0) ? ARCACHE :
                                  (C_AXI_PROTOCOL == 1) ? ARCACHE :
                                  4'h0;
  wire [2:0]  awsize_internal = (C_AXI_PROTOCOL == 0) ? AWSIZE :
                                (C_AXI_PROTOCOL == 1) ? AWSIZE :
                                (C_AXI_WDATA_WIDTH == 32 ? 3'b010 : 3'b011);
  wire [2:0]  arsize_internal = (C_AXI_PROTOCOL == 0) ? ARSIZE :
                                (C_AXI_PROTOCOL == 1) ? ARSIZE :
                                (C_AXI_RDATA_WIDTH == 32 ? 3'b010 : 3'b011);

`ifndef XILINX_SIMULATOR
  axi_vip_axi4pc #(
    .PROTOCOL         (C_AXI_PROTOCOL),
    .WADDR_WIDTH      (LP_ADDR_WIDTH), 
    .RADDR_WIDTH      (LP_ADDR_WIDTH),
    .RDATA_WIDTH      (C_AXI_RDATA_WIDTH),
    .WDATA_WIDTH      (C_AXI_WDATA_WIDTH),
    .RID_WIDTH        (C_AXI_WID_WIDTH),
    .WID_WIDTH        (C_AXI_RID_WIDTH),
    .AWUSER_WIDTH     (C_AXI_AWUSER_WIDTH ),
    .WUSER_WIDTH      (C_AXI_WUSER_WIDTH  ),
    .BUSER_WIDTH      (C_AXI_BUSER_WIDTH  ),
    .ARUSER_WIDTH     (C_AXI_ARUSER_WIDTH ),
    .RUSER_WIDTH      (C_AXI_RUSER_WIDTH  ),
    .MAXRBURSTS       ( C_MAXRBURSTS ),
    .MAXWBURSTS       ( C_MAXWBURSTS ),
    .MAXWAITS         ( C_MAXWAITS ),
    .MAXSTALLWAITS    ( C_MAXSTALLWAITS ),
    .RecommendOn      ( 1  ),
    .RecMaxWaitOn     ( 0  ),
    .HAS_ARESETN      ( C_AXI_HAS_ARESETN)
  ) PC (
    .ACLK               (aclk_internal), 
    .ACLKEN             (ACLKEN),
    .ARESETn            (areset_n),
    .AWADDR             (scaled_awaddr),
    .AWID               (awid_internal   ),
    .AWLEN              (awlen_internal  ),
    .AWSIZE             (awsize_internal ),
    .AWBURST            (awburst_internal),
    .AWLOCK             (awlock_internal[0]),
    .AWCACHE            (awcache_internal),
    .AWPROT             (AWPROT ),
    .AWVALID            (awvalid_internal),
    .AWREADY            (awready_internal),
    .AWREGION           (awregion_internal),
    .AWQOS              (awqos_internal),
    .AWUSER             (AWUSER ),

    .WLAST              (wlast_internal ),
    .WDATA              (WDATA ),
    .WSTRB              (WSTRB ),
    .WVALID             (wvalid_internal),
    .WREADY             (wready_internal),
    .WUSER              (WUSER ),

    .BRESP              (BRESP ),
    .BID                (bid_internal   ),
    .BVALID             (bvalid_internal),
    .BREADY             (bready_internal),
    .BUSER              (BUSER ),

    .ARADDR             (scaled_araddr ),
    .ARID               (arid_internal   ),
    .ARLEN              (arlen_internal  ),
    .ARSIZE             (arsize_internal ),
    .ARBURST            (arburst_internal),
    .ARLOCK             (arlock_internal[0]),
    .ARCACHE            (arcache_internal),
    .ARPROT             (ARPROT ),
    .ARVALID            (arvalid_internal),
    .ARREADY            (arready_internal),
    .ARREGION           (arregion_internal),
    .ARQOS              (arqos_internal),
    .ARUSER             (ARUSER ),

    .RID                (rid_internal   ),
    .RLAST              (rlast_internal ),
    .RDATA              (RDATA ),
    .RRESP              (RRESP ),
    .RVALID             (rvalid_internal),
    .RREADY             (rready_internal),
    .RUSER              (RUSER ),
    
    .CACTIVE            ( 1'b1 ),
    .CSYSREQ            ( 1'b1 ),
    .CSYSACK            ( 1'b1 )
  ); 
`endif    
    
`ifdef XILINX_SIMULATOR
  logic                                                                    ACLKEN_O=0;
  logic                                                                    ARESET_N_O=0;
  logic  [(C_AXI_ADDR_WIDTH-1):0]                                          AWADDR_O;
  logic  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  AWID_O;
  logic  [7:0]                                                             AWLEN_O;
  logic  [2:0]                                                             AWSIZE_O;
  logic  [1:0]                                                             AWBURST_O;
  logic  [1:0]                                                             AWLOCK_O;
  logic  [3:0]                                                             AWCACHE_O;
  logic  [2:0]                                                             AWPROT_O;
  logic                                                                    AWVALID_O;
  logic                                                                    AWREADY_O;
  logic  [3:0]                                                             AWREGION_O;
  logic  [3:0]                                                             AWQOS_O;
  logic  [((C_AXI_AWUSER_WIDTH == 0) ? 0 : C_AXI_AWUSER_WIDTH -1):0]       AWUSER_O;

  // write data channel
  logic  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  WID_O;
  logic                                                                    WLAST_O;
  logic  [(C_AXI_WDATA_WIDTH-1):0]                                         WDATA_O;
  logic  [(C_AXI_WDATA_WIDTH/8 ==0 ? 0: C_AXI_WDATA_WIDTH/8)-1:0]          WSTRB_O;
  logic                                                                    WVALID_O;
  logic                                                                    WREADY_O;
  logic  [((C_AXI_WUSER_WIDTH == 0) ? 0 : C_AXI_WUSER_WIDTH -1):0]         WUSER_O;

  // write response channel
  logic  [1:0]                                                             BRESP_O;
  logic  [((C_AXI_WID_WIDTH==0) ? 1:C_AXI_WID_WIDTH)-1:0]                  BID_O;
  logic                                                                    BVALID_O;
  logic                                                                    BREADY_O;
  logic  [((C_AXI_BUSER_WIDTH == 0) ? 0 : C_AXI_BUSER_WIDTH -1):0]         BUSER_O;

  // read address channel
  logic  [(C_AXI_ADDR_WIDTH-1):0]                                          ARADDR_O;
  logic  [((C_AXI_RID_WIDTH==0) ? 1:C_AXI_RID_WIDTH)-1:0]                  ARID_O;
  logic  [7:0]                                                             ARLEN_O;
  logic  [2:0]                                                             ARSIZE_O;
  logic  [1:0]                                                             ARBURST_O;
  logic  [1:0]                                                             ARLOCK_O;
  logic  [3:0]                                                             ARCACHE_O;
  logic  [2:0]                                                             ARPROT_O;
  logic                                                                    ARVALID_O;
  logic                                                                    ARREADY_O;
  logic  [3:0]                                                             ARREGION_O;
  logic  [3:0]                                                             ARQOS_O;
  logic  [((C_AXI_ARUSER_WIDTH == 0) ? 0 : C_AXI_ARUSER_WIDTH -1):0]       ARUSER_O;

  // read data  channel
  logic  [((C_AXI_RID_WIDTH==0) ? 1:C_AXI_RID_WIDTH)-1:0]                  RID_O;
  logic                                                                    RLAST_O;
  logic  [(C_AXI_RDATA_WIDTH-1):0]                                         RDATA_O;
  logic  [1:0]                                                             RRESP_O;
  logic                                                                    RVALID_O;
  logic                                                                    RREADY_O;
  logic  [((C_AXI_RUSER_WIDTH == 0) ? 0 : C_AXI_RUSER_WIDTH -1):0]         RUSER_O;

  always @(posedge aclk) begin
    ARESET_N_O  <= #1 areset_n;
    ACLKEN_O   <= #1 ACLKEN;
    AWADDR_O   <= #1 AWADDR;
    AWID_O     <= #1 AWID ;
    AWLEN_O    <= #1 AWLEN ;
    AWSIZE_O   <= #1 AWSIZE ;
    AWBURST_O  <= #1 AWBURST;
    AWLOCK_O   <= #1 AWLOCK;
    AWCACHE_O  <= #1 AWCACHE;
    AWPROT_O   <= #1 AWPROT;
    AWVALID_O  <= #1 AWVALID;
    AWREADY_O  <= #1 AWREADY;
    AWREGION_O <= #1 AWREGION;
    AWQOS_O    <= #1 AWQOS ;
    AWUSER_O  <= #1 AWUSER;

  // write data channel
    WID_O      <= #1 WID;
    WLAST_O    <= #1 WLAST;
    WDATA_O    <= #1 WDATA;
    WSTRB_O    <= #1 WSTRB;
    WVALID_O   <= #1 WVALID;
    WREADY_O   <= #1 WREADY;
    WUSER_O    <= #1 WUSER;

  // write response channel
    BRESP_O    <= #1 BRESP;
    BID_O      <= #1 BID;
    BVALID_O   <= #1 BVALID;
    BREADY_O   <= #1 BREADY;
    BUSER_O    <= #1 BUSER;

  // read address channel
    ARADDR_O   <= #1 ARADDR ;
    ARID_O     <= #1 ARID;
    ARLEN_O    <= #1 ARLEN;
    ARSIZE_O   <= #1 ARSIZE;
    ARBURST_O  <= #1 ARBURST ;
    ARLOCK_O   <= #1 ARLOCK;
    ARCACHE_O  <= #1 ARCACHE;
    ARPROT_O   <= #1 ARPROT;
    ARVALID_O  <= #1 ARVALID;
    ARREADY_O  <= #1 ARREADY;
    ARREGION_O <= #1 ARREGION ;
    ARQOS_O    <= #1 ARQOS;
    ARUSER_O   <= #1 ARUSER;

  // read data  channel
    RID_O     <= #1 RID ;
    RLAST_O   <= #1 RLAST ;
    RDATA_O   <= #1 RDATA ;
    RRESP_O   <= #1 RRESP ;
    RVALID_O  <= #1 RVALID;
    RREADY_O  <= #1 RREADY;
    RUSER_O   <= #1 RUSER;

  end

  integer     bbeat   [int unsigned];
  integer     awbeat  [int unsigned];
  integer     rbeat   [int unsigned];
  integer     arbeat  [int unsigned];
  integer     wbeat = 0;

  always @(posedge ACLK) begin
    if (ARESET_N_O == 0) begin
      bbeat.delete();
      awbeat.delete();
      wbeat = 0;
      awcmd_id = 0;
      wcmd_id = 0;
      bcmd_id = 0;
      rbeat.delete();
      arbeat.delete();
      arcmd_id = 0;
      rcmd_id = 0;
    end else if (ACLKEN_O == 1) begin
      if (AWVALID && AWREADY) begin
        awcmd_id++;
        if (!awbeat.exists(awid_internal)) begin
          awbeat[awid_internal] = 0;
        end
        awbeat[awid_internal]++;
      end
      if (BVALID && BREADY) begin
        bcmd_id++;
        if (!bbeat.exists(bid_internal)) begin
          bbeat[bid_internal] = 0;
        end
        bbeat[bid_internal]++;
      end
      if (WVALID && WREADY) begin
        if ((C_AXI_PROTOCOL == 2) || (WLAST)) begin
          wcmd_id++;
          wbeat = 0;
        end else begin
          wbeat++;
        end
      end
      if (ARVALID && ARREADY) begin
        arcmd_id++;
        if (!arbeat.exists(arid_internal)) begin
          arbeat[arid_internal] = 0;
        end
        arbeat[arid_internal]++;
      end
      if (RVALID && RREADY) begin
        if ((C_AXI_PROTOCOL == 2) || (RLAST)) begin
          rcmd_id++;
          rbeat[rid_internal] = 0;
        end else begin
          if (!rbeat.exists(rid_internal)) begin
            rbeat[rid_internal] = 0;
          end
          rbeat[rid_internal]++;
        end
      end
    end
  end

  `else
  default clocking cb @(posedge aclk_internal);
    default input #1step output #C_HOLD_TIME;
    input   areset_n;
    input   ACLKEN;
    inout   AWADDR;
    inout   AWID;
    inout   AWLEN;
    inout   AWSIZE;
    inout   AWBURST;
    inout   AWLOCK;
    inout   AWCACHE;
    inout   AWPROT;
    inout   AWVALID;
    inout   AWREADY;
    inout   AWREGION;
    inout   AWQOS;
    inout   AWUSER;
    inout   WID;
    inout   WLAST;
    inout   WDATA;
    inout   WSTRB;
    inout   WVALID;
    inout   WREADY;
    inout   WUSER;
    inout   BRESP;
    inout   BID;
    inout   BVALID;
    inout   BREADY;
    inout   BUSER;
    inout   ARADDR;
    inout   ARID;
    inout   ARLEN;
    inout   ARSIZE;
    inout   ARBURST;
    inout   ARLOCK;
    inout   ARCACHE;
    inout   ARPROT;
    inout   ARVALID;
    inout   ARREADY;
    inout   ARREGION;
    inout   ARQOS;
    inout   ARUSER;
    inout   RID;
    inout   RLAST;
    inout   RDATA;
    inout   RRESP;
    inout   RVALID;
    inout   RREADY;
    inout   RUSER;
    inout   arid_internal;
    inout   wid_internal ;
    inout   rid_internal ;
    inout   awid_internal;
    inout   bid_internal ;
  endclocking : cb

  integer     bbeat   [int unsigned];
  integer     awbeat  [int unsigned];
  integer     rbeat   [int unsigned];
  integer     arbeat  [int unsigned];
  integer     wbeat = 0;

  always @(cb) begin
    if (cb.areset_n == 0) begin
      bbeat.delete();
      awbeat.delete();
      wbeat = 0;
      awcmd_id = 0;
      wcmd_id = 0;
      bcmd_id = 0;
      rbeat.delete();
      arbeat.delete();
      arcmd_id = 0;
      rcmd_id = 0;
    end else if (cb.ACLKEN == 1) begin
      if (cb.AWVALID && cb.AWREADY) begin
        awcmd_id++;
        if (!awbeat.exists(cb.awid_internal)) begin
          awbeat[cb.awid_internal] = 0;
        end
        awbeat[cb.awid_internal]++;
      end
      if (cb.BVALID && cb.BREADY) begin
        bcmd_id++;
        if (!bbeat.exists(cb.bid_internal)) begin
          bbeat[cb.bid_internal] = 0;
        end
        bbeat[cb.bid_internal]++;
      end
      if (cb.WVALID && cb.WREADY) begin
        if ((C_AXI_PROTOCOL == 2) || (cb.WLAST)) begin
          wcmd_id++;
          wbeat = 0;
        end else begin
          wbeat++;
        end
      end
      if (cb.ARVALID && cb.ARREADY) begin
        arcmd_id++;
        if (!arbeat.exists(cb.arid_internal)) begin
          arbeat[cb.arid_internal] = 0;
        end
        arbeat[cb.arid_internal]++;
      end
      if (cb.RVALID && cb.RREADY) begin
        if ((C_AXI_PROTOCOL == 2) || (cb.RLAST)) begin
          rcmd_id++;
          rbeat[cb.rid_internal] = 0;
        end else begin
          if (!rbeat.exists(cb.rid_internal)) begin
            rbeat[cb.rid_internal] = 0;
          end
          rbeat[cb.rid_internal]++;
        end
      end
    end
  end

  `endif

  function automatic xil_axi_uint xil_clog2(input xil_axi_uint value);
    if (value !== 0) begin
      value = value - 1;
      for (xil_clog2 = 0; value > 0; xil_clog2 = xil_clog2 + 1) begin
        value = value >> 1;
      end
    end else begin
      xil_clog2 = 0;
    end
  endfunction // xil_clog2

  assign real_reset = !ARESET_N;
  assign reset_for_assert = fake_reset & real_reset;
  initial begin
    fake_reset =0;
    @(posedge ACLK);
    fake_reset =1;
  end

  
  `ifndef XILINX_SIMULATOR  
   
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
  
  //
  always @(posedge ACLK) begin
    if(ARESET_N) begin
      if(C_AXI_SUPPORTS_NARROW ==0) begin
        if ((awlen_internal > 0) && (awvalid_internal ==1)) begin
          if (!((8*(1<<awsize_internal)) == C_AXI_WDATA_WIDTH) && (aw_burst_report_set==1)) begin
            `REPORT_MACRO(`XILINX_AW_SUPPORTS_NARROW_BURST,`XILINX_AX_SUPPORTS_NARROW_BURST_SOL,xilinx_supports_narrow_burst_check_enable)
            aw_burst_report_set =0;
          end
          if ((awcache_internal[1] !=1) && (C_AXI_HAS_CACHE==1)&& (aw_cache_report_set==1))  begin
            `REPORT_MACRO(`XILINX_AW_SUPPORTS_NARROW_CACHE,`XILINX_AX_SUPPORTS_NARROW_CACHE_SOL,xilinx_supports_narrow_cache_check_enable)
            aw_cache_report_set =0;
          end 
        end
        if ((arlen_internal > 0) && (arvalid_internal ==1)) begin
          if (!((8*(1<<arsize_internal)) == C_AXI_RDATA_WIDTH) && (ar_burst_report_set==1)) begin
            `REPORT_MACRO(`XILINX_AR_SUPPORTS_NARROW_BURST,`XILINX_AX_SUPPORTS_NARROW_BURST_SOL,xilinx_supports_narrow_burst_check_enable)
            ar_burst_report_set =0;
          end
          if ((arcache_internal[1] !=1) && (C_AXI_HAS_CACHE==1)&& (ar_cache_report_set==1) )  begin
            `REPORT_MACRO(`XILINX_AR_SUPPORTS_NARROW_CACHE,`XILINX_AX_SUPPORTS_NARROW_CACHE_SOL,xilinx_supports_narrow_cache_check_enable)
            ar_cache_report_set= 0;
          end 
        end
      end  
      if(C_AXI_HAS_WSTRB ==0) begin
        if (awvalid_internal ==1) begin
          if (!(AWADDR%(C_AXI_WDATA_WIDTH/8) ==0) && (strb_report_set==1)) begin
            `REPORT_MACRO(`XILINX_NO_STRB_ADDRESS,`XILINX_NO_STRB_ADDRESS_SOL,xilinx_no_strb_address_check_enable)
            strb_report_set =0;
          end 
        end  
      end 
    end  
  end

  `RESET_ONE_PULSE(ACLK,ARESET_N,supports_write,ACLKEN,awready_one_pulse_cnt,AWREADY,`XILINX_AWREADY_RESET,`XILINX_XREADY_RESET_SOL,xilinx_slave_ready_check_enable)
  `RESET_ONE_PULSE(ACLK,ARESET_N,supports_write,ACLKEN,wready_one_pulse_cnt,WREADY,`XILINX_WREADY_RESET,`XILINX_XREADY_RESET_SOL,xilinx_slave_ready_check_enable)
  `RESET_ONE_PULSE(ACLK,ARESET_N,supports_read,ACLKEN,arready_one_pulse_cnt,ARREADY,`XILINX_ARREADY_RESET,`XILINX_XREADY_RESET_SOL,xilinx_slave_ready_check_enable)
  `RESET_EIGHT_PULSE(ACLK,ARESET_N,supports_write,ACLKEN,WREADY,`XILINX_WREADY_MAX_RESET,`XILINX_XREADY_RESET_SOL,xilinx_slave_ready_check_enable)
  `RESET_EIGHT_PULSE(ACLK,ARESET_N,supports_write,ACLKEN,AWREADY,`XILINX_AWREADY_MAX_RESET,`XILINX_XREADY_RESET_SOL,xilinx_slave_ready_check_enable)
  `RESET_EIGHT_PULSE(ACLK,ARESET_N,supports_read,ACLKEN,ARREADY,`XILINX_ARREADY_MAX_RESET,`XILINX_XREADY_RESET_SOL,xilinx_slave_ready_check_enable)

 

`endif

endinterface : axi_vip_if

`endif


