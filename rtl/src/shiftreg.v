// Author: brimonzzy
// Create Date: 2025/2/13
// Description: N-stage shift register with width W

module shiftreg #(
  parameter W = 16,
  parameter N = 8
)(
  input clk,
  input rst_n,
  input [W-1:0] d_in,
  output [W-1:0] d_out
);

  reg [W-1:0] shift_reg [N-1:0];
  integer i;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (i = 0; i < N; i = i + 1) begin
        shift_reg[i] <= {W{1'b0}};
      end
    end
    else begin
      shift_reg[0] <= d_in;
      for (i = 1; i < N; i = i + 1) begin
        shift_reg[i] <= shift_reg[i-1];
      end
    end
  end

  assign d_out = shift_reg[N-1];

endmodule
