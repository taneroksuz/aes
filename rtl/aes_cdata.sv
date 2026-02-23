
`include "aes_config.svh"

module aes_cdata #(
  parameter KEY_BITS = `AES_KEY_BITS,
  parameter NK       = `AES_NK,
  parameter NR       = `AES_NR
)
(
  input logic [7:0] data_in[0:15],
  output logic [127:0] data_out
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i;

  generate
    for (i=3; i>=0; i=i-1) begin
      assign data_out[(32*(i+1)-1):((32*i+24))] = data_in[4*(3-i)];
      assign data_out[(32*(i+1)-9):((32*i+16))] = data_in[4*(3-i)+1];
      assign data_out[(32*(i+1)-17):((32*i+8))] = data_in[4*(3-i)+2];
      assign data_out[(32*(i+1)-25):((32*i))] = data_in[4*(3-i)+3];
    end
  endgenerate


endmodule
