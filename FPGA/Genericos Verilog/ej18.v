// Ejercicio 18 - Contador módulo-N: parametrizable.

module contador_N(
  input wire[7:0]  N,
  input wire       rst,
  input wire       clk,
  output wire[7:0] Q //Determino que cuenta hasta máximo 256
);

reg [7:0] state;
assign Q = state;

always@(posedge clk or rst)
begin
  if(rst)
    state <= 8'b00000000;
  if( (state < N) && (!rst) )
    state <= state+1;
  else
    state <= 8'b00000000;
end

endmodule
