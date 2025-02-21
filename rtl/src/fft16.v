// 16-points R2MDC DIF-FFT

module fft16 (
  input clk,
  input rst_n,
  input stb, // Input data valid (active high)
  input sop_in, // The first valid data in the input stream
  input [15:0] x_re, // Input real part
  input [15:0] x_im, // Input imaginary part
  output valid_out, // Output data valid (active high)
  output sop_out, // The first valid data in the output stream
  output [15:0] y_re, // Output real part
  output [15:0] y_im // Output imaginary part
);

  wire [15:0] bf_0_x0_re;
  wire [15:0] bf_0_x0_im;
  wire [15:0] bf_0_x1_re;
  wire [15:0] bf_0_x1_im;
  wire [15:0] bf_0_w_re;
  wire [15:0] bf_0_w_im;
  wire [15:0] bf_0_y0_re;
  wire [15:0] bf_0_y0_im;
  wire [15:0] bf_0_y1_re;
  wire [15:0] bf_0_y1_im;
  wire switch_0_sel;
  wire [15:0] switch_0_x0_re;
  wire [15:0] switch_0_x0_im;
  wire [15:0] switch_0_x1_re;
  wire [15:0] switch_0_x1_im;
  wire [15:0] switch_0_y0_re;
  wire [15:0] switch_0_y0_im;
  wire [15:0] switch_0_y1_re;
  wire [15:0] switch_0_y1_im;
  wire [15:0] bf_1_x0_re;
  wire [15:0] bf_1_x0_im;
  wire [15:0] bf_1_x1_re;
  wire [15:0] bf_1_x1_im;
  wire [15:0] bf_1_w_re;
  wire [15:0] bf_1_w_im;
  wire [15:0] bf_1_y0_re;
  wire [15:0] bf_1_y0_im;
  wire [15:0] bf_1_y1_re;
  wire [15:0] bf_1_y1_im;
  wire switch_1_sel;
  wire [15:0] switch_1_x0_re;
  wire [15:0] switch_1_x0_im;
  wire [15:0] switch_1_x1_re;
  wire [15:0] switch_1_x1_im;
  wire [15:0] switch_1_y0_re;
  wire [15:0] switch_1_y0_im;
  wire [15:0] switch_1_y1_re;
  wire [15:0] switch_1_y1_im;
  wire [15:0] bf_2_x0_re;
  wire [15:0] bf_2_x0_im;
  wire [15:0] bf_2_x1_re;
  wire [15:0] bf_2_x1_im;
  wire [15:0] bf_2_w_re;
  wire [15:0] bf_2_w_im;
  wire [15:0] bf_2_y0_re;
  wire [15:0] bf_2_y0_im;
  wire [15:0] bf_2_y1_re;
  wire [15:0] bf_2_y1_im;
  wire switch_2_sel;
  wire [15:0] switch_2_x0_re;
  wire [15:0] switch_2_x0_im;
  wire [15:0] switch_2_x1_re;
  wire [15:0] switch_2_x1_im;
  wire [15:0] switch_2_y0_re;
  wire [15:0] switch_2_y0_im;
  wire [15:0] switch_2_y1_re;
  wire [15:0] switch_2_y1_im;
  wire [15:0] bf_3_x0_re;
  wire [15:0] bf_3_x0_im;
  wire [15:0] bf_3_x1_re;
  wire [15:0] bf_3_x1_im;
  wire [15:0] bf_3_y0_re;
  wire [15:0] bf_3_y0_im;
  wire [15:0] bf_3_y1_re;
  wire [15:0] bf_3_y1_im;

  wire busy;
  reg [15:0] cnt; // wide:stage+1

  assign busy = cnt != 10'd0;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      cnt <= 10'd0;
    end
    else if(sop_in)
      cnt <= 10'd1;
    else begin
      if(stb || busy) begin
        if(cnt == 10'd23) // TODO: cnt==FFTlen * 3 / 2 - 1
          cnt <= 10'd0;
        else
          cnt <= cnt + 1'b1;
      end
    end
  end


  bf_rdx2 bf_0 (
    .x0_re(bf_0_x0_re),
    .x0_im(bf_0_x0_im),
    .x1_re(bf_0_x1_re),
    .x1_im(bf_0_x1_im),
    .w_re(bf_0_w_re),
    .w_im(bf_0_w_im),
    .y0_re(bf_0_y0_re),
    .y0_im(bf_0_y0_im),
    .y1_re(bf_0_y1_re),
    .y1_im(bf_0_y1_im)
  );
  switch switch_0 (
    .sel(switch_0_sel),
    .x0_re(switch_0_x0_re),
    .x0_im(switch_0_x0_im),
    .x1_re(switch_0_x1_re),
    .x1_im(switch_0_x1_im),
    .y0_re(switch_0_y0_re),
    .y0_im(switch_0_y0_im),
    .y1_re(switch_0_y1_re),
    .y1_im(switch_0_y1_im)
  );
  bf_rdx2 bf_1 (
    .x0_re(bf_1_x0_re),
    .x0_im(bf_1_x0_im),
    .x1_re(bf_1_x1_re),
    .x1_im(bf_1_x1_im),
    .w_re(bf_1_w_re),
    .w_im(bf_1_w_im),
    .y0_re(bf_1_y0_re),
    .y0_im(bf_1_y0_im),
    .y1_re(bf_1_y1_re),
    .y1_im(bf_1_y1_im)
  );
  switch switch_1 (
    .sel(switch_1_sel),
    .x0_re(switch_1_x0_re),
    .x0_im(switch_1_x0_im),
    .x1_re(switch_1_x1_re),
    .x1_im(switch_1_x1_im),
    .y0_re(switch_1_y0_re),
    .y0_im(switch_1_y0_im),
    .y1_re(switch_1_y1_re),
    .y1_im(switch_1_y1_im)
  );
  bf_rdx2 bf_2 (
    .x0_re(bf_2_x0_re),
    .x0_im(bf_2_x0_im),
    .x1_re(bf_2_x1_re),
    .x1_im(bf_2_x1_im),
    .w_re(bf_2_w_re),
    .w_im(bf_2_w_im),
    .y0_re(bf_2_y0_re),
    .y0_im(bf_2_y0_im),
    .y1_re(bf_2_y1_re),
    .y1_im(bf_2_y1_im)
  );
  switch switch_2 (
    .sel(switch_2_sel),
    .x0_re(switch_2_x0_re),
    .x0_im(switch_2_x0_im),
    .x1_re(switch_2_x1_re),
    .x1_im(switch_2_x1_im),
    .y0_re(switch_2_y0_re),
    .y0_im(switch_2_y0_im),
    .y1_re(switch_2_y1_re),
    .y1_im(switch_2_y1_im)
  );
  bf_rdx2_noW bf_noW_1 (
    .x0_re(bf_3_x0_re),
    .x0_im(bf_3_x0_im),
    .x1_re(bf_3_x1_re),
    .x1_im(bf_3_x1_im),
    .y0_re(bf_3_y0_re),
    .y0_im(bf_3_y0_im),
    .y1_re(bf_3_y1_re),
    .y1_im(bf_3_y1_im)
  );

  twiddle_rom twiddle_rom_0 (
    .addr0(cnt[4-2-0:0]), // TODO: stage-2-i
    .addr1({cnt[4-2-1:0], 1'b0}),
    .addr2({cnt[4-2-2:0], 2'b0}),
    .data0_re(bf_0_w_re),
    .data0_im(bf_0_w_im),
    .data1_re(bf_1_w_re),
    .data1_im(bf_1_w_im),
    .data2_re(bf_2_w_re),
    .data2_im(bf_2_w_im)
  );

  assign bf_0_x1_re = x_re;
  assign bf_0_x1_im = x_im;
  assign switch_0_x0_re = bf_0_y0_re;
  assign switch_0_x0_im = bf_0_y0_im;
  assign switch_0_sel = cnt[4-2-0]; // TODO: stage-2-i
  assign bf_1_x1_re = switch_0_y1_re;
  assign bf_1_x1_im = switch_0_y1_im;
  assign switch_1_x0_re = bf_1_y0_re;
  assign switch_1_x0_im = bf_1_y0_im;
  assign switch_1_sel = cnt[4-2-1];
  assign bf_2_x1_re = switch_1_y1_re;
  assign bf_2_x1_im = switch_1_y1_im;
  assign switch_2_x0_re = bf_2_y0_re;
  assign switch_2_x0_im = bf_2_y0_im;
  assign switch_2_sel = cnt[4-2-2];
  assign bf_3_x1_re = switch_2_y1_re;
  assign bf_3_x1_im = switch_2_y1_im;

  shiftreg #(16, 8) shiftreg_0 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(x_re),
    .d_out(bf_0_x0_re)
  );
  shiftreg #(16, 8) shiftreg_1 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(x_im),
    .d_out(bf_0_x0_im)
  );

  shiftreg #(16, 4) shiftreg_2 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf_0_y1_re),
    .d_out(switch_0_x1_re)
  );
  shiftreg #(16, 4) shiftreg_3 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf_0_y1_im),
    .d_out(switch_0_x1_im)
  );

  shiftreg #(16, 4) shiftreg_4 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_0_y0_re),
    .d_out(bf_1_x0_re)
  );
  shiftreg #(16, 4) shiftreg_5 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_0_y0_im),
    .d_out(bf_1_x0_im)
  );

  shiftreg #(16, 2) shiftreg_6 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf_1_y1_re),
    .d_out(switch_1_x1_re)
  );
  shiftreg #(16, 2) shiftreg_7 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf_1_y1_im),
    .d_out(switch_1_x1_im)
  );

  shiftreg #(16, 2) shiftreg_8 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_1_y0_re),
    .d_out(bf_2_x0_re)
  );
  shiftreg #(16, 2) shiftreg_9 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_1_y0_im),
    .d_out(bf_2_x0_im)
  );
  
  shiftreg #(16, 1) shiftreg_10 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf_2_y1_re),
    .d_out(switch_2_x1_re)
  );
  shiftreg #(16, 1) shiftreg_11 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf_2_y1_im),
    .d_out(switch_2_x1_im)
  );
  
  shiftreg #(16, 1) shiftreg_12 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_2_y0_re),
    .d_out(bf_3_x0_re)
  );
  shiftreg #(16, 1) shiftreg_13 (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_2_y0_im),
    .d_out(bf_3_x0_im)
  );

  wire fft_out_valid = cnt >= 16'd15 && cnt < 16'd23;  // TODO: FFTlen-1 cnt==FFTlen * 3 / 2 - 1

  reorder #(16, 16) reorder_0 (
    .clk(clk),
    .rst_n(rst_n),
    .in1_re(bf_3_y0_re),
    .in1_im(bf_3_y0_im),
    .in2_re(bf_3_y1_re),
    .in2_im(bf_3_y1_im),
    .in_valid(fft_out_valid),
    .out_re(y_re),
    .out_im(y_im),
    .out_valid(valid_out)
  );
  
  assign sop_out = cnt == 16'd23;  // TODO: cnt==FFTlen * 3 / 2 - 1

endmodule
