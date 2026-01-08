`timescale 1ns/100ps

module xor_gate_tb();
reg X1, X2;
wire Q;

xor_gate XOR_GATE_TB(.x1(X1), .x2(X2), .q(Q));

always
begin
  #10 X1 <= 1'b0;//X1=0
  #11 X2 <= 1'b0;//X1=0, X2=0
  #20 X1 <= 1'b1;//X1=1, X2=0
  #30 X2 <= 1'b1;//X1=1, X2=1
  #40 X1 <= 1'b0;//X1=0, X2=1
  #50 X2 <= 1'b0;//X1=0, X2=0
  #60

  $finish;
end

initial
$monitor("X1=%d, X2=%d, Q=%d", X1, X2, Q);

endmodule
