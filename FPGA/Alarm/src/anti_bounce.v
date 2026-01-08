module anti_bounce(
  input btn_in,
  input tick_mf,
  input clk,

  output btn_out,
  output [5:0] counter_test,
  output       btn_stable_test,
  output       btn_prev_test
);

reg [5:0] counter;
reg       btn_stable;
reg       btn_prev;
reg       btn_out_reg;

assign counter_test = counter;
assign btn_stable_test = btn_stable;
assign btn_prev_test = btn_prev;

assign btn_out = btn_out_reg;

initial begin
  counter     = 0;
  btn_stable  = 0;
  btn_prev    = 0;
  btn_out_reg = 0;
end

// Anti-bounce circuit
always @(posedge clk) begin
  if (btn_in != btn_stable) begin
    if (tick_mf) begin
      if (counter == 6'd20) begin  // 20 ticks at 1kHz = 20ms
        btn_stable <= btn_in;
        counter    <= 0;
      end else begin
        counter <= counter + 1;
      end
    end
  end else begin
    counter <= 0;
  end
end

// Pulse on button release
always @(posedge clk) begin
  btn_prev <= btn_stable;

  // Detect falling edge (button release)
  if (btn_prev && !btn_stable) begin
    btn_out_reg <= 1'b1;
  end else begin
    btn_out_reg <= 1'b0;
    end
end

endmodule
