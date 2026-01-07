//Ejercicio 9 - Sumador de 1 bit (half adder).
module half_adder(
input  wire a,
input  wire b,
input wire clk,
output wire s,
output wire c);

reg sum;
reg carry;

assign s = sum;
assign c = carry;

always@(posedge clk)
begin
  if((a && b))
  begin
    sum   <= 1'b0;
    carry <= 1'b1;
  end
  else
  begin
    carry <= 1'b0;
    if(a || b)
      sum <= 1'b1;
    else
      sum <= 1'b0;
  end
end

endmodule
