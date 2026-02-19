//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Wed Aug  6 11:04:09 2025
//Host        : Juan running 64-bit major release  (build 9200)
//Command     : generate_target axi_stream_master.bd
//Design      : axi_stream_master
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "axi_stream_master,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=axi_stream_master,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "axi_stream_master.hwdef" *) 
module axi_stream_master
   (M_AXIS_MASTER_0_tdata,
    M_AXIS_MASTER_0_tdest,
    M_AXIS_MASTER_0_tid,
    M_AXIS_MASTER_0_tkeep,
    M_AXIS_MASTER_0_tlast,
    M_AXIS_MASTER_0_tready,
    M_AXIS_MASTER_0_tstrb,
    M_AXIS_MASTER_0_tuser,
    M_AXIS_MASTER_0_tvalid,
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
    core_ext_start_0,
    core_ext_stop_0,
    err_out_0,
    s_axi_aclk_0,
    s_axi_aresetn_0);
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TDATA" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_MASTER_0, CLK_DOMAIN axi_stream_master_s_axi_aclk_0, FREQ_HZ 100000000, HAS_TKEEP 1, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 1, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 128, TDEST_WIDTH 8, TID_WIDTH 16, TUSER_WIDTH 256" *) output [1023:0]M_AXIS_MASTER_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TDEST" *) output [7:0]M_AXIS_MASTER_0_tdest;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TID" *) output [15:0]M_AXIS_MASTER_0_tid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TKEEP" *) output [127:0]M_AXIS_MASTER_0_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TLAST" *) output M_AXIS_MASTER_0_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TREADY" *) input M_AXIS_MASTER_0_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TSTRB" *) output [127:0]M_AXIS_MASTER_0_tstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TUSER" *) output [255:0]M_AXIS_MASTER_0_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_MASTER_0 TVALID" *) output M_AXIS_MASTER_0_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARADDR" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_0, ADDR_WIDTH 32, ARUSER_WIDTH 8, AWUSER_WIDTH 8, BUSER_WIDTH 0, CLK_DOMAIN axi_stream_master_s_axi_aclk_0, DATA_WIDTH 32, FREQ_HZ 100000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 0, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 1, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 7, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 7, NUM_WRITE_THREADS 1, PHASE 0.0, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 1, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [31:0]S_AXI_0_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARBURST" *) input [1:0]S_AXI_0_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARCACHE" *) input [3:0]S_AXI_0_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARID" *) input [0:0]S_AXI_0_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARLEN" *) input [7:0]S_AXI_0_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARLOCK" *) input [0:0]S_AXI_0_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARPROT" *) input [2:0]S_AXI_0_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARQOS" *) input [3:0]S_AXI_0_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARREADY" *) output S_AXI_0_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARSIZE" *) input [2:0]S_AXI_0_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARUSER" *) input [7:0]S_AXI_0_aruser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 ARVALID" *) input S_AXI_0_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWADDR" *) input [31:0]S_AXI_0_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWBURST" *) input [1:0]S_AXI_0_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWCACHE" *) input [3:0]S_AXI_0_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWID" *) input [0:0]S_AXI_0_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWLEN" *) input [7:0]S_AXI_0_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWLOCK" *) input [0:0]S_AXI_0_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWPROT" *) input [2:0]S_AXI_0_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWQOS" *) input [3:0]S_AXI_0_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWREADY" *) output S_AXI_0_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWSIZE" *) input [2:0]S_AXI_0_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWUSER" *) input [7:0]S_AXI_0_awuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 AWVALID" *) input S_AXI_0_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 BID" *) output [0:0]S_AXI_0_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 BREADY" *) input S_AXI_0_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 BRESP" *) output [1:0]S_AXI_0_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 BVALID" *) output S_AXI_0_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 RDATA" *) output [31:0]S_AXI_0_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 RID" *) output [0:0]S_AXI_0_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 RLAST" *) output S_AXI_0_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 RREADY" *) input S_AXI_0_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 RRESP" *) output [1:0]S_AXI_0_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 RVALID" *) output S_AXI_0_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 WDATA" *) input [31:0]S_AXI_0_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 WLAST" *) input S_AXI_0_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 WREADY" *) output S_AXI_0_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 WSTRB" *) input [3:0]S_AXI_0_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_0 WVALID" *) input S_AXI_0_wvalid;
  input core_ext_start_0;
  input core_ext_stop_0;
  output err_out_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.S_AXI_ACLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.S_AXI_ACLK_0, ASSOCIATED_BUSIF M_AXIS_MASTER_0:S_AXI_0, ASSOCIATED_RESET s_axi_aresetn_0, CLK_DOMAIN axi_stream_master_s_axi_aclk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input s_axi_aclk_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.S_AXI_ARESETN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.S_AXI_ARESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input s_axi_aresetn_0;

  wire [1023:0]M_AXIS_MASTER_0_tdata;
  wire [7:0]M_AXIS_MASTER_0_tdest;
  wire [15:0]M_AXIS_MASTER_0_tid;
  wire [127:0]M_AXIS_MASTER_0_tkeep;
  wire M_AXIS_MASTER_0_tlast;
  wire M_AXIS_MASTER_0_tready;
  wire [127:0]M_AXIS_MASTER_0_tstrb;
  wire [255:0]M_AXIS_MASTER_0_tuser;
  wire M_AXIS_MASTER_0_tvalid;
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
  wire core_ext_start_0;
  wire core_ext_stop_0;
  wire err_out_0;
  wire s_axi_aclk_0;
  wire s_axi_aresetn_0;

  axi_stream_master_axi_traffic_gen_0_0 axi_traffic_gen_0
       (.core_ext_start(core_ext_start_0),
        .core_ext_stop(core_ext_stop_0),
        .err_out(err_out_0),
        .m_axis_1_tdata(M_AXIS_MASTER_0_tdata),
        .m_axis_1_tdest(M_AXIS_MASTER_0_tdest),
        .m_axis_1_tid(M_AXIS_MASTER_0_tid),
        .m_axis_1_tkeep(M_AXIS_MASTER_0_tkeep),
        .m_axis_1_tlast(M_AXIS_MASTER_0_tlast),
        .m_axis_1_tready(M_AXIS_MASTER_0_tready),
        .m_axis_1_tstrb(M_AXIS_MASTER_0_tstrb),
        .m_axis_1_tuser(M_AXIS_MASTER_0_tuser),
        .m_axis_1_tvalid(M_AXIS_MASTER_0_tvalid),
        .s_axi_aclk(s_axi_aclk_0),
        .s_axi_araddr(S_AXI_0_araddr),
        .s_axi_arburst(S_AXI_0_arburst),
        .s_axi_arcache(S_AXI_0_arcache),
        .s_axi_aresetn(s_axi_aresetn_0),
        .s_axi_arid(S_AXI_0_arid),
        .s_axi_arlen(S_AXI_0_arlen),
        .s_axi_arlock(S_AXI_0_arlock),
        .s_axi_arprot(S_AXI_0_arprot),
        .s_axi_arqos(S_AXI_0_arqos),
        .s_axi_arready(S_AXI_0_arready),
        .s_axi_arsize(S_AXI_0_arsize),
        .s_axi_aruser(S_AXI_0_aruser),
        .s_axi_arvalid(S_AXI_0_arvalid),
        .s_axi_awaddr(S_AXI_0_awaddr),
        .s_axi_awburst(S_AXI_0_awburst),
        .s_axi_awcache(S_AXI_0_awcache),
        .s_axi_awid(S_AXI_0_awid),
        .s_axi_awlen(S_AXI_0_awlen),
        .s_axi_awlock(S_AXI_0_awlock),
        .s_axi_awprot(S_AXI_0_awprot),
        .s_axi_awqos(S_AXI_0_awqos),
        .s_axi_awready(S_AXI_0_awready),
        .s_axi_awsize(S_AXI_0_awsize),
        .s_axi_awuser(S_AXI_0_awuser),
        .s_axi_awvalid(S_AXI_0_awvalid),
        .s_axi_bid(S_AXI_0_bid),
        .s_axi_bready(S_AXI_0_bready),
        .s_axi_bresp(S_AXI_0_bresp),
        .s_axi_bvalid(S_AXI_0_bvalid),
        .s_axi_rdata(S_AXI_0_rdata),
        .s_axi_rid(S_AXI_0_rid),
        .s_axi_rlast(S_AXI_0_rlast),
        .s_axi_rready(S_AXI_0_rready),
        .s_axi_rresp(S_AXI_0_rresp),
        .s_axi_rvalid(S_AXI_0_rvalid),
        .s_axi_wdata(S_AXI_0_wdata),
        .s_axi_wlast(S_AXI_0_wlast),
        .s_axi_wready(S_AXI_0_wready),
        .s_axi_wstrb(S_AXI_0_wstrb),
        .s_axi_wvalid(S_AXI_0_wvalid));
endmodule
