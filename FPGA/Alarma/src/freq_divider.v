// Pulse generator at 1kHz and 1 Hz

module freq_divider #(
  parameter mf_divider = 100_000,
  parameter lf_divider = 1_000
)(
input  wire clk_in,
output reg  tick_mf,
output reg  tick_lf
);

reg [18:0] mf_counter;
reg [8:0] lf_counter;

initial
begin
  tick_mf    = 0;
  tick_lf    = 0;
  mf_counter = 0;
  lf_counter = 0;
end

// Counter advancing
always @(posedge clk_in)
begin
  if (mf_counter == mf_divider - 1) //mf counter. division is for switching posedge and negedge
  begin
    mf_counter    <= 0;
    if(lf_counter == lf_divider - 1) //lf counter
      lf_counter  <= 0;
    else
      lf_counter <= lf_counter + 1;
  end else begin
    mf_counter   <= mf_counter + 1;
  end
end

// Freq divider lf
always @(posedge clk_in)
begin
  if((lf_counter == 0) && (mf_counter==0))
    tick_lf <= 1'b1;
  else
    tick_lf <= 1'b0;
end
// Freq divider mf
always@(posedge clk_in)
begin
  if(mf_counter == 0)
    tick_mf <= 1'b1;
  else
    tick_mf <= 1'b0;
end

endmodule
