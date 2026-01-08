`timescale 1ns / 1ps

module led_tb;

// Parameters
parameter CLK_PERIOD = 6; // 100MHz clock (10ns period)
parameter SIM_TIME = 600000;

// tb signals
wire      LED_A;
wire      LED_B;
reg       CLK_IN;
wire      TICK_MF;
wire      TICK_LF;
reg [1:0] STATE;

initial begin
  STATE = 2'b00;
end

// Clock generation
initial begin
  CLK_IN = 0;
  forever #(CLK_PERIOD/2) CLK_IN = ~CLK_IN;
end


freq_divider #(
  .mf_divider(20),
  .lf_divider(2)
  ) freq_divider_u (
  .clk_in(CLK_IN),
  .tick_mf(TICK_MF),
  .tick_lf(TICK_LF)
);
led_change led_change_u(
  .state(STATE),
  .tick_lf(TICK_LF),
  .led_a(LED_A),
  .led_b(LED_B),
  .clk(CLK_IN)
  );

// Tests
initial begin
  #1000 STATE = 2'b01;
  #1000 STATE = 2'b00;
  #100  STATE = 2'b10;
  #1000 STATE = 2'b00;
  #100  STATE = 2'b11;
  #1000 STATE = 2'b00;

  $finish;
end

endmodule
