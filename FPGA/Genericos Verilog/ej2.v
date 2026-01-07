//Ejercicio 2 - Diseñar una compuerta AND con dos entradas y una salida.

module and_2(
input x1,
input x2,
output q);

assign q = aux; //pruebo para usar wires en la salida
reg aux;        //registro generado después del assign para probar la concurrencia
always@(*)
begin
  aux <= x1 && x2;
end

endmodule
