
// use tsmc n28 hpc
`define TSMC_N28HPC

module fft_reoder_sramsp16x256_maskoff (
  input clk,
  input ce,
  input rw,
  input [7:0] addr,
  input [15:0] din,
  output reg [15:0] dout
);

`ifdef TSMC_N28HPC

  rf1p16x256_tsmc28hpcp rf1p16x256_tsmc28hpcp_u (
    .CLK  (clk  ),
    .CEB  (~ce  ),
    .WEB  (~rw  ),
    .A    (addr ),
    .D    (din  ),
    .Q    (dout )
  );

`else

  sramsp_maskoff #(
    .DATA_WIDTH(16),
    .ADDR_WIDTH(8)
  ) sramsp16x256_maskoff  (
    .CLK      (clk ),
    .GWEN     (~rw ),
    .CEN      (~ce ),
    .A        (addr),
    .D        (din ),
    .Q        (dout)
  );

`endif

endmodule
