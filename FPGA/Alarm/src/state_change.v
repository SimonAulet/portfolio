module state_change(
  input   seq,
  input   mov,
  input   enable,
  input   clk,

  output wire [1:0] state
);

reg [1:0] state_reg, next_state;
// State machine states
localparam UNARMED = 2'b00;
localparam ARMED   = 2'b01;
localparam ALARM   = 2'b10;

assign state = state_reg;

initial begin
  state_reg = UNARMED;
end

always@(posedge clk)begin
  state_reg <= next_state;
end
// state changes
always@(*) begin
  case(state_reg)
  UNARMED:
  begin
    if(enable)
      next_state = seq ? ARMED : UNARMED;
    else
      next_state = UNARMED;
  end
  ARMED:
  begin
    if(enable)
      next_state = seq ? UNARMED : ALARM;
    else if(mov)
      next_state = ALARM;
    else
      next_state = ARMED;
  end
  ALARM:
  begin
    if(enable)
      next_state = seq ? UNARMED : ALARM;
    else
      next_state = ALARM;
  end

  default: next_state <= UNARMED;
  endcase
end

endmodule
