module reorder #(
  parameter DATA_WIDTH = 16,
  parameter FFT_LENGTH = 64
) (
  input clk,
  input rst_n,
  input [DATA_WIDTH-1:0] in1_re,
  input [DATA_WIDTH-1:0] in1_im,
  input [DATA_WIDTH-1:0] in2_re,
  input [DATA_WIDTH-1:0] in2_im,
  input in_valid,
  input [1:0] np,
  output [DATA_WIDTH-1:0] out_re,
  output [DATA_WIDTH-1:0] out_im,
  output reg out_valid
);

  localparam TIMES = $clog2(FFT_LENGTH/2);

  reg [TIMES:0] index1;
  reg [TIMES:0] index2;

  reg [TIMES-1:0] in_counter; // receive 2 data per cycle
  reg [TIMES:0] out_counter, out_counter_reg1, out_counter_reg2; // output 1 data per cycle

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      out_counter_reg1 <= {(TIMES+1){1'b0}};
      out_counter_reg2 <= {(TIMES+1){1'b0}};
    end
    else begin
      out_counter_reg1 <= out_counter;
      out_counter_reg2 <= out_counter_reg1;
    end
  end

  wire out_valid_t;

  reg [9:0] point;
  always @(*) begin
    case(np)
      2'b00: point = 10'd64;
      2'b01: point = 10'd128;
      2'b10: point = 10'd256;
      2'b11: point = 10'd512;
    endcase
  end

  reg w_en;
  reg [TIMES-1:0] addr0, addr1;
  reg [DATA_WIDTH-1:0] din0, din1, din2, din3;
  wire [DATA_WIDTH-1:0] dout0, dout1, dout2, dout3;

  // rambank0_re
  fft_reoder_sramsp16x256_maskoff sram16x256_0 (
    .clk(clk),
    .ce(1'b1),
    .rw(w_en),
    .addr(addr0),
    .din(din0),
    .dout(dout0)
  );
  // rambank0_im
  fft_reoder_sramsp16x256_maskoff sram16x256_1 (
    .clk(clk),
    .ce(1'b1),
    .rw(w_en),
    .addr(addr0),
    .din(din1),
    .dout(dout1)
  );
  // rambank1_re
  fft_reoder_sramsp16x256_maskoff sram16x256_2 (
    .clk(clk),
    .ce(1'b1),
    .rw(w_en),
    .addr(addr1),
    .din(din2),
    .dout(dout2)
  );
  // rambank1_im
  fft_reoder_sramsp16x256_maskoff sram16x256_3 (
    .clk(clk),
    .ce(1'b1),
    .rw(w_en),
    .addr(addr1),
    .din(din3),
    .dout(dout3)
  );


  wire [TIMES:0] index1_0, index1_1, index1_2, index1_3;
  wire [TIMES:0] index2_0, index2_1, index2_2, index2_3;
  // 512
  reverse_bits #(TIMES+1) reverse_bits_00 (
    .in({in_counter, 1'b0}),
    .out(index1_0)
  );
  reverse_bits #(TIMES+1) reverse_bits_01 (
    .in({in_counter, 1'b1}),
    .out(index2_0)
  );
  // 256
  reverse_bits #(TIMES) reverse_bits_10 (
    .in({in_counter[6:0], 1'b0}),
    .out(index1_1[7:0])
  );
  reverse_bits #(TIMES) reverse_bits_11 (
    .in({in_counter[6:0], 1'b1}),
    .out(index2_1[7:0])
  );
  // 128
  reverse_bits #(TIMES-1) reverse_bits_20 (
    .in({in_counter[5:0], 1'b0}),
    .out(index1_2[6:0])
  );
  reverse_bits #(TIMES-1) reverse_bits_21 (
    .in({in_counter[5:0], 1'b1}),
    .out(index2_2[6:0])
  );
  // 64
  reverse_bits #(TIMES-2) reverse_bits_30 (
    .in({in_counter[4:0], 1'b0}),
    .out(index1_3[5:0])
  );
  reverse_bits #(TIMES-2) reverse_bits_31 (
    .in({in_counter[4:0], 1'b1}),
    .out(index2_3[5:0])
  );

  always @(*) begin
    case(np)
      2'b00: begin //64
        index1 = {3'b0, index1_3[5:0]};
        index2 = {3'b0, index2_3[5:0]};
      end
      2'b01: begin //128
        index1 = {2'b0, index1_2[6:0]};
        index2 = {2'b0, index2_2[6:0]};
      end
      2'b10: begin //256
        index1 = {1'b0, index1_1[7:0]};
        index2 = {1'b0, index2_1[7:0]};
      end
      2'b11: begin //512
        index1 = index1_0;
        index2 = index2_0;
      end
    endcase
  end


  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      in_counter <= {TIMES{1'b0}};
      addr0 <= {TIMES{1'b0}};
      addr1 <= {TIMES{1'b0}};
    end
    else if ((in_valid || in_counter != {TIMES{1'b0}}) && (in_counter < (point>>1))) begin
      in_counter <= in_counter + 1'b1;
      w_en <= 1'b1;
      addr0 <= index1;
      addr1 <= index2-(point>>1);
      din0 <= in1_re;
      din1 <= in1_im;
      din2 <= in2_re;
      din3 <= in2_im;
    end
    else begin
      in_counter <= {TIMES{1'b0}};
      w_en <= 1'b0;

      if(out_counter < (point>>1)) begin
        addr0 <= out_counter;
        addr1 <= out_counter;
      end
      else begin
        addr0 <= out_counter-(point>>1);
        addr1 <= out_counter-(point>>1);
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_counter <= {(TIMES+1){1'b0}};
    end
    else if (out_valid_t && out_counter < point-1) begin
      out_counter <= out_counter + 1;
    end
    else begin
      out_counter <= {(TIMES+1){1'b0}};
    end
  end

  reg [TIMES-1:0] in_counter_reg;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      in_counter_reg <= {TIMES{1'b0}};
    else
      in_counter_reg <= in_counter;
  end

  assign out_re = (out_counter_reg2 < ((point>>1))) ? dout0 : dout2;
  assign out_im = (out_counter_reg2 < ((point>>1))) ? dout1 : dout3;

  assign out_valid_t = (in_counter_reg == ((point>>1) - 1)) || (out_counter != 0);

  reg out_valid_t1;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      out_valid_t1 <= 1'b0;
      out_valid <= 1'b0;
    end
    else begin
      out_valid_t1 <= out_valid_t;
      out_valid <= out_valid_t1;
    end
  end

endmodule
