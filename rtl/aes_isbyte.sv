
`include "aes_config.svh"

module aes_isbyte #(
  parameter KEY_BITS = `AES_KEY_BITS,
  parameter NK       = `AES_NK,
  parameter NR       = `AES_NR
)
(
  input logic [7:0] State_in [0:(15)],
  input logic [7:0] IBox [0:255],
  output logic [7:0] State_out [0:(15)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i,j;

  generate
    for (i = 0; i < 4; i = i + 1) begin
      for (j=0; j<4; j = j + 1) begin
        assign State_out[i*4+j] = IBox[State_in[i*4+j]];
      end
    end
  endgenerate


endmodule
