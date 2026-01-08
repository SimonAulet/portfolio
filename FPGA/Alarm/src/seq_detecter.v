`timescale 1ns / 1ps

module seq_detecter(
  input wire b1,
  input wire b2,
  input wire b3,

  input wire check,
  input wire clk,

  // output wire [1:0] state_check, // for testbench
  output reg seq,
  output wire enable
);

// State machine states
localparam IDLE   = 2'b00;
localparam GOT_P1 = 2'b01;
localparam GOT_P2 = 2'b10;
localparam DETECT = 2'b11;

reg [1:0] state, next_state;
reg enable_reg;

// assign state_check = state; // for testbench
assign enable      = enable_reg;

initial begin
  state      = IDLE;
  next_state = IDLE;
  seq        = 1'b0;
  enable_reg = 1'b0;
end

// State register
always @(posedge clk) begin
  state <= next_state;
end

// output logic
always@(posedge clk)begin
  if(check) begin
    enable_reg <= 1'b1;
  end
  else
    enable_reg <= 1'b0;

  seq <= (state == DETECT);
end

// Next state logic
always @(*) begin
  // Default assignment to avoid latches
  next_state = state;

  case(state)
    IDLE:
    begin
      seq = 1'b0;
      if (b1)
        next_state = GOT_P1;      // b1 pulse detected
      else
        next_state = IDLE;        // Wait for b1
    end
    GOT_P1:
    begin
      seq = 1'b0;
      if (b2)
        next_state = GOT_P2;      // b2 pulse detected
      else if (b1 || b3)
        next_state = IDLE;        // Wrong button
      else
        next_state = GOT_P1;      // Wait for b2
    end
    GOT_P2:
    begin
      seq = 1'b0;
      if (b3)
        next_state = DETECT;      // b3 pulse detected
      else if (b1 || b2)
        next_state = IDLE;        // Wrong button
      else
        next_state = GOT_P2;      // Wait for b3
    end
    DETECT:
      if (check)begin
        next_state = IDLE;        // Check pressed
       end
      else begin
        next_state = DETECT;      // Stay in detect
      end
    default:
      next_state = IDLE;          // Safe default
  endcase
end

endmodule
