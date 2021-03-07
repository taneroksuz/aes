import aes_const::*;
import aes_wire::*;

module aes_sbyte
(
  input logic [7:0] State_in [0:(4*Nb-1)],
  input logic [7:0] S_Box [0:255],
  output logic [7:0] State_out [0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i,j;

  generate
    for (i = 0; i < 4; i = i + 1) begin
      for (j=0; j<Nb; j = j + 1) begin
        assign State_out[i*Nb+j] = S_Box[State_in[i*Nb+j]];
      end
    end
  endgenerate


endmodule
