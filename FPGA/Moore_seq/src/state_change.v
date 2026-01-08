module state_change(
  input            btn,
  input            tick_mf,
  input            clk,
  output reg [1:0] state
);

reg [5:0] counter;
reg       btn_press;
reg       btn_stable;
reg [1:0] next_state;

initial begin
  counter    = 0;
  btn_press  = 0;
  btn_stable = 0;
  state      = 2'b00;
end

// Anti-bounce circuit
always @(posedge clk) begin
  if (btn != btn_stable) begin
    if (tick_mf) begin
      if (counter == 6'd20) begin  // 20 ticks at 1kHz = 20ms
        btn_stable <= btn;
        counter    <= 0;
      end else begin
        counter <= counter + 1;
      end
    end
  end else begin
    counter <= 0;
  end
end

// change on btn release circuit
always@(posedge clk) begin
  if(btn_stable) begin //btn is on
    btn_press <= 1;
  end
  else begin
    if(btn_press)begin // btn is off but has been pressed
      state     <= next_state;
      btn_press <= 1'b0;
    end
    else //btn is off and hasn't been pressed
      state <= state;
  end
end

// state changes
always@(posedge clk) begin
  case(state)
  2'b00: next_state   <= 2'b01;
  2'b01: next_state   <= 2'b10;
  2'b10: next_state   <= 2'b11;
  2'b11: next_state   <= 2'b00;
  default: next_state <= 2'b00;
  endcase
end

endmodule
