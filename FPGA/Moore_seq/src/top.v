module top(
  input  CLK100MHZ,
  input  BTN,
  output LED_A,
  output LED_B
);
wire tick_mf;
wire tick_lf;
wire led_a;
wire led_b;
wire clk;
wire [1:0] state;

assign clk   = CLK100MHZ;
assign LED_A = led_a;
assign LED_B = led_b;

freq_divider divider(.clk_in(clk), .tick_mf(tick_mf), .tick_lf(tick_lf) );
led_change led_change_u(
  .state(state),
  .clk(clk),
  .tick_lf(tick_lf),
  .led_a(led_a),
  .led_b(led_b)
);
state_change state_change_u(
  .btn(BTN),
  .tick_mf(tick_mf),
  .clk(clk),
  .state(state)
);

endmodule
