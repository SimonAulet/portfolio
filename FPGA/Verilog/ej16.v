// Ejercicio 16 - Flip-Flop tipo D: sensible al flanco de subida.

module flipflopD(
  input wire  d,
  input wire  clk,
  output wire q,
  output wire qnot
);
//En este caso no hago todo el diagrama como el libro. Sin embargo, se observa que,
// por ser un flipflop, necesito si o si registros, no puedo asignar los wires

reg state;
assign q = state;
assign qnot = ~state;

always@(posedge clk)
  state <= d;

endmodule
