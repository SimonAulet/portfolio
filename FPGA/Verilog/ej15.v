// Ejercicio 15 - Latch tipo D: sensible al nivel.

module latchD(
input wire D,
input wire E,
output wire Q,
output wire Qnot
);

// Podría implementar solo la lógica pero como estoy manija implemento
// el mismo diagrama del libro :)))

wire w1, w2, w3, w4, w5, w6;

//Entradas
assign w1 = D;
assign w2 = E;
//Lógica del diagrama
assign w3 = ~(w1 && w2);
assign w4 = ~(w2 && ~w1);
assign w5 = (~w6 || ~w4);
assign w6 = (~w3 || ~w5);
//Salidas
assign Q = w6;
assign Qnot = w5;

endmodule
