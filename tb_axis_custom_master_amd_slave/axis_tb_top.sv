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
// Filename           : axi4full_tb_top.sv                                     :
// Date Last Modified : 2021 SEP 20                                            :
// Date Created       : 2021 SEP 20                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : AXIS top                                    :
// Author(s)          : Fernando Gerbino                                           :
// Email              : fgerbino@emtech.com.ar                                  :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

module axis_tb_top;

  // Imports.
  import uvm_pkg::*;
  import axis_tb_defn_pkg::*;
  import axis_tb_test_pkg::*;

  `include "uvm_macros.svh"

  // Clock and reset signals.
  logic clk;
  logic rst_n;

  // Clock and reset initial block.
  initial begin
    // Initialize clock to 0 and reset_n to TRUE.
    clk   = 0;
    rst_n = 0;
    // Wait for reset completion (RESET_CLOCK_COUNT).
    repeat (RESET_CLOCK_COUNT) begin
      #(CLK_PERIOD_NS / 2) clk = ~clk;
    end
    // Set rst_n to FALSE.
    rst_n = 1;
    // Start clock signal.
    forever begin
      #(CLK_PERIOD_NS / 2) clk = ~clk;
    end
  end

  // Custom interface
  axi_stream_if #(
    .PARM_DATA_WIDTH(AXIS_MASTER_DATA_WIDTH),
    .PARM_ID_WIDTH  (AXIS_MASTER_ID_WIDTH),
    .PARM_DEST_WIDTH(AXIS_MASTER_DEST_WIDTH),
    .PARM_USER_WIDTH(AXIS_MASTER_USER_WIDTH)
  ) master_if (
      .aclk  (clk),
      .aresetn(rst_n)
  );

  // AMD VIP interface
  axi4stream_vip_if  #(
    .C_AXI4STREAM_SIGNAL_SET        (AXIS_SLAVE_SIGNAL_SET), 
    .C_AXI4STREAM_DEST_WIDTH        (AXIS_SLAVE_DEST_WIDTH), 
    .C_AXI4STREAM_DATA_WIDTH        (AXIS_SLAVE_DATA_WIDTH), 
    .C_AXI4STREAM_ID_WIDTH          (AXIS_SLAVE_ID_WIDTH), 
    .C_AXI4STREAM_USER_WIDTH        (AXIS_SLAVE_USER_WIDTH), 
    .C_AXI4STREAM_USER_BITS_PER_BYTE(1'b0), 
    .C_AXI4STREAM_HAS_ARESETN       (1'b1)  
  ) slave_if 
  (
    .ACLK     (clk),
    .ACLKEN   (1'b1), 
    .ARESET_N (rst_n)
  );

  // Initialization of AMD interface
  generate
    initial slave_if.set_intf_slave;
  endgenerate

  // Connect master with slave
  assign slave_if.TDATA     = master_if.tdata;
  assign slave_if.TVALID    = master_if.tvalid;
  assign slave_if.TLAST     = master_if.tlast;
  assign slave_if.TSTRB     = master_if.tstrb;
  assign slave_if.TKEEP     = master_if.tkeep;
  assign slave_if.TID       = master_if.tid;
  assign slave_if.TDEST     = master_if.tdest;
  assign slave_if.TUSER     = master_if.tuser;
  assign master_if.tready   = slave_if.TREADY;

  // UVM initial block.
  initial begin
    // Set time format for simulation.
    $timeformat(-12, 1, " ps", 1);

    // Configure some simulation options.
    uvm_top.enable_print_topology = 1;
    uvm_top.finish_on_completion  = 0;

    // Set default verbosity level for all TB components.
    uvm_top.set_report_verbosity_level(UVM_LOW);

    // Set interfaces names in UVM configuration database.
    uvm_config_db #(axis_master_if)::set(null, "uvm_test_top*" , "master_if", master_if);
    uvm_config_db #(axis_slave_if )::set(null, "uvm_test_top*" , "slave_if" , slave_if );

    // Test name must be set from the simulator's command line.
    run_test();
    $stop();
  end

endmodule
