// Ejercicio 13 - Multiplexor 4:1.

module mux_41(
  input wire [3:0] x,
  input wire [1:0] sel,
  output wire y
);

assign y = x[sel];

endmodule
