module top(
  input  CLK100MHZ,
  input  BTN_1,
  input  BTN_2,
  input  BTN_3,
  input  BTN_4,
  input  SWITCH,
  output LED_A
);
wire tick_mf;
wire tick_lf;
wire led_a;
wire led_b;
wire seq;
wire enable;
wire clk;
wire [1:0] state;

wire btn_1;
wire btn_2;
wire btn_3;
wire check;
wire led_armed;
wire led_alarm;
wire mov;

assign clk   = CLK100MHZ;
assign LED_A = led_armed;
assign LED_B = led_alarm;
assign mov   = SWITCH;

anti_bounce anti_bounce_btn_1(
  .btn_in(BTN_1),
  .btn_out(btn_1),
  .tick_mf(tick_mf),
  .clk(clk));

anti_bounce anti_bounce_btn_2(
  .btn_in(BTN_2),
  .btn_out(btn_2),
  .tick_mf(tick_mf),
  .clk(clk));

anti_bounce anti_bounce_btn_3(
  .btn_in(BTN_3),
  .btn_out(btn_3),
  .tick_mf(tick_mf),
  .clk(clk));

anti_bounce anti_bounce_check(
  .btn_in(BTN_4),
  .btn_out(check),
  .tick_mf(tick_mf),
  .clk(clk));

freq_divider divider_u(
  .clk_in(clk),
  .tick_mf(tick_mf),
  .tick_lf(tick_lf) );

seq_detecter seq_detecter_u(
  .b1(btn_1), .b2(btn_2), .b3(btn_3),
  .check(check),
  .clk(clk),
  .seq(seq),
  .enable(enable)
);

state_change state_change_u(
  .seq(seq),
  .mov(mov),
  .enable(enable),
  .clk(clk),
  .state(state)
);

hw_control hw_control_u(
  .state(state),
  .alarm(led_alarm),
  .armed_led(led_armed)
);

endmodule
