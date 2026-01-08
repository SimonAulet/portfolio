`timescale 1ns/100ps

module DEMUX_14_TB();

reg X, CLK;
reg [1:0] SEL;
wire [3:0] Y;

integer i;
demux_14 DEMUX_14_TB(.x(X), .sel(SEL), .y(Y), .clk(CLK));

initial
begin
  X   = 1'b0;
  CLK = 1'b0;
  for(i=0; i<500; i=i+1)
  begin
    #5
    CLK = ~CLK;
  end
end

initial
begin
  #20 X = 1'b1;
      SEL = 2'b00;
  #22 SEL = 2'b01;
  #11 SEL = 2'b10;
  #33 SEL = 2'b11;
  #15 X   = 1'b0;
  #17 SEL = 2'b10;
  #20 SEL = 2'b01;
  #33 SEL = 2'b00;
  #20 $finish();
end

endmodule
