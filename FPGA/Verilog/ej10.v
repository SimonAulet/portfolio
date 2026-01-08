// Ejercicio 10 - Sumador completo (full adder): con acarreo de entrada y salida.

module full_adder(
  input  wire a,
  input  wire b,
  input  wire cin,
  input  wire clk,

  output wire s,
  output wire cout
);

wire a1, b1, a2, b2;
wire s1, c1, s2, c2;

half_adder hadder1(.a(a1), .b(b1),   .s(s1), .c(c1), .clk(clk));
half_adder hadder2(.a(a2), .b(b2),   .s(s2), .c(c2), .clk(clk));

assign a1 = a;
assign b1 = b;
assign a2 = s1;
assign b2 = cin;

assign s  = s2;
assign cout = c1 || c2;

endmodule
