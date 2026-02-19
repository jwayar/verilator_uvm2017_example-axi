
package xilinxs_vip_pkg;

    `include "xil_common_vip_macros.svh"
  
    typedef bit[7:0] xil_axi4stream_sigset_t;
    
   `define VAL_SIGNAL_SET          'hFF
   `define VAL_DEST_WIDTH          4
   `define VAL_DATA_WIDTH          32
   `define VAL_ID_WIDTH            4
   `define VAL_USER_WIDTH          32
   `define VAL_USER_BITS_PER_BYTE  0
   `define VAL_HAS_ARESETN         1
  
   parameter xil_axi4stream_sigset_t C_XIL_AXI4STREAM_SIGNAL_SET  = `VAL_SIGNAL_SET;
   parameter int C_XIL_AXI4STREAM_DEST_WIDTH                      = `VAL_DEST_WIDTH;
   parameter int C_XIL_AXI4STREAM_DATA_WIDTH                      = `VAL_DATA_WIDTH;
   parameter int C_XIL_AXI4STREAM_ID_WIDTH                        = `VAL_ID_WIDTH;
   parameter int C_XIL_AXI4STREAM_USER_WIDTH                      = `VAL_USER_WIDTH;
   parameter int C_XIL_AXI4STREAM_USER_BITS_PER_BYTE              = `VAL_USER_BITS_PER_BYTE;
   parameter int C_XIL_AXI4STREAM_HAS_ARESETN                     = `VAL_HAS_ARESETN;
  
  `define XIL_AXI4STREAM_PARAM_DECL #(                                                       \
      xil_axi4stream_sigset_t C_XIL_AXI4STREAM_SIGNAL_SET         = `VAL_SIGNAL_SET,         \
      int                     C_XIL_AXI4STREAM_DEST_WIDTH         = `VAL_DEST_WIDTH,         \
      int                     C_XIL_AXI4STREAM_DATA_WIDTH         = `VAL_DATA_WIDTH,         \
      int                     C_XIL_AXI4STREAM_ID_WIDTH           = `VAL_ID_WIDTH,           \
      int                     C_XIL_AXI4STREAM_USER_WIDTH         = `VAL_USER_WIDTH,         \
      int                     C_XIL_AXI4STREAM_USER_BITS_PER_BYTE = `VAL_USER_BITS_PER_BYTE, \
      int                     C_XIL_AXI4STREAM_HAS_ARESETN        = `VAL_HAS_ARESETN         \
  )
  
  
  `define XIL_AXI4STREAM_PARAM_ORDER #(    \
      C_XIL_AXI4STREAM_SIGNAL_SET,         \
      C_XIL_AXI4STREAM_DEST_WIDTH,         \
      C_XIL_AXI4STREAM_DATA_WIDTH,         \
      C_XIL_AXI4STREAM_ID_WIDTH,           \
      C_XIL_AXI4STREAM_USER_WIDTH,         \
      C_XIL_AXI4STREAM_USER_BITS_PER_BYTE, \
      C_XIL_AXI4STREAM_HAS_ARESETN         \
   )

  `include "xil_common_vip_pkg.sv"
  `include "axi4stream_vip_pkg.sv"

  `undef AXI_PARAM_DECL
  `undef AXI_PARAM_ORDER

endpackage
