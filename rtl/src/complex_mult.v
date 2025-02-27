// Author: brimonzzy
// Create Date: 2025/2/13
// Description: Complex multiplier
//              Complex Adder
//              Complex Subtractor

module complex_mult #(
  parameter useGauss = 0
)(
  input signed [15:0] x0_re,
  input signed [15:0] x0_im,
  input signed [15:0] x1_re,
  input signed [15:0] x1_im,
  output signed [15:0] res_re,
  output signed [15:0] res_im
);

  function signed [15:0] saturate(input signed [18:0] value);
  begin
    if (value > 32767)        saturate = 16'h7FFF;
    else if (value < -32768)  saturate = 16'h8000;
    else                      saturate = value[15:0];
  end
  endfunction

  generate
  if(useGauss) begin
    // k1 = x1_re * (x0_re + x0_im);
    // k2 = x0_re * (x1_im - x1_re);
    // k3 = x0_im * (x1_re + x1_im);
    // res_re = k1 - k3;
    // res_im = k1 + k2;
    // Intermediate sums and differences (17-bit to handle overflow)
    wire signed [16:0] sum_x0 = x0_re + x0_im;
    wire signed [16:0] diff_x0 = x0_re - x0_im;
    wire signed [16:0] sum_x1 = x1_re + x1_im;
    wire signed [16:0] diff_x1 = x1_re - x1_im;

    // Extend to 32 bits for multiplication
    wire signed [31:0] k1 = sum_x0 * x1_re;    // Q15 * Q15 = Q30
    wire signed [31:0] k2 = diff_x0 * x1_im;   // Q15 * Q15 = Q30
    wire signed [31:0] k3 = x0_im * sum_x1;    // Q15 * Q15 = Q30

    // Adjust back to Q15 format
    assign res_re = (k1 - k3) >>> 15;
    assign res_im = (k1 + k2) >>> 15;

  end else begin
    // res_re = x0_re * x1_re - x0_im * x1_im;
    // res_im = x0_re * x1_im + x0_im * x1_re;
    // Multiply components (results are in Q30 format)
    wire signed [31:0] mul_re_re = x0_re * x1_re;
    wire signed [31:0] mul_im_im = x0_im * x1_im;
    wire signed [31:0] mul_re_im = x0_re * x1_im;
    wire signed [31:0] mul_im_re = x0_im * x1_re;

    wire signed [32:0] sub_re = {mul_re_re[31], mul_re_re} - {mul_im_im[31], mul_im_im};
    wire signed [32:0] add_im = {mul_re_im[31], mul_re_im} + {mul_im_re[31], mul_im_re};

    // Adjust back to Q15 format
    assign res_re = saturate(sub_re >>> 15);
    assign res_im = saturate(add_im >>> 15);

  end
  endgenerate

endmodule

module complex_add (
  input signed [15:0] x0_re,
  input signed [15:0] x0_im,
  input signed [15:0] x1_re,
  input signed [15:0] x1_im,
  output signed [15:0] res_re,
  output signed [15:0] res_im
);

  assign res_re = x0_re + x1_re;
  assign res_im = x0_im + x1_im;

endmodule

module complex_sub (
  input signed [15:0] x0_re,
  input signed [15:0] x0_im,
  input signed [15:0] x1_re,
  input signed [15:0] x1_im,
  output signed [15:0] res_re,
  output signed [15:0] res_im
);

  assign res_re = x0_re - x1_re;
  assign res_im = x0_im - x1_im;

endmodule

