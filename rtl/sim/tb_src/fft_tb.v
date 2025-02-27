`timescale 1ns / 1ps

module fft_tb();

  parameter N = 512;
  localparam CLK_PERIOD = 10;

  reg clk, rst_n;
  reg [15:0] x_re;
  reg [15:0] x_im;
  reg inv;
  reg [1:0] np;
  reg stb;
  reg sop_in;
  wire valid_out;
  wire sop_out; 
  wire [15:0] y_re;
  wire [15:0] y_im;

  reg [15:0] fft_input_re [0:N-1];
  reg [15:0] fft_input_im [0:N-1];
  initial begin
    $readmemh("../../../test_vector/fft512_input_re.txt", fft_input_re);
    $readmemh("../../../test_vector/fft512_input_im.txt", fft_input_im);
  end

  integer fft_output_re;
  integer fft_output_im;
  initial begin
    fft_output_re = $fopen("../../../test_vector/fft_output_re.txt", "w"); 
    fft_output_im = $fopen("../../../test_vector/fft_output_im.txt", "w");
    forever begin
      @(posedge clk);
      if(valid_out) begin
        if(y_re[15])
            $fwrite(fft_output_re, "0x%h ", -$signed(y_re));
        else
          $fwrite(fft_output_re, "0x%h ", y_re);
        if(y_im[15])
            $fwrite(fft_output_im, "0x%h ", -$signed(y_im));
        else
          $fwrite(fft_output_im, "0x%h ", y_im);
      end
    end
  end

  initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  integer i;
  initial begin
    `ifdef DEBUG
    `ifdef FSDB
      $fsdbDumpfile("fft_tb.fsdb");
      $fsdbDumpvars(0, fft_tb);
      $fsdbDumpMDA(0, fft_tb);
    `endif
    `endif

    // reset and clk
    rst_n <= 1'b0;
    inv <= 1'b0;
    np <= 2'b11;
    stb <= 1'b0;
    sop_in <= 1'b0;
    x_re <= 16'h0;
    x_im <= 16'h0;

    repeat (2) @(posedge clk);
    rst_n <= 1;
    repeat (3) @(posedge clk);

    stb <= 1'b1;
    sop_in <= 1'b1;
    x_re <= fft_input_re[0];
    x_im <= fft_input_im[0];
    @(posedge clk);
    sop_in <= 1'b0;
    for(i=1; i<N; i=i+1) begin
      x_re <= $signed(fft_input_re[i]);
      x_im <= $signed(fft_input_im[i]);
      @(posedge clk);
    end
    stb <= 1'b0;

    repeat ((N*3/2-1)+N) @(posedge clk);

    $fclose(fft_output_re);
    $finish();
  end

  always @(posedge clk) begin
    if(valid_out) begin
      $display("%h", y_re);
    end
  end

  fft_multimode u_fft_multimode (
    .clk(clk),
    .rst_n(rst_n),
    .inv(inv),
    .np(np),
    .stb(stb),
    .sop_in(sop_in),
    .x_re(x_re),
    .x_im(x_im),
    .valid_out(valid_out),
    .sop_out(sop_out),
    .y_re(y_re),
    .y_im(y_im)
  );

endmodule
