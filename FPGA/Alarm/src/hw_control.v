module hw_control(
  input  wire[1:0] state,

  output alarm,
  output armed_led
);

localparam UNARMED = 2'b00;
localparam ARMED   = 2'b01;
localparam ALARM   = 2'b10;

assign alarm     = state == ALARM;
assign armed_led = state == ARMED;

endmodule
