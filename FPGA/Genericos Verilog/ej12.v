//Ejercicio 12 - ALU simple de 4 bits: que realice suma, resta, AND y OR (seleccionado con un opcode).

module nibble_alu(
  input wire[3:0] a,
  input wire[3:0] b,
  input wire[1:0] op,
  input wire      clk,

  output wire[3:0] s,
  output wire      cout,
  output wire      valid
);

//variables manipulables segun operacion elegida
reg [3:0] a_reg, b_reg, s_reg;
reg       cin_reg;
reg       cout_reg, valid_reg;

//salidas wire a registros internos modificables
assign s     = s_reg;
assign cout  = cout_reg;
assign valid = valid_reg;

//cables auxiliares para salida de instancia de sumador
wire [3:0] s_sum;
wire cout_sum, valid_sum;

nibble_adder sumador(.a(a_reg), .b(b_reg), .cin(cin_reg),
  .s(s_sum), .cout(cout_sum), .valid(valid_sum), .clk(clk));

//codigos de operacion
reg add_op;    // op1 = add (00)
reg sub_op;    // op2 = sub (01)
reg and_op;    // op3 = and (10)
reg or_op;     // op4 = or  (11)


always@(posedge clk)
begin
  add_op <= (op==2'b00) ? 1'b1 : 1'b0;
  sub_op <= (op==2'b01) ? 1'b1 : 1'b0;
  and_op <= (op==2'b10) ? 1'b1 : 1'b0;
  or_op  <= (op==2'b11) ? 1'b1 : 1'b0;
end

always@(posedge clk)
begin
  if(add_op)
  begin
    a_reg     <= a;
    b_reg     <= b;
    cin_reg   <= 1'b0;
    s_reg     <= s_sum;
    cout_reg  <= cout_sum;
    valid_reg <= valid_sum;
  end
  else if(sub_op)
  begin
    a_reg     <= a;
    b_reg     <= ~b;
    cin_reg   <= 1'b1;
    s_reg     <= s_sum;
    cout_reg  <= ~cout_sum;
    valid_reg <= valid_sum;
  end
  else if(and_op)
  begin
    a_reg     <= a;
    b_reg     <= b;
    s_reg      <= a_reg & b_reg;
    cout_reg   <=1'b1;
    valid_reg <= 1'b1;
  end
  else if(or_op)
  begin
    a_reg     <= a;
    b_reg     <= b;
    s_reg <= a_reg | b_reg;
    cout_reg   <=1'b1;
    valid_reg <= 1'b1;
  end
end

endmodule
