`timescale 1ns/100ps
module or_gate_tb();

reg X1, X2, X3;
wire Y;

or_gate DUT(.x1(X1), .x2(X2), .x2(X2), .q(Y));

initial
begin
  X1 <= 1'b0;
  X2 <= 1'b0;
  X3 <= 1'b0;
end
always
begin
    #10 X1 <= 1'b0;
        X2 <= 1'b0;
        X3 <= 1'b0;
    #10 X1 <= 1'b0;
        X2 <= 1'b0;
        X3 <= 1'b1;
    #10 X1 <= 1'b0;
        X2 <= 1'b1;
        X3 <= 1'b0;
    #10 X1 <= 1'b0;
        X2 <= 1'b1;
        X3 <= 1'b1;
    #10 X1 <= 1'b1;
        X2 <= 1'b0;
        X3 <= 1'b0;
    #10 X1 <= 1'b1;
        X2 <= 1'b0;
        X3 <= 1'b1;
    #10 X1 <= 1'b1;
        X2 <= 1'b1;
        X3 <= 1'b0;
    #10 X1 <= 1'b1;
        X2 <= 1'b1;
        X3 <= 1'b1;
    #10
      X1 <= 1'b0;
      X2 <= 1'b0;
      X3 <= 1'b0;
    #10
  $finish;
end

initial
$monitor("X1=%d, X2=%d, Y=%d", X1, X2, Y);

endmodule
