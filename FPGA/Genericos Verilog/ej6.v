//Ejercicio 6 - Decodificador 2:4: Con 2 bits de entrada y 4 salidas.

module decoder2_4(
  input [1:0] x,
  output reg [3:0] y
);

initial
  y = 4'b0000;

always@(*)
begin
  y    = 4'b0000;
  y[x] = 1'b1;
end

endmodule
