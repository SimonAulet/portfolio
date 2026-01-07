`timescale 1ns / 100ps

module COMPARATOR_TB();

reg [3:0] X1;
reg [3:0] X2;

wire LES, EQ, BIG;

comparator COMP_DUT(.x1(X1), .x2(X2), .big(BIG), .eq(EQ), .les(LES));
initial
begin
  X1 = 0;
  X2 = 0;
  #10 X1 = 5; //X1>X2 -> big
  #10 X2 = 5; //X1=X2 -> eq
  #10 X1 = 1; //X1<X2 -> les
  #10 X2 = 0; //X1>X2 -> big
  #10;
  $finish;
end
endmodule
