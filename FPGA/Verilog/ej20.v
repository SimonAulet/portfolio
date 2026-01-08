// Ejercicio 20 - Diseñar una FSM Moore que detecte la secuencia "101" en una entrada serial (din).
// La FSM tiene una entrada de datos (din), reloj (clk) y reset (rst).
// La salida (det) vale 1 solo cuando se ha detectado la secuencia "101".
// Si aparece la secuencia, la máquina sigue buscando solapamientos (ej: en 10101, detecta 2 veces).

module detector_secuencias(
  input  din,
  input  clk,
  input  rst,
  output det);

reg [1:0] estado; //cuatro estados posibles;  mirar diagrama

assign det = &estado; // la salida es 1 cuando el estado es 11

initial
estado <= 2'b00;

always@(posedge clk or posedge rst)
begin
  if(rst==1)
    estado <= 2'b00; // reset asíncrono
  else
  begin
    case (estado)
    2'b00: estado <= (din) ? 2'b01 : 2'b00;
    2'b01: estado <= (din) ? 2'b01 : 2'b10;
    2'b10: estado <= (din) ? 2'b11 : 2'b00;
    2'b11: estado <= (din) ? 2'b01 : 2'b10;
    default: estado <= 2'b00;
    endcase
  end
end

endmodule
