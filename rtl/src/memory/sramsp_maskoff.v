module sramsp_maskoff #(
  parameter DATA_WIDTH = 16,
  parameter ADDR_WIDTH = 8
) ( 
  input CLK,
  input GWEN,
  input CEN,
  input [ADDR_WIDTH-1:0] A,
  input [DATA_WIDTH-1:0] D,  
  output reg [DATA_WIDTH-1:0] Q
);

  reg [DATA_WIDTH-1:0] mem [0:(1 << ADDR_WIDTH)-1];  

  always @(posedge CLK) begin
    if ((! CEN) && (! GWEN )) begin 
      mem[A] <= D; 
    end 
  end  
  always @(posedge CLK) begin
    if ((! CEN) && GWEN) begin 
      Q <= mem[A]; 
    end 
    else begin
      Q <= {DATA_WIDTH{1'bx}};
    end
  end

endmodule
