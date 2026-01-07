//Ejercicio 1 - Diseñar un módulo que solo conecte una entrada "a" a una salida "y".

module ej1(
  input a,
  output reg y);

always @(*)
begin
  y <= a;
end
endmodule
