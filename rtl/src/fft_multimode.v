// Author: brimonzzy
// Create Date: 2025/2/13
// Description: Multi-mode FFT accelerator top module

module fft_multimode (
  input clk,
  input rst_n,
  input inv, // 0: fft, 1: ifft
  input [1:0] np, // FFT/IFFT point number 0:64, 1:128, 2:256, 3:512
  input stb, // Input data valid (active high)
  input sop_in, // The first valid data in the input stream
  input [15:0] x_re, // Input real part
  input [15:0] x_im, // Input imaginary part
  output valid_out, // Output data valid (active high)
  output reg sop_out, // The first valid data in the output stream
  output [15:0] y_re, // Output real part
  output [15:0] y_im // Output imaginary part
);

  parameter N = 512;
  parameter stage = $clog2(N);

  reg [9:0] point;
  reg [3:0] log2point;
  always @(*) begin
    case(np)
      2'b00: begin point = 10'd64; log2point = 4'd6; end
      2'b01: begin point = 10'd128; log2point = 4'd7; end
      2'b10: begin point = 10'd256; log2point = 4'd8; end
      2'b11: begin point = 10'd512; log2point = 4'd9; end
    endcase
  end

  wire [15:0] bf_x0_re [0:stage-2];
  wire [15:0] bf_x0_im [0:stage-2];
  wire [15:0] bf_x1_re [0:stage-2];
  wire [15:0] bf_x1_im [0:stage-2];
  wire [15:0] bf_w_re  [0:stage-2];
  wire [15:0] bf_w_im  [0:stage-2];
  wire [15:0] bf_y0_re [0:stage-2];
  wire [15:0] bf_y0_im [0:stage-2];
  wire [15:0] bf_y1_re [0:stage-2];
  wire [15:0] bf_y1_im [0:stage-2];
  wire [15:0] switch_x0_re [0:stage-2];
  wire [15:0] switch_x0_im [0:stage-2];
  wire [15:0] switch_x1_re [0:stage-2];
  wire [15:0] switch_x1_im [0:stage-2];
  wire [15:0] switch_y0_re [0:stage-2];
  wire [15:0] switch_y0_im [0:stage-2];
  wire [15:0] switch_y1_re [0:stage-2];
  wire [15:0] switch_y1_im [0:stage-2];
  wire switch_sel [0:stage-2];
  wire [15:0] bf_noW_x0_re;
  wire [15:0] bf_noW_x0_im;
  wire [15:0] bf_noW_x1_re;
  wire [15:0] bf_noW_x1_im;
  wire [15:0] bf_noW_y0_re;
  wire [15:0] bf_noW_y0_im;
  wire [15:0] bf_noW_y1_re;
  wire [15:0] bf_noW_y1_im;

  wire busy;
  reg [$clog2(N):0] cnt; // wide:stage+1

  assign busy = cnt != 10'd0;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      cnt <= {($clog2(N)+1){1'b0}};
    end
    else if(sop_in)
      cnt <= 1;
    else begin
      if(stb || busy) begin
        if(cnt == (point*3/2-1)) // cnt==FFTlen * 3 / 2 - 1
          cnt <= {($clog2(N)+1){1'b0}};
        else
          cnt <= cnt + 1'b1;
      end
    end
  end

  genvar i;
  generate
    for(i=0; i<stage-1; i=i+1) begin : bf_switch_gen
      bf_rdx2 bf_u (
        .x0_re(bf_x0_re[i]),
        .x0_im(bf_x0_im[i]),
        .x1_re(bf_x1_re[i]),
        .x1_im(bf_x1_im[i]),
        .w_re(bf_w_re[i]),
        .w_im(bf_w_im[i]),
        .y0_re(bf_y0_re[i]),
        .y0_im(bf_y0_im[i]),
        .y1_re(bf_y1_re[i]),
        .y1_im(bf_y1_im[i])
      );
      switch switch_u (
        .sel(switch_sel[i]),
        .x0_re(switch_x0_re[i]),
        .x0_im(switch_x0_im[i]),
        .x1_re(switch_x1_re[i]),
        .x1_im(switch_x1_im[i]),
        .y0_re(switch_y0_re[i]),
        .y0_im(switch_y0_im[i]),
        .y1_re(switch_y1_re[i]),
        .y1_im(switch_y1_im[i])
      );
    end
  endgenerate

  bf_rdx2_noW bf_noW_u (
    .x0_re(bf_noW_x0_re),
    .x0_im(bf_noW_x0_im),
    .x1_re(bf_noW_x1_re),
    .x1_im(bf_noW_x1_im),
    .y0_re(bf_noW_y0_re),
    .y0_im(bf_noW_y0_im),
    .y1_re(bf_noW_y1_re),
    .y1_im(bf_noW_y1_im)
  );

  wire [15:0] twiddle_rom_out_re [0:7];
  wire [15:0] twiddle_rom_out_im [0:7];
  twiddle_rom twiddle_rom_u (
    .addr0(cnt[stage-2-0:0]),
    .addr1({cnt[stage-2-1:0], 1'b0}),
    .addr2({cnt[stage-2-2:0], 2'b0}),
    .addr3({cnt[stage-2-3:0], 3'b0}),
    .addr4({cnt[stage-2-4:0], 4'b0}),
    .addr5({cnt[stage-2-5:0], 5'b0}),
    .addr6({cnt[stage-2-6:0], 6'b0}),
    .addr7({cnt[stage-2-7:0], 7'b0}),
    .data0_re(twiddle_rom_out_re[0]),
    .data0_im(twiddle_rom_out_im[0]),
    .data1_re(twiddle_rom_out_re[1]),
    .data1_im(twiddle_rom_out_im[1]),
    .data2_re(twiddle_rom_out_re[2]),
    .data2_im(twiddle_rom_out_im[2]),
    .data3_re(twiddle_rom_out_re[3]),
    .data3_im(twiddle_rom_out_im[3]),
    .data4_re(twiddle_rom_out_re[4]),
    .data4_im(twiddle_rom_out_im[4]),
    .data5_re(twiddle_rom_out_re[5]),
    .data5_im(twiddle_rom_out_im[5]),
    .data6_re(twiddle_rom_out_re[6]),
    .data6_im(twiddle_rom_out_im[6]),
    .data7_re(twiddle_rom_out_re[7]),
    .data7_im(twiddle_rom_out_im[7])
  );
  wire [15:0] ifft_twiddle_rom_out_re [0:7];
  wire [15:0] ifft_twiddle_rom_out_im [0:7];
  ifft_twiddle_rom ifft_twiddle_rom_u (
    .addr0(cnt[stage-2-0:0]),
    .addr1({cnt[stage-2-1:0], 1'b0}),
    .addr2({cnt[stage-2-2:0], 2'b0}),
    .addr3({cnt[stage-2-3:0], 3'b0}),
    .addr4({cnt[stage-2-4:0], 4'b0}),
    .addr5({cnt[stage-2-5:0], 5'b0}),
    .addr6({cnt[stage-2-6:0], 6'b0}),
    .addr7({cnt[stage-2-7:0], 7'b0}),
    .data0_re(ifft_twiddle_rom_out_re[0]),
    .data0_im(ifft_twiddle_rom_out_im[0]),
    .data1_re(ifft_twiddle_rom_out_re[1]),
    .data1_im(ifft_twiddle_rom_out_im[1]),
    .data2_re(ifft_twiddle_rom_out_re[2]),
    .data2_im(ifft_twiddle_rom_out_im[2]),
    .data3_re(ifft_twiddle_rom_out_re[3]),
    .data3_im(ifft_twiddle_rom_out_im[3]),
    .data4_re(ifft_twiddle_rom_out_re[4]),
    .data4_im(ifft_twiddle_rom_out_im[4]),
    .data5_re(ifft_twiddle_rom_out_re[5]),
    .data5_im(ifft_twiddle_rom_out_im[5]),
    .data6_re(ifft_twiddle_rom_out_re[6]),
    .data6_im(ifft_twiddle_rom_out_im[6]),
    .data7_re(ifft_twiddle_rom_out_re[7]),
    .data7_im(ifft_twiddle_rom_out_im[7])
  );
  generate
    for(i=0; i<8; i=i+1) begin : bf_w_wire
      assign bf_w_re[i] = inv? ifft_twiddle_rom_out_re[i] : twiddle_rom_out_re[i];
      assign bf_w_im[i] = inv? ifft_twiddle_rom_out_im[i] : twiddle_rom_out_im[i];
    end
  endgenerate

  generate
    for(i=0; i<stage-1; i=i+1) begin : switch_x0_wire
      assign switch_sel[i] = cnt[stage-2-i]; // stage-2-i
      assign switch_x0_re[i] = bf_y0_re[i];
      assign switch_x0_im[i] = bf_y0_im[i];
    end
  endgenerate
  generate
    for(i=4; i<stage-1; i=i+1) begin : bf_x1_wire
      assign bf_x1_re[i] = switch_y1_re[i-1];
      assign bf_x1_im[i] = switch_y1_im[i-1];
    end
  endgenerate

  assign bf_x1_re[0] = x_re;
  assign bf_x1_im[0] = x_im;
  assign bf_noW_x1_re = switch_y1_re[stage-2];
  assign bf_noW_x1_im = switch_y1_im[stage-2];

  // support multi-point FFT
  assign bf_x1_re[1] = (np==2'b10)? x_re : switch_y1_re[0];
  assign bf_x1_re[2] = (np==2'b01)? x_re : switch_y1_re[1];
  assign bf_x1_re[3] = (np==2'b00)? x_re : switch_y1_re[2];
  assign bf_x1_im[1] = (np==2'b10)? x_im : switch_y1_im[0];
  assign bf_x1_im[2] = (np==2'b01)? x_im : switch_y1_im[1];
  assign bf_x1_im[3] = (np==2'b00)? x_im : switch_y1_im[2];

  
  // input shiftreg
  shiftreg #(16, 1<<(stage-1)) shiftreg_in_re (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(x_re),
    .d_out(bf_x0_re[0])
  );
  shiftreg #(16, 1<<(stage-1)) shiftreg_in_im (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(x_im),
    .d_out(bf_x0_im[0])
  );
  // bf1 shiftreg (256)
  wire [15:0] bf1_din_re = (np==2'b10)? x_re : switch_y0_re[0];
  shiftreg #(16, 1<<(stage-2)) bf1_in_shiftreg_re (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf1_din_re),
    .d_out(bf_x0_re[1])
  );
  wire [15:0] bf1_din_im = (np==2'b10)? x_im : switch_y0_im[0];
  shiftreg #(16, 1<<(stage-2)) bf1_in_shiftreg_im (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf1_din_im),
    .d_out(bf_x0_im[1])
  );
  // bf2 shiftreg (128)
  wire [15:0] bf2_din_re = (np==2'b01)? x_re : switch_y0_re[1];
  shiftreg #(16, 1<<(stage-3)) bf2_in_shiftreg_re (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf2_din_re),
    .d_out(bf_x0_re[2])
  );
  wire [15:0] bf2_din_im = (np==2'b01)? x_im : switch_y0_im[1];
  shiftreg #(16, 1<<(stage-3)) bf2_in_shiftreg_im (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf2_din_im),
    .d_out(bf_x0_im[2])
  );
  // bf3 shiftreg (64)
  wire [15:0] bf3_din_re = (np==2'b00)? x_re : switch_y0_re[2];
  shiftreg #(16, 1<<(stage-4)) bf3_in_shiftreg_re (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf3_din_re),
    .d_out(bf_x0_re[3])
  );
  wire [15:0] bf3_din_im = (np==2'b00)? x_im : switch_y0_im[2];
  shiftreg #(16, 1<<(stage-4)) bf3_in_shiftreg_im (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(bf3_din_im),
    .d_out(bf_x0_im[3])
  );
  generate
    for(i=0; i<stage-1; i=i+1) begin : bf_out_shiftreg_gen
      shiftreg #(16, 1<<(stage-2-i)) bf_out_shiftreg_re (
        .clk(clk),
        .rst_n(rst_n),
        .d_in(bf_y1_re[i]),
        .d_out(switch_x1_re[i])
      );
      shiftreg #(16, 1<<(stage-2-i)) bf_out_shiftreg_im (
        .clk(clk),
        .rst_n(rst_n),
        .d_in(bf_y1_im[i]),
        .d_out(switch_x1_im[i])
      );
    end
  endgenerate
  generate
    for(i=3; i<stage-2; i=i+1) begin : bf_in_shiftreg_gen
      shiftreg #(16, 1<<(stage-2-i)) bf_in_shiftreg_y0_re (
        .clk(clk),
        .rst_n(rst_n),
        .d_in(switch_y0_re[i]),
        .d_out(bf_x0_re[i+1])
      );
      shiftreg #(16, 1<<(stage-2-i)) bf_in_shiftreg_y0_im ( 
        .clk(clk),
        .rst_n(rst_n),
        .d_in(switch_y0_im[i]),
        .d_out(bf_x0_im[i+1])
      );
    end
  endgenerate
  shiftreg #(16, 1) shiftreg_last_re (
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_y0_re[stage-2]),
    .d_out(bf_noW_x0_re)
  );
  shiftreg #(16, 1) shiftreg_last_im ( 
    .clk(clk),
    .rst_n(rst_n),
    .d_in(switch_y0_im[stage-2]),
    .d_out(bf_noW_x0_im)
  );


  wire fft_out_valid = cnt >= (point-1) && cnt < (point*3/2-1);  // FFTlen-1 cnt==FFTlen * 3 / 2 - 1

  wire [15:0] reorder_out_re, reorder_out_im;
  reorder #(16, N) output_reorder_u (
    .clk(clk),
    .rst_n(rst_n),
    .in1_re(bf_noW_y0_re),
    .in1_im(bf_noW_y0_im),
    .in2_re(bf_noW_y1_re),
    .in2_im(bf_noW_y1_im),
    .in_valid(fft_out_valid),
    .np(np),
    .out_re(reorder_out_re),
    .out_im(reorder_out_im),
    .out_valid(valid_out)
  );
  assign y_re = inv ? reorder_out_re >> log2point : reorder_out_re;
  assign y_im = inv ? reorder_out_im >> log2point : reorder_out_im;
  
  
  wire sop_out_t = cnt == (point*3/2-1);
  reg sop_out_t1;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      sop_out_t1 <= 1'b0;
      sop_out <= 1'b0;
    end
    else begin
      sop_out_t1 <= sop_out_t;
      sop_out <= sop_out_t1;
    end
  end

endmodule
