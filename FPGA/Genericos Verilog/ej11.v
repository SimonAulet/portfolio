//Ejercicio 11 - Sumador de 4 bits en cascada: usando full adders.
//Se toma el enfoque de sumadores sin acarreo anticipado

module nibble_adder(
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] s,
  output wire       cout,
  output wire       valid,//valid indica salida valida sin transiciones de accarreo ocurriendo
  input             clk
);

wire [3:0] cin_aux;
wire [3:0] cout_aux;

reg valid_state;
reg[1:0] valid_count;

full_adder FA4(.a(a[3]), .b(b[3]), .cin(cin_aux[3]), .s(s[3]), .cout(cout_aux[3]), .clk(clk));
full_adder FA3(.a(a[2]), .b(b[2]), .cin(cin_aux[2]), .s(s[2]), .cout(cout_aux[2]), .clk(clk));
full_adder FA2(.a(a[1]), .b(b[1]), .cin(cin_aux[1]), .s(s[1]), .cout(cout_aux[1]), .clk(clk));
full_adder FA1(.a(a[0]), .b(b[0]), .cin(cin_aux[0]), .s(s[0]), .cout(cout_aux[0]), .clk(clk));

assign cout       = cout_aux[3];
assign cin_aux[3] = cout_aux[2];
assign cin_aux[2] = cout_aux[1];
assign cin_aux[1] = cout_aux[0];
assign cin_aux[0] = cin;

assign valid = valid_state;

//Frente a un cambio en la entrada, deshabilita la validez de la salida
always@(a, b)
begin
  valid_state = 1'b0;
  valid_count = 2'b00;
end

//Cuento hasta 4 para habilitar la salida
always@(posedge clk)
begin
  valid_state <= &valid_count; //valid_state = 1 cuando count=11 (pasaron 4 clk desde cambio)
  if(valid_count!=2'b11) //incremento cuando valid_state=0. evaluo valid_count por sincronizacion
    valid_count <= valid_count+1;
end

endmodule
