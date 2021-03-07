import aes_const::*;
import aes_wire::*;

module aes_xkey
(
  input logic [(32*Nk-1):0] key_in,
  output logic [7:0] key_out[0:(4*Nk-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i;

  generate
    for (i=Nk-1; i>=0; i=i-1) begin
      assign key_out[4*(Nk-i-1)] = key_in[(32*(i+1)-1):((32*i+24))];
      assign key_out[4*(Nk-i-1)+1] = key_in[(32*(i+1)-9):((32*i+16))];
      assign key_out[4*(Nk-i-1)+2] = key_in[(32*(i+1)-17):((32*i+8))];
      assign key_out[4*(Nk-i-1)+3] = key_in[(32*(i+1)-25):((32*i))];
    end
  endgenerate

endmodule
