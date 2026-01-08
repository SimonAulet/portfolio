`timescale 1ns/100ps

module NIBBLE_ADDER_TB();

reg  [3:0] A, B;
reg        CIN;
wire [3:0] S;
wire COUT, VALID;
reg CLK;
integer i;

nibble_adder NIBBLE_ADDER_DUT( .a(A), .b(B), .cin(CIN), .s(S), .cout(COUT), .valid(VALID), .clk(CLK) );

initial
begin
  CLK = 1'b0;
  for (i=0; i<500; i = i+1)
    #5 CLK = ~CLK;
end

initial
begin
    A = 4'd0;
    B = 4'd0;
    CIN = 1'b0;
end

always
begin
    #100;
    A = 4'd7;
    B = 4'd2;
    #100;

    A = 4'd3;
    B = 4'd10;
    #100;

    A = 4'd5;
    B = 4'd9;
    #100;

    A = 4'd12;
    B = 4'd4;
    #100;

    A = 4'd1;
    B = 4'd15;
    #100;

    A = 4'd8;
    B = 4'd6;
    #100;

    A = 4'd15;
    B = 4'd15;
    #100;

  $finish;
end

endmodule
