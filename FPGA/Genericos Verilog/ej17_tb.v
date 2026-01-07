`timescale 1ns/100ps

module ej17_tb();

reg CLK, RST;
wire [3:0] Q;
integer i;

contador_4 CONTADOR_4_TB(.q(Q), .rst(RST), .clk(CLK));

initial
begin
  CLK = 1'b0;
  i   = 1'b0;
  RST = 1'b0;
end

initial
begin
  for(i=0; i<50; i=i+1)
  begin
    #10;
    CLK = ~CLK;
  end
  $finish;
end
initial
begin
  #20 RST = 1'b1;
  #5  RST = 1'b0;
  #50 RST = 1'b1;
  #52 RST = 1'b0;
end

endmodule
