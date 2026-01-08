// Ejercicio 17 - Contador binario de 4 bits : que cuente de 0 a 15 en cada flanco de reloj.
//
module contador_4(
  input  wire rst,
  input  clk,
output wire [3:0] q
);
reg [3:0] state;
assign q = state;

initial
  state = 4'b0000;

always@(posedge clk or rst)
  if(rst)
    state <= 4'b0000;
  else
    state <= state+1;

endmodule
