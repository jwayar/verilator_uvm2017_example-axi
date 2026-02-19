module reset_gen #(
    parameter real START_DELAY_SEC = 1us
) (
    output logic rst_po,
    output logic rst_no
);
  timeunit 1ns; timeprecision 1fs;

  localparam time RstStartDelayFsec = 1e15 * START_DELAY_SEC;

  logic rst;

  initial begin : INITIAL_rst_gen
    rst = 1;
    #(RstStartDelayFsec * 1fs);
    rst = 0;
  end

  assign rst_po = rst;
  assign rst_no = ~rst;

endmodule
