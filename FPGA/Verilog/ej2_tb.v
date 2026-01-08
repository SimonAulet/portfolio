`timescale 1ns/100ps
module ej2_tb();

reg X1, X2;
wire Q;

and_2 AND_2_TB(.x1(X1), .x2(X2), .q(Q));

initial
begin
  #2 X1 = 0;
  #3 X2 = 0;
end

always
begin
  #10 X1 <= 1'b0;
  #11 X2 <= 1'b0;
  #20 X1 <= 1'b1;
  #30 X2 <= 1'b1;
  #40 X1 <= 1'b0;
  #60 X1 <= 1'b0;

  $finish;
end
initial
$monitor($time, "X1=%d, X2=%d, Q=%d", X1, X2, Q);

endmodule
