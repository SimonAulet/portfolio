module ej1_tb();
reg A;
wire Y;
integer i;

ej1 INOUT(.a(A), .y(Y));

initial
begin
  #3 A = 1;
end

initial
begin
  for(i=0; i<20; i=i+1)
  #10 A = ~A;
  $finish;
end
initial
$monitor($time, "A=%d, Y=%d", A, Y);
endmodule
