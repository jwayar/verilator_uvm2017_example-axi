module clock_gen #(
    parameter real FREQUENCY_HZ = 100e6
) (
    output logic clk_po,
    output logic clk_no
);

  timeunit 1ns; timeprecision 1fs;

  localparam time ClkPeriodFsec = 1e15 / FREQUENCY_HZ;
  localparam time ClkPeriodHigh = ClkPeriodFsec / 2;
  localparam time ClkPeriodLow = ClkPeriodFsec - ClkPeriodHigh;

  logic clk;

  initial begin : INITIAL_clk_gen
    clk <= 1;
    forever begin
      #(ClkPeriodHigh * 1fs);
      clk <= 0;
      #(ClkPeriodLow * 1fs);
      clk <= 1;
    end
  end

  assign clk_po = clk;
  assign clk_no = ~clk;

endmodule
