module clock_gen_with_ref #(
    parameter real FREQUENCY_HZ = 100e6
) (
    input  logic ref_pi,
    output logic clk_po,
    output logic clk_no
);

  timeunit 1fs; timeprecision 1fs;

  localparam time ClkPeriodFsec = 1e15 / FREQUENCY_HZ;
  localparam time ClkPeriodHigh = ClkPeriodFsec / 2;
  localparam time ClkPeriodLow = ClkPeriodFsec - ClkPeriodHigh;

  logic clk;

  initial begin : INITIAL_clk_gen
    clk <= 0;
    forever begin
      #(ClkPeriodHigh * 1fs);
      clk <= 1;
      #(ClkPeriodLow * 1fs);
      clk <= 0;
    end
  end

  // try to keep
  localparam time PhaseStep = ClkPeriodFsec / 8;

  time start_time;
  time end_time;
  time delta_time;
  time clk_phase;

  initial begin : INITIAL_phase_adj
    clk_phase = ClkPeriodFsec * 1fs;
    forever begin
      @(posedge ref_pi);
      start_time = $time;
      @(posedge clk_po);
      end_time   = $time;
      delta_time = end_time - start_time;
      if (delta_time < 6 * PhaseStep * 1fs) clk_phase += PhaseStep;
      if (delta_time > 7 * PhaseStep * 1fs) clk_phase -= PhaseStep;
    end
  end

  logic clk_delayed;
  always @clk clk_delayed <= #(clk_phase * 1fs) clk;

  assign clk_po = clk_delayed;
  assign clk_no = ~clk_delayed;


endmodule
