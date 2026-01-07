// Ejercicio 8 - Comparador de 2 números (4 bits): Salidas para mayor, igual, menor.

module comparator(
input  wire [3:0] x1,
input  wire [3:0] x2,
output wire big,
output wire eq,
output wire les
);
reg [2:0] result;

assign les = result[2];
assign eq  = result[1];
assign big = result[0];

always@(*)
begin
  if (x1 < x2)
    result = 3'b100;//les on
  else if(x1 == x2)
    result = 3'b010;//eq on
  else if (x1 > x2)
  result =   3'b001;//big on
  else
    result = 3'b000;//no imput
end

endmodule
