import aes_const::*;
import aes_wire::*;

module aes_arkey
(
  input logic [7:0] State_in [0:(4*Nb-1)],
  input logic [31:0] KExp [0:(Nb*(Nr+1)-1)],
  input logic [3:0] Index,
  output logic [7:0] State_out [0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i,j;

  generate
    for (j = 0; j < Nb; j = j + 1) begin
      for (i=0; i<4; i = i + 1) begin
        assign State_out[4*j+i] = KExp[Index*Nb+j][((4-i)*8-1):((3-i)*8)] ^ State_in[4*j+i];
      end
    end
  endgenerate

endmodule
