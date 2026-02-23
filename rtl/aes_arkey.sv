
`include "aes_config.svh"

module aes_arkey #(
  parameter KEY_BITS = `AES_KEY_BITS,
  parameter NK       = `AES_NK,
  parameter NR       = `AES_NR
)
(
  input logic [7:0] State_in [0:15],
  input logic [31:0] KExp [0:(4*(NR+1)-1)],
  input logic [3:0] Index,
  output logic [7:0] State_out [0:15]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i,j;

  generate
    for (j = 0; j < 4; j = j + 1) begin
      for (i=0; i<4; i = i + 1) begin
        assign State_out[4*j+i] = KExp[Index*4+j][((4-i)*8-1):((3-i)*8)] ^ State_in[4*j+i];
      end
    end
  endgenerate

endmodule
