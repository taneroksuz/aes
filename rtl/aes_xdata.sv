import aes_const::*;
import aes_wire::*;

module aes_xdata
(
  input logic [(32*Nb-1):0] data_in,
  output logic [7:0] data_out[0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i;

  generate
    for (i=Nb-1; i>=0; i=i-1) begin
      assign data_out[4*(Nb-i-1)] = data_in[(32*(i+1)-1):((32*i+24))];
      assign data_out[4*(Nb-i-1)+1] = data_in[(32*(i+1)-9):((32*i+16))];
      assign data_out[4*(Nb-i-1)+2] = data_in[(32*(i+1)-17):((32*i+8))];
      assign data_out[4*(Nb-i-1)+3] = data_in[(32*(i+1)-25):((32*i))];
    end
  endgenerate


endmodule
