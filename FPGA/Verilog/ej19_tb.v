module ej19_tb();

reg [7:0] X;
reg       SH_LD;
reg       CLK;
wire      Y;

integer   i;

srg_4 SRG_TB(.x(X), .sh_ld(SH_LD), .clk(CLK), .y(Y));

initial
begin
  CLK   = 1'b0;
  X     = 8'd0;
  SH_LD = 1'b1;
end

initial
begin
  for (i=0; i<500; i=i+1)
    #5 CLK = ~CLK;
end

initial
begin
  #6  SH_LD = 1'b0;// LOAD
  #1  X = 8'b11111111;
  #20 SH_LD = 1'b1;// SHIFT
  #100;
  #3  SH_LD = 1'b0;// LOAD
  #2  X = 8'b11111111;
  #20 SH_LD = 1'b1;// SHIFT
  #50 SH_LD = 1'b0;// LOAD
  #2  X = 8'b10101010;
  #20 SH_LD = 1'b1;// SHIFT
  #120;
  $finish();
end
endmodule
