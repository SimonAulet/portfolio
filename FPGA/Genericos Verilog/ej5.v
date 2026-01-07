//Ejercicio 5 - Implementar un MUX de 2 entradas y 1 salida con señal de selección.
module mux(
input  wire in1,
input  wire in2,
input  wire sel,
input  wire clk,
output wire out
);
reg aux;
assign out = aux;

always@(posedge clk)
begin
  if(sel)
    aux = in2;
  else
    aux = in1;
end
endmodule
