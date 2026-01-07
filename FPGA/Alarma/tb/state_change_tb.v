`timescale 1ns / 1ps

module state_change_tb;

reg SEQ, MOV, ENABLE, CLK;
wire [1:0] STATE;

// Parameters
parameter CLK_PERIOD = 6; // 100MHz clock (10ns period)
parameter SIM_TIME = 600000;

// testing instance
state_change state_change_ut(
  .seq(SEQ),
  .enable(ENABLE),
  .mov(MOV),
  .clk(CLK),
  .state(STATE)
  );

// Clock generation
initial begin
  CLK = 0;
  forever #(CLK_PERIOD/2) CLK = ~CLK;
end

initial begin
  SEQ    = 1'b0;
  MOV    = 1'b0;
  ENABLE = 1'b0;

  #20 // paso a armado
  @(negedge CLK);
  SEQ    = 1;
  ENABLE = 1;
  @(posedge CLK);
  SEQ    = 0;
  ENABLE = 0;
  #30 // paso a desarmado
  @(negedge CLK);
  SEQ    = 1;
  ENABLE = 1;
  @(posedge CLK);
  SEQ    = 0;
  ENABLE = 0;
  #30 // paso a armado
  @(negedge CLK);
  SEQ    = 1;
  ENABLE = 1;
  @(posedge CLK);
  SEQ = 0;
  ENABLE = 0;
  #30 // paso a alarma por seq incorrecta
  @(negedge CLK);
  SEQ    = 0;
  ENABLE = 1;
  @(posedge CLK);
  SEQ    = 0;
  ENABLE = 0;
  #30 // fallo en desactivar alarma
  @(negedge CLK);
  SEQ    = 0;
  ENABLE = 1;
  @(posedge CLK);
  SEQ    = 0;
  ENABLE = 0;
  #30 // desactivo alarma
  @(negedge CLK);
  SEQ    = 1;
  ENABLE = 1;
  @(posedge CLK);
  SEQ    = 0;
  ENABLE = 0;
  #30 // armado
  @(negedge CLK);
  SEQ    = 1;
  ENABLE = 1;
  @(posedge CLK);
  SEQ    = 0;
  ENABLE = 0;
  #30 // alarma por movimiento
  @(negedge CLK);
  MOV    = 1;
  @(posedge CLK);
  MOV    = 0;
  #30 // desactivo alarma
  @(negedge CLK);
  SEQ    = 1;
  ENABLE = 1;
  @(posedge CLK);
  SEQ    = 0;
  ENABLE = 0;
  #50
  $finish;
end

endmodule
