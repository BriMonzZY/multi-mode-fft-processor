// Author: brimonzzy
// Create Date: 2025/2/13
// Description: Gentleman-Sande algorithm Radix-2 Butterfly unit
// module bf_rdx2 and module bf_rdx2_noW

module bf_rdx2 (
  input signed [15:0] x0_re,
  input signed [15:0] x0_im,
  input signed [15:0] x1_re, 
  input signed [15:0] x1_im,
  input signed [15:0] w_re,
  input signed [15:0] w_im,
  output signed [15:0] y0_re,
  output signed [15:0] y0_im,
  output signed [15:0] y1_re,
  output signed [15:0] y1_im
);

  wire [15:0] add1_re, add1_im, sub2_re, sub2_im, mul2_re, mul2_im;

  complex_add add1_u (
    .x0_re(x0_re),
    .x0_im(x0_im),
    .x1_re(x1_re),
    .x1_im(x1_im),
    .res_re(add1_re),
    .res_im(add1_im)
  );

  complex_sub sub2_u (
    .x0_re(x0_re),
    .x0_im(x0_im),
    .x1_re(x1_re),
    .x1_im(x1_im),
    .res_re(sub2_re),
    .res_im(sub2_im)
  );

  complex_mult mul2_u (
    .x0_re(sub2_re),
    .x0_im(sub2_im),
    .x1_re(w_re),
    .x1_im(w_im),
    .res_re(mul2_re),
    .res_im(mul2_im)
  );

  assign y0_re = add1_re;
  assign y0_im = add1_im;
  assign y1_re = mul2_re;
  assign y1_im = mul2_im;

endmodule


module bf_rdx2_noW (
  input signed [15:0] x0_re,
  input signed [15:0] x0_im,
  input signed [15:0] x1_re, 
  input signed [15:0] x1_im,
  output signed [15:0] y0_re,
  output signed [15:0] y0_im,
  output signed [15:0] y1_re,
  output signed [15:0] y1_im
);

  wire [15:0] add1_re, add1_im, sub2_re, sub2_im;

  complex_add add1_u (
    .x0_re(x0_re),
    .x0_im(x0_im),
    .x1_re(x1_re),
    .x1_im(x1_im),
    .res_re(add1_re),
    .res_im(add1_im)
  );

  complex_sub sub2_u (
    .x0_re(x0_re),
    .x0_im(x0_im),
    .x1_re(x1_re),
    .x1_im(x1_im),
    .res_re(sub2_re),
    .res_im(sub2_im)
  );

  assign y0_re = add1_re;
  assign y0_im = add1_im;
  assign y1_re = sub2_re;
  assign y1_im = sub2_im;

endmodule
