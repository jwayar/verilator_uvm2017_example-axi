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
// Filename           : axi_stream_tb_top.sv                                       :
// Date Last Modified : 2025 SEP 1                                           :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : axi_Stream Testbench HDL top                               :
// Author(s)          : Juan Doctorovich                                        :
// Email              : jdoctorovich@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

module axi_stream_tb_top;

  // Imports.
  import uvm_pkg::*;
  import axi_stream_tb_defn_pkg::*;
  import axi_stream_tb_test_pkg::*;

  `include "uvm_macros.svh"

  // Clock and reset signals.
  bit clk;
  bit rst_n;
  logic start_ip;
  logic stop_ip;

  // Clock initial block.
  initial begin
    clk   = 0;  // Initialize clock
    forever begin
      #(CLK_PERIOD_NS / 2) clk = ~clk;
    end
  end

  // Reset initial block.
  initial begin
    rst_n = 0; // Initialize reset
    repeat (RESET_CLOCK_COUNT) @(posedge clk);  // Wait for reset completion (after RESET_CLOCK_COUNT)
    rst_n = 1;
  end

  initial begin
    start_ip = 1;
    stop_ip = 0;
  end

axi_stream_receiver_wrapper axi_stream_receiver_wrapper
   (.M_AXIS_SLAVE_0_tdata(receiver_if.tdata),
    .M_AXIS_SLAVE_0_tdest(receiver_if.tdest),
    .M_AXIS_SLAVE_0_tid(receiver_if.tid),
    .M_AXIS_SLAVE_0_tkeep(receiver_if.tkeep),
    .M_AXIS_SLAVE_0_tlast(receiver_if.tlast),
    .M_AXIS_SLAVE_0_tready(receiver_if.tready),
    .M_AXIS_SLAVE_0_tstrb(receiver_if.tstrb),
    .M_AXIS_SLAVE_0_tuser(receiver_if.tuser),
    .M_AXIS_SLAVE_0_tvalid(receiver_if.tvalid),
    .S_AXIS_SLAVE_0_tdata(transmitter_if.tdata),
    .S_AXIS_SLAVE_0_tdest(transmitter_if.tdest),
    .S_AXIS_SLAVE_0_tid(transmitter_if.tid),
    .S_AXIS_SLAVE_0_tkeep(transmitter_if.tkeep),
    .S_AXIS_SLAVE_0_tlast(transmitter_if.tlast),
    .S_AXIS_SLAVE_0_tready(transmitter_if.tready),
    .S_AXIS_SLAVE_0_tstrb(transmitter_if.tstrb),
    .S_AXIS_SLAVE_0_tuser(transmitter_if.tuser),
    .S_AXIS_SLAVE_0_tvalid(transmitter_if.tvalid),
    .S_AXI_0_araddr(),
    .S_AXI_0_arburst(),
    .S_AXI_0_arcache(),
    .S_AXI_0_arid(),
    .S_AXI_0_arlen(),
    .S_AXI_0_arlock(),
    .S_AXI_0_arprot(),
    .S_AXI_0_arqos(),
    .S_AXI_0_arready(),
    .S_AXI_0_arsize(),
    .S_AXI_0_aruser(),
    .S_AXI_0_arvalid(),
    .S_AXI_0_awaddr(),
    .S_AXI_0_awburst(),
    .S_AXI_0_awcache(),
    .S_AXI_0_awid(),
    .S_AXI_0_awlen(),
    .S_AXI_0_awlock(),
    .S_AXI_0_awprot(),
    .S_AXI_0_awqos(),
    .S_AXI_0_awready(),
    .S_AXI_0_awsize(),
    .S_AXI_0_awuser(),
    .S_AXI_0_awvalid(),
    .S_AXI_0_bid(),
    .S_AXI_0_bready(),
    .S_AXI_0_bresp(),
    .S_AXI_0_bvalid(),
    .S_AXI_0_rdata(),
    .S_AXI_0_rid(),
    .S_AXI_0_rlast(),
    .S_AXI_0_rready(),
    .S_AXI_0_rresp(),
    .S_AXI_0_rvalid(),
    .S_AXI_0_wdata(),
    .S_AXI_0_wlast(),
    .S_AXI_0_wready(),
    .S_AXI_0_wstrb(),
    .S_AXI_0_wvalid(),
    .err_out_0(),
    .s_axi_aclk_0(clk),
    .s_axi_aresetn_0(rst_n));

  axi_stream_if #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)
  ) transmitter_if (
      .aclk  (clk),
      .aresetn(rst_n)
  );
  axi_stream_if #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)
  ) receiver_if (
      .aclk  (clk),
      .aresetn(rst_n)
  );

  // UVM initial block.
  initial begin
    // Set time format for simulation.
    $timeformat(-12, 1, " ps", 1);

    // Configure some simulation options.
    uvm_top.enable_print_topology = 1;
    uvm_top.finish_on_completion  = 0;

    // Set default verbosity level for all TB components.
    uvm_top.set_report_verbosity_level(UVM_HIGH);

    // Set interfaces names in UVM configuration database.
    uvm_config_db #(virtual axi_stream_if  #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)))::set(null, "uvm_test_top", "transmitter_if", transmitter_if);
    uvm_config_db #(virtual axi_stream_if  #(.PARM_DATA_WIDTH(PARM_DATA_WIDTH_2)))::set(null, "uvm_test_top", "receiver_if", receiver_if);

    // Test name must be set from the simulator's command line.
    run_test();
    $stop();
  end
endmodule
