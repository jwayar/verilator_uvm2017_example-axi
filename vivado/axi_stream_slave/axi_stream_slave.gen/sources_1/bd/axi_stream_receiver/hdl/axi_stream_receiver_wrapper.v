//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Wed Aug 13 13:09:20 2025
//Host        : Juan running 64-bit major release  (build 9200)
//Command     : generate_target axi_stream_receiver_wrapper.bd
//Design      : axi_stream_receiver_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module axi_stream_receiver_wrapper
   (M_AXIS_SLAVE_0_tdata,
    M_AXIS_SLAVE_0_tdest,
    M_AXIS_SLAVE_0_tid,
    M_AXIS_SLAVE_0_tkeep,
    M_AXIS_SLAVE_0_tlast,
    M_AXIS_SLAVE_0_tready,
    M_AXIS_SLAVE_0_tstrb,
    M_AXIS_SLAVE_0_tuser,
    M_AXIS_SLAVE_0_tvalid,
    S_AXIS_SLAVE_0_tdata,
    S_AXIS_SLAVE_0_tdest,
    S_AXIS_SLAVE_0_tid,
    S_AXIS_SLAVE_0_tkeep,
    S_AXIS_SLAVE_0_tlast,
    S_AXIS_SLAVE_0_tready,
    S_AXIS_SLAVE_0_tstrb,
    S_AXIS_SLAVE_0_tuser,
    S_AXIS_SLAVE_0_tvalid,
    S_AXI_0_araddr,
    S_AXI_0_arburst,
    S_AXI_0_arcache,
    S_AXI_0_arid,
    S_AXI_0_arlen,
    S_AXI_0_arlock,
    S_AXI_0_arprot,
    S_AXI_0_arqos,
    S_AXI_0_arready,
    S_AXI_0_arsize,
    S_AXI_0_aruser,
    S_AXI_0_arvalid,
    S_AXI_0_awaddr,
    S_AXI_0_awburst,
    S_AXI_0_awcache,
    S_AXI_0_awid,
    S_AXI_0_awlen,
    S_AXI_0_awlock,
    S_AXI_0_awprot,
    S_AXI_0_awqos,
    S_AXI_0_awready,
    S_AXI_0_awsize,
    S_AXI_0_awuser,
    S_AXI_0_awvalid,
    S_AXI_0_bid,
    S_AXI_0_bready,
    S_AXI_0_bresp,
    S_AXI_0_bvalid,
    S_AXI_0_rdata,
    S_AXI_0_rid,
    S_AXI_0_rlast,
    S_AXI_0_rready,
    S_AXI_0_rresp,
    S_AXI_0_rvalid,
    S_AXI_0_wdata,
    S_AXI_0_wlast,
    S_AXI_0_wready,
    S_AXI_0_wstrb,
    S_AXI_0_wvalid,
    err_out_0,
    s_axi_aclk_0,
    s_axi_aresetn_0);
  output [1023:0]M_AXIS_SLAVE_0_tdata;
  output [7:0]M_AXIS_SLAVE_0_tdest;
  output [15:0]M_AXIS_SLAVE_0_tid;
  output [127:0]M_AXIS_SLAVE_0_tkeep;
  output M_AXIS_SLAVE_0_tlast;
  input M_AXIS_SLAVE_0_tready;
  output [127:0]M_AXIS_SLAVE_0_tstrb;
  output [255:0]M_AXIS_SLAVE_0_tuser;
  output M_AXIS_SLAVE_0_tvalid;
  input [1023:0]S_AXIS_SLAVE_0_tdata;
  input [7:0]S_AXIS_SLAVE_0_tdest;
  input [15:0]S_AXIS_SLAVE_0_tid;
  input [127:0]S_AXIS_SLAVE_0_tkeep;
  input S_AXIS_SLAVE_0_tlast;
  output S_AXIS_SLAVE_0_tready;
  input [127:0]S_AXIS_SLAVE_0_tstrb;
  input [255:0]S_AXIS_SLAVE_0_tuser;
  input S_AXIS_SLAVE_0_tvalid;
  input [31:0]S_AXI_0_araddr;
  input [1:0]S_AXI_0_arburst;
  input [3:0]S_AXI_0_arcache;
  input [0:0]S_AXI_0_arid;
  input [7:0]S_AXI_0_arlen;
  input [0:0]S_AXI_0_arlock;
  input [2:0]S_AXI_0_arprot;
  input [3:0]S_AXI_0_arqos;
  output S_AXI_0_arready;
  input [2:0]S_AXI_0_arsize;
  input [7:0]S_AXI_0_aruser;
  input S_AXI_0_arvalid;
  input [31:0]S_AXI_0_awaddr;
  input [1:0]S_AXI_0_awburst;
  input [3:0]S_AXI_0_awcache;
  input [0:0]S_AXI_0_awid;
  input [7:0]S_AXI_0_awlen;
  input [0:0]S_AXI_0_awlock;
  input [2:0]S_AXI_0_awprot;
  input [3:0]S_AXI_0_awqos;
  output S_AXI_0_awready;
  input [2:0]S_AXI_0_awsize;
  input [7:0]S_AXI_0_awuser;
  input S_AXI_0_awvalid;
  output [0:0]S_AXI_0_bid;
  input S_AXI_0_bready;
  output [1:0]S_AXI_0_bresp;
  output S_AXI_0_bvalid;
  output [31:0]S_AXI_0_rdata;
  output [0:0]S_AXI_0_rid;
  output S_AXI_0_rlast;
  input S_AXI_0_rready;
  output [1:0]S_AXI_0_rresp;
  output S_AXI_0_rvalid;
  input [31:0]S_AXI_0_wdata;
  input S_AXI_0_wlast;
  output S_AXI_0_wready;
  input [3:0]S_AXI_0_wstrb;
  input S_AXI_0_wvalid;
  output err_out_0;
  input s_axi_aclk_0;
  input s_axi_aresetn_0;

  wire [1023:0]M_AXIS_SLAVE_0_tdata;
  wire [7:0]M_AXIS_SLAVE_0_tdest;
  wire [15:0]M_AXIS_SLAVE_0_tid;
  wire [127:0]M_AXIS_SLAVE_0_tkeep;
  wire M_AXIS_SLAVE_0_tlast;
  wire M_AXIS_SLAVE_0_tready;
  wire [127:0]M_AXIS_SLAVE_0_tstrb;
  wire [255:0]M_AXIS_SLAVE_0_tuser;
  wire M_AXIS_SLAVE_0_tvalid;
  wire [1023:0]S_AXIS_SLAVE_0_tdata;
  wire [7:0]S_AXIS_SLAVE_0_tdest;
  wire [15:0]S_AXIS_SLAVE_0_tid;
  wire [127:0]S_AXIS_SLAVE_0_tkeep;
  wire S_AXIS_SLAVE_0_tlast;
  wire S_AXIS_SLAVE_0_tready;
  wire [127:0]S_AXIS_SLAVE_0_tstrb;
  wire [255:0]S_AXIS_SLAVE_0_tuser;
  wire S_AXIS_SLAVE_0_tvalid;
  wire [31:0]S_AXI_0_araddr;
  wire [1:0]S_AXI_0_arburst;
  wire [3:0]S_AXI_0_arcache;
  wire [0:0]S_AXI_0_arid;
  wire [7:0]S_AXI_0_arlen;
  wire [0:0]S_AXI_0_arlock;
  wire [2:0]S_AXI_0_arprot;
  wire [3:0]S_AXI_0_arqos;
  wire S_AXI_0_arready;
  wire [2:0]S_AXI_0_arsize;
  wire [7:0]S_AXI_0_aruser;
  wire S_AXI_0_arvalid;
  wire [31:0]S_AXI_0_awaddr;
  wire [1:0]S_AXI_0_awburst;
  wire [3:0]S_AXI_0_awcache;
  wire [0:0]S_AXI_0_awid;
  wire [7:0]S_AXI_0_awlen;
  wire [0:0]S_AXI_0_awlock;
  wire [2:0]S_AXI_0_awprot;
  wire [3:0]S_AXI_0_awqos;
  wire S_AXI_0_awready;
  wire [2:0]S_AXI_0_awsize;
  wire [7:0]S_AXI_0_awuser;
  wire S_AXI_0_awvalid;
  wire [0:0]S_AXI_0_bid;
  wire S_AXI_0_bready;
  wire [1:0]S_AXI_0_bresp;
  wire S_AXI_0_bvalid;
  wire [31:0]S_AXI_0_rdata;
  wire [0:0]S_AXI_0_rid;
  wire S_AXI_0_rlast;
  wire S_AXI_0_rready;
  wire [1:0]S_AXI_0_rresp;
  wire S_AXI_0_rvalid;
  wire [31:0]S_AXI_0_wdata;
  wire S_AXI_0_wlast;
  wire S_AXI_0_wready;
  wire [3:0]S_AXI_0_wstrb;
  wire S_AXI_0_wvalid;
  wire err_out_0;
  wire s_axi_aclk_0;
  wire s_axi_aresetn_0;

  axi_stream_receiver axi_stream_receiver_i
       (.M_AXIS_SLAVE_0_tdata(M_AXIS_SLAVE_0_tdata),
        .M_AXIS_SLAVE_0_tdest(M_AXIS_SLAVE_0_tdest),
        .M_AXIS_SLAVE_0_tid(M_AXIS_SLAVE_0_tid),
        .M_AXIS_SLAVE_0_tkeep(M_AXIS_SLAVE_0_tkeep),
        .M_AXIS_SLAVE_0_tlast(M_AXIS_SLAVE_0_tlast),
        .M_AXIS_SLAVE_0_tready(M_AXIS_SLAVE_0_tready),
        .M_AXIS_SLAVE_0_tstrb(M_AXIS_SLAVE_0_tstrb),
        .M_AXIS_SLAVE_0_tuser(M_AXIS_SLAVE_0_tuser),
        .M_AXIS_SLAVE_0_tvalid(M_AXIS_SLAVE_0_tvalid),
        .S_AXIS_SLAVE_0_tdata(S_AXIS_SLAVE_0_tdata),
        .S_AXIS_SLAVE_0_tdest(S_AXIS_SLAVE_0_tdest),
        .S_AXIS_SLAVE_0_tid(S_AXIS_SLAVE_0_tid),
        .S_AXIS_SLAVE_0_tkeep(S_AXIS_SLAVE_0_tkeep),
        .S_AXIS_SLAVE_0_tlast(S_AXIS_SLAVE_0_tlast),
        .S_AXIS_SLAVE_0_tready(S_AXIS_SLAVE_0_tready),
        .S_AXIS_SLAVE_0_tstrb(S_AXIS_SLAVE_0_tstrb),
        .S_AXIS_SLAVE_0_tuser(S_AXIS_SLAVE_0_tuser),
        .S_AXIS_SLAVE_0_tvalid(S_AXIS_SLAVE_0_tvalid),
        .S_AXI_0_araddr(S_AXI_0_araddr),
        .S_AXI_0_arburst(S_AXI_0_arburst),
        .S_AXI_0_arcache(S_AXI_0_arcache),
        .S_AXI_0_arid(S_AXI_0_arid),
        .S_AXI_0_arlen(S_AXI_0_arlen),
        .S_AXI_0_arlock(S_AXI_0_arlock),
        .S_AXI_0_arprot(S_AXI_0_arprot),
        .S_AXI_0_arqos(S_AXI_0_arqos),
        .S_AXI_0_arready(S_AXI_0_arready),
        .S_AXI_0_arsize(S_AXI_0_arsize),
        .S_AXI_0_aruser(S_AXI_0_aruser),
        .S_AXI_0_arvalid(S_AXI_0_arvalid),
        .S_AXI_0_awaddr(S_AXI_0_awaddr),
        .S_AXI_0_awburst(S_AXI_0_awburst),
        .S_AXI_0_awcache(S_AXI_0_awcache),
        .S_AXI_0_awid(S_AXI_0_awid),
        .S_AXI_0_awlen(S_AXI_0_awlen),
        .S_AXI_0_awlock(S_AXI_0_awlock),
        .S_AXI_0_awprot(S_AXI_0_awprot),
        .S_AXI_0_awqos(S_AXI_0_awqos),
        .S_AXI_0_awready(S_AXI_0_awready),
        .S_AXI_0_awsize(S_AXI_0_awsize),
        .S_AXI_0_awuser(S_AXI_0_awuser),
        .S_AXI_0_awvalid(S_AXI_0_awvalid),
        .S_AXI_0_bid(S_AXI_0_bid),
        .S_AXI_0_bready(S_AXI_0_bready),
        .S_AXI_0_bresp(S_AXI_0_bresp),
        .S_AXI_0_bvalid(S_AXI_0_bvalid),
        .S_AXI_0_rdata(S_AXI_0_rdata),
        .S_AXI_0_rid(S_AXI_0_rid),
        .S_AXI_0_rlast(S_AXI_0_rlast),
        .S_AXI_0_rready(S_AXI_0_rready),
        .S_AXI_0_rresp(S_AXI_0_rresp),
        .S_AXI_0_rvalid(S_AXI_0_rvalid),
        .S_AXI_0_wdata(S_AXI_0_wdata),
        .S_AXI_0_wlast(S_AXI_0_wlast),
        .S_AXI_0_wready(S_AXI_0_wready),
        .S_AXI_0_wstrb(S_AXI_0_wstrb),
        .S_AXI_0_wvalid(S_AXI_0_wvalid),
        .err_out_0(err_out_0),
        .s_axi_aclk_0(s_axi_aclk_0),
        .s_axi_aresetn_0(s_axi_aresetn_0));
endmodule
