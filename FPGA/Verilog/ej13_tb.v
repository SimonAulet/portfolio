`timescale 1ns/100ps

module MUX41_TB();

reg  [3:0] X;
reg  [1:0] SEL;
wire       Y;

mux_41 mux( .x(X), .sel(SEL), .y(Y));

initial
begin
  X = 4'b0000;
  SEL = 2'b00;
end

always
begin
    #20;
    X       = 4'b0000;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;
    #20;
    X       = 4'b0101;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;
    #20;
    X       = 4'b1010;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;
    #20;
    X       = 4'b1111;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;
    #20;
    X       = 4'b0011;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;
    #20;
    X       = 4'b1100;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;
    #20;
    X       = 4'b0110;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;
    #20;
    X       = 4'b1001;
    #10 SEL = 2'b00;
    #10 SEL = 2'b01;
    #10 SEL = 2'b10;
    #10 SEL = 2'b11;

  $finish;
end

endmodule
