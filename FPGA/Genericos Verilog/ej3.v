//Ejercicio 3 - Módulo que implemente una OR de tres entradas.

module or_gate(
  input wire  x1,
  input wire  x2,
  input wire  x3,
  output wire q
);
reg salida;
assign q = salida;

always@(*)
begin
  if(x1 || x2 || x3)
    salida = 1'b1;
  else
    salida = 1'b0;
end

endmodule
