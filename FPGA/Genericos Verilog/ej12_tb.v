`timescale 1ns/100ps

module NIBBLE_ALU_TB();

reg  [3:0] A, B;
wire [3:0] S;
wire COUT, VALID;
reg[1:0] OP;
reg CLK;

wire[4:0] S_RESTA;//variable para visualizar resta en waveform

integer i;

nibble_alu NIBBLE_ALU_DUT( .a(A), .b(B), .op(OP), .s(S), .cout(COUT), .valid(VALID), .clk(CLK) );

initial
begin
  CLK = 1'b0;
  for (i=0; i<500; i = i+1)
    #5 CLK = ~CLK;
end

assign S_RESTA = {COUT, S};

initial
begin
    A  = 4'd0;
    B  = 4'd0;
    OP = 2'b00;
end

always
begin
    #100;
    OP = 2'b00; //suma
    A  = 4'd7;
    B  = 4'd2;

    #100;
    OP = 2'b01;//resta con salida positiva
    A  = 4'd10;
    B  = 4'd3;

    #100;
    OP = 2'b01;//resta con salida negativa
    A = 4'd5;
    B = 4'd9;
    #100;

    OP = 2'b10;//and bit a bit
    A = 4'b1111;
    B = 4'b0101;
    #100;

    OP = 2'b10;//and bit a bit
    A = 4'b1010;
    B = 4'b0110;
    #100;

    OP = 2'b11;//or bit a bit
    A = 4'b0010;
    B = 4'b1010;
    #100;

    A = 4'b0000;
    B = 4'b1111;
    #100;

  $finish;
end

endmodule
