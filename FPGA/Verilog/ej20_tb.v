`timescale 1ns/100ps

module ej20_tb();

reg X, RST, CLK;
wire Y;
integer i;

detector_secuencias DETECTOR_SECUENCIAS_TB(
  .din(X),
  .rst(RST),
  .clk(CLK),
  .det(Y)
);

initial
begin
  X   = 0;
  RST = 0;
  CLK = 0;

  for(i=0; i<100; i=i+1)//25 períodos de reloj
    #10 CLK = ~CLK;

  $finish;
end

initial
begin
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); RST = 1;
    @(negedge CLK); RST = 0;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 1;
    @(negedge CLK); X   = 0;
    @(negedge CLK); X   = 0;
end

endmodule
