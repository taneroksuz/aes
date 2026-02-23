
`include "aes_config.svh"

module aes_xdata #(
  parameter KEY_BITS = `AES_KEY_BITS,
  parameter NK       = `AES_NK,
  parameter NR       = `AES_NR
)
(
  input logic [127:0] data_in,
  output logic [7:0] data_out[0:(15)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i;

  generate
    for (i=3; i>=0; i=i-1) begin
      assign data_out[4*(3-i)] = data_in[(32*(i+1)-1):((32*i+24))];
      assign data_out[4*(3-i)+1] = data_in[(32*(i+1)-9):((32*i+16))];
      assign data_out[4*(3-i)+2] = data_in[(32*(i+1)-17):((32*i+8))];
      assign data_out[4*(3-i)+3] = data_in[(32*(i+1)-25):((32*i))];
    end
  endgenerate


endmodule
