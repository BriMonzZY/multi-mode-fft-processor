// Author: brimonzzy
// Create Date: 2025/2/13
// Description: Complex switch module

module switch (
  input sel,
  input signed [15:0] x0_re,
  input signed [15:0] x0_im,
  input signed [15:0] x1_re,
  input signed [15:0] x1_im,
  output signed [15:0] y0_re,
  output signed [15:0] y0_im,
  output signed [15:0] y1_re,
  output signed [15:0] y1_im
);

  assign y0_re = sel ? x1_re : x0_re;
  assign y0_im = sel ? x1_im : x0_im;
  assign y1_re = sel ? x0_re : x1_re;
  assign y1_im = sel ? x0_im : x1_im;

endmodule
