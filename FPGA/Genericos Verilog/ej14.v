// Ejercicio 14 - Demultiplexor 1:4.


module demux_14(//No se consideran los estados no-seleccionados; se dejan en estado previo
input  wire      x,
input  wire[1:0] sel,
input  wire      clk,

output reg[3:0] y
);
initial
  y = 4'b0000;

always@(posedge clk)
  y[sel] <= x;

endmodule
