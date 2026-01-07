`timescale 1ns/1ps

module hw_control_tb();

wire ALARM_ON, ARMED_LED;
reg [1:0] STATE;

localparam UNARMED = 2'b00;
localparam ARMED   = 2'b01;
localparam ALARM   = 2'b10;

hw_control hw_control_ut(
  .state(STATE),
  .alarm(ALARM_ON),
  .armed_led(ARMED_LED)
  );

  initial begin
    #5  STATE = ARMED;
    #20 STATE = UNARMED;
    #20 STATE = ARMED;
    #20 STATE = ALARM;
    #20 STATE = UNARMED;
    #20
    $finish;

  end


endmodule
