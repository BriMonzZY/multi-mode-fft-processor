`timescale 1ns / 1ps

module reorder_tb();

  // Parameters
  parameter DATA_WIDTH = 16;
  parameter FFT_LENGTH = 16;

  // Inputs
  reg clk;
  reg rst_n;
  reg [DATA_WIDTH-1:0] in1_re;
  reg [DATA_WIDTH-1:0] in1_im;
  reg [DATA_WIDTH-1:0] in2_re;
  reg [DATA_WIDTH-1:0] in2_im;
  reg in_valid;

  // Outputs
  wire [DATA_WIDTH-1:0] out_re;
  wire [DATA_WIDTH-1:0] out_im;
  wire out_valid;

  reorder #(
    .DATA_WIDTH(DATA_WIDTH),
    .FFT_LENGTH(FFT_LENGTH)
  ) uut (
    .clk(clk),
    .rst_n(rst_n),
    .in1_re(in1_re),
    .in1_im(in1_im),
    .in2_re(in2_re),
    .in2_im(in2_im),
    .in_valid(in_valid),
    .out_re(out_re),
    .out_im(out_im),
    .out_valid(out_valid)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    `ifdef DEBUG
    `ifdef FSDB
      $display("\n---use verdi---\n");
      $fsdbDumpfile("reorder_tb.fsdb");
      $fsdbDumpvars(0, reorder_tb);
      $fsdbDumpMDA(0, reorder_tb);
    `endif
    `endif

    // Initialize inputs
    rst_n = 0;
    in1_re = 0;
    in1_im = 0;
    in2_re = 0;
    in2_im = 0;
    in_valid = 0;

    // Apply reset
    repeat (2) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    // Apply test vectors
    in_valid = 1;
    in1_re = 16'h0000;
    in1_im = 16'h0000;
    in2_re = 16'h0001;
    in2_im = 16'h0001;
    @(posedge clk);
    in1_re = 16'h0002;
    in1_im = 16'h0002;
    in2_re = 16'h0003;
    in2_im = 16'h0003;
    @(posedge clk);
    in1_re = 16'h0004;
    in1_im = 16'h0004;
    in2_re = 16'h0005;
    in2_im = 16'h0005;
    @(posedge clk);
    in1_re = 16'h0006;
    in1_im = 16'h0006;
    in2_re = 16'h0007;
    in2_im = 16'h0007;
    @(posedge clk);
    in1_re = 16'h0008;
    in1_im = 16'h0008;
    in2_re = 16'h0009;
    in2_im = 16'h0009;
    @(posedge clk);
    in1_re = 16'h000A;
    in1_im = 16'h000A;
    in2_re = 16'h000B;
    in2_im = 16'h000B;
    @(posedge clk);
    in1_re = 16'h000C;
    in1_im = 16'h000C;
    in2_re = 16'h000D;
    in2_im = 16'h000D;
    @(posedge clk);
    in1_re = 16'h000E;
    in1_im = 16'h000E;
    in2_re = 16'h000F;
    in2_im = 16'h000F;
    @(posedge clk);

    in_valid = 0;

    repeat (100) @(posedge clk);
    $finish();
  end

  // Monitor outputs
  initial begin
    $monitor("Time: %0t | out_re: %h | out_im: %h | out_valid: %b", $time, out_re, out_im, out_valid);
  end

endmodule
