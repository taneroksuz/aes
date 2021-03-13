import aes_const::*;
import aes_wire::*;

module aes_cdata
(
  input logic [7:0] data_in[0:(4*Nb-1)],
  output logic [(32*Nb-1):0] data_out
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i;

  generate
    for (i=Nb-1; i>=0; i=i-1) begin
      assign data_out[(32*(i+1)-1):((32*i+24))] = data_in[4*(Nb-i-1)];
      assign data_out[(32*(i+1)-9):((32*i+16))] = data_in[4*(Nb-i-1)+1];
      assign data_out[(32*(i+1)-17):((32*i+8))] = data_in[4*(Nb-i-1)+2];
      assign data_out[(32*(i+1)-25):((32*i))] = data_in[4*(Nb-i-1)+3];
    end
  endgenerate


endmodule
