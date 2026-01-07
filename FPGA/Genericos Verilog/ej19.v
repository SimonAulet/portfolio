// Ejercicio 19 - Registro de desplazamiento de 8 bits: con carga paralela y desplazamiento hacia la izquierda.

module srg_4(
  input  wire[7:0] x,
  input  wire      sh_ld, //1=shift / 0=load
  input  wire      clk,
  output wire      y
);

reg [7:0]  buffer;
reg        serial_output;
wire       shift;
wire       load;

assign y = serial_output;
assign shift = sh_ld;
assign load  = ~sh_ld;

initial
  buffer = 8'd0;

always@(posedge clk)
begin
  if(load)
    buffer <= x;
  else if(shift)
  begin
    serial_output <= buffer[7];//desplazamiento a la izquierda, sale MSB
    buffer <= buffer << 1;
  end
  else
    buffer <= 8'b00000000;
end

endmodule
