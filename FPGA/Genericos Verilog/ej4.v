//Ejercicio 4 - Diseñar un módulo con operación XOR.

module xor_gate(
input wire x1,
input wire x2,
output wire q
);

reg aux;
assign q = aux;
always@(*)
begin
  aux = x1 || x2;
  if(x1&&x2)
    aux = 1'b0;
end

endmodule
