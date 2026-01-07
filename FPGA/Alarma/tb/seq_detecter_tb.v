`timescale 1ns / 1ps

module seq_detecter_tb;

reg B1, B2, B3, RST, CHECK, CLK;
wire SEQ, ENABLE;
wire [1:0] STATE_CHECK;

// Parameters
parameter CLK_PERIOD = 6; // 100MHz clock (10ns period)
parameter SIM_TIME = 600000;

// testing instance
seq_detecter seq_detecter_ins(
  .b1(B1), .b2(B2), .b3(B3), .check(CHECK),
  .clk(CLK),
  .seq(SEQ),
  .enable(ENABLE),
  .state_check(STATE_CHECK)
  );

// Clock generation
initial begin
  CLK = 0;
  forever #(CLK_PERIOD/2) CLK = ~CLK;
end

initial begin
  RST = 0;
  B1=0;
  B2=0;
  B3=0;
  CHECK=0;

  #20
  @(posedge CLK);
  B1 = 1;
  @(posedge CLK);
  B1 = 0;
  #30
  @(posedge CLK);
  B2 = 1;
  @(posedge CLK);
  B2 = 0;
  #30
  @(posedge CLK);
  B3 = 1;
  @(posedge CLK);
  B3 = 0;
  #30
  @(posedge CLK);
  CHECK = 1;
  @(posedge CLK);
  CHECK = 0;
  #50;

  $finish;
end
endmodule
