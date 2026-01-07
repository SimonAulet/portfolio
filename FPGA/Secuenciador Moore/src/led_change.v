module led_change(
  input  wire[1:0] state,
  input  wire      clk,
  input  wire      tick_lf,
  output reg       led_a,
  output reg       led_b
);

initial
begin
  led_a = 1'b0;
  led_b = 1'b0;
end

always@(posedge clk)
  case(state)
  2'b00:
  begin
    led_a <= 0;
    led_b <= 0;
  end
  2'b01:
  begin
    if(tick_lf)
      led_a <= ~led_a;
    else
      led_a <= led_a;
    led_b <= 0;
  end
  2'b10:
  begin
    led_a <= 0;
    if(tick_lf)
      led_b <= ~led_b;
    else
      led_b <= led_b;
  end
  2'b11:
  begin
    if(tick_lf)
      led_a <= ~led_a;
    else
      led_a <= led_a;
      led_b <= led_a;  //copy led_a to avoid mirror blink
  end
  default:
  begin
    led_a <= 0;
    led_b <= 0;
  end
endcase

endmodule
