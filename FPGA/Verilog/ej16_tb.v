`timescale 1ns/100ps

module ej16_tb();

reg D, CLK;
wire Q, QNOT;

integer i;

flipflopD FLIPFLOPD_TB(.d(D), .clk(CLK), .q(Q), .qnot(QNOT));

initial
begin
  CLK = 1'b0;
  for(i=0; i<500; i=i+1)
    #5 CLK = ~CLK;
end

initial
begin
  D = 1'b1;
  #23 D = 1'b0;
  #21 D = 1'b1;
  #2  D = 1'b0;
  #44 D = 1'b1;
  #20;
  $finish;
end

endmodule
