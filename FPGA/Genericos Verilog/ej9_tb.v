`timescale 1ns/100ps

module HALF_ADDER_TB();

reg A, B;
wire S, C;
reg CLK;
integer i;

half_adder HALF_ADDER_DUT(.a(A), .b(B), .s(S), .c(C), .clk(CLK));

initial
begin
  CLK = 1'b0;
  for (i=0; i<10; i = i+1)
    #10 CLK = ~CLK;
  $finish;
end

initial
begin
  A = 0;
  B = 0;
end

always
begin
  #5  A = 1; //s=1, c=0
  #10 B = 1; //s=0, c=1
  #10 A = 0; //s=1, c=0
  #10 B = 0; //s=0, c=0
end

endmodule
