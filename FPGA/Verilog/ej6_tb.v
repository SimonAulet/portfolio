`timescale 1ns/100ps

module DECODER2_4_TB();

reg [1:0] X;
wire [3:0] Y;

decoder2_4 DUT(.x(X), .y(Y));

initial
begin
  #10 X = 2'b00;
  #10 X = 2'b01;
  #10 X = 2'b10;
  #10 X = 2'b11;
  #10;
  $finish;
end

endmodule
