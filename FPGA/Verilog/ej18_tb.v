`timescale 1ns/100ps

module ej18_tb();

reg [7:0]N;
reg RST, CLK;
wire[7:0] Q;
integer i;

initial
begin
  i   = 0;
  RST = 1'b0;
  CLK = 1'b0;
  N   = 8'd5;
end

contador_N CONTADOR_N_TB(.N(N), .rst(RST), .clk(CLK), .Q(Q));

initial
begin
  for(i=0; i<300; i=i+1)
    #10 CLK = ~CLK;
  $finish;
end
initial
begin
  #210 N  = 8'd20;
  #400 RST = 1'b1;
  #2  RST = 1'b0;
  #1  N   = 8'd100;
end
endmodule
