`timescale 1ns/100ps

module FULL_ADDER_TB();

reg A, B, CIN;
wire S, COUT;
reg CLK;
integer i;

full_adder FULL_ADDER_DUT(.a(A), .b(B), .cin(CIN), .s(S), .cout(COUT), .clk(CLK));

initial
begin
  CLK = 1'b0;
  for (i=0; i<500; i = i+1)
    #5 CLK = ~CLK;
end

initial
begin
  A   = 0;
  B   = 0;
  CIN = 0;
end

always
begin
  #2;
      A   = 0;
      B   = 0;
      CIN = 0;
  #50;
      A   = 0;
      B   = 0;
      CIN = 1;
  #50;
      A   = 0;
      B   = 1;
      CIN = 0;
  #50;
      A   = 0;
      B   = 1;
      CIN = 1;
  #50;
      A   = 1;
      B   = 0;
      CIN = 0;
  #50;
      A   = 1;
      B   = 0;
      CIN = 1;
  #50;
      A   = 1;
      B   = 1;
      CIN = 0;
  #50;
      A   = 1;
      B   = 1;
      CIN = 1;
  $finish;
end

endmodule
