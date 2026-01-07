
`timescale 1ns/100ps

//verible_lint waive module-filename
module MUX_TB();
reg IN1, IN2, SEL, CLK;
wire OUT;
integer i;

mux DUT(.in1(IN1), .in2(IN2), .sel(SEL), .clk(CLK), .out(OUT));

initial
begin
  #5 CLK = 0;
  for(i=0; i<20; i=i+1)
  #10 CLK = ~CLK;

  $finish;
end

initial
begin
  IN1      = 1'b0;
  IN2      = 1'b1;
  #100 IN1 = 1'b1;
       IN2 = 1'b0;
end

always
begin

  SEL = 1'b0;
  #20 SEL = 1'b1;
  #20 SEL = 1'b0;

end

initial
$monitor("IN1=%d, IN2=%d, SEL=%d, aux=%d, OUT=%d", IN1, IN2, SEL,DUT.aux, OUT);

endmodule
