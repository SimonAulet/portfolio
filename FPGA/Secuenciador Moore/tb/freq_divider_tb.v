`timescale 1ns / 1ps

module freq_divider_tb;

  // Parameters
  parameter CLK_PERIOD = 10;   // 100MHz clock (10ns period)
  parameter SIM_TIME = 600000; //  simulation time to see


  // Testbench signals
  reg  CLK_IN;
  wire TICK_MF;
  wire TICK_LF;

  // Instantiate the DUT
  freq_divider #(
    .mf_divider(100),
    .lf_divider(5)
    ) dut (
    .clk_in(CLK_IN),
    .tick_mf(TICK_MF),
    .tick_lf(TICK_LF)
  );

  // Clock generation
  initial begin
    CLK_IN = 0;
    forever #(CLK_PERIOD/2) CLK_IN = ~CLK_IN;
  end

  initial begin

    $display("Simulation time: %0d ns", SIM_TIME);
    // Wait for simulation to complete
    #(SIM_TIME);

    $display("\nTestbench completed");
    $finish;
  end

endmodule
