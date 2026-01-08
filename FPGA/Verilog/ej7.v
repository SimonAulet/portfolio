//Ejercicio 7 - Codificador 8:3: Con 8 entradas y 3 salidas.

`timescale 1ns/100ps

module encoder83(
  input wire[7:0] x,
  output reg[2:0] y
);

always@(*)
casex(x) // Encoder de prioridad, solo toma la salida más alta ignorando el resto
  8'b1xxxxxxx: y = 7;
  8'b01xxxxxx: y = 6;
  8'b001xxxxx: y = 5;
  8'b0001xxxx: y = 4;
  8'b00001xxx: y = 3;
  8'b000001xx: y = 2;
  8'b0000001x: y = 1;
  8'b00000001: y = 0;
  default    : y = 0;
endcase

endmodule
