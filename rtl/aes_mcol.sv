import aes_const::*;
import aes_wire::*;

module aes_mcol
(
  input logic [7:0] State_in [0:(4*Nb-1)],
  input logic [7 : 0] EXP_3 [0:255],
  input logic [7 : 0] LN_3 [0:255],
  output logic [7:0] State_out [0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  function [7:0] gmul;
    input [7:0] data_a;
    input [7:0] data_b;
    logic [8:0] swap;
    begin
      if (data_a == 0 || data_b == 0) begin
        gmul = 0;
      end else begin
        swap = LN_3[data_a] + LN_3[data_b];
        swap = swap % 9'hFF;
        gmul = EXP_3[swap[7:0]];
      end
    end
  endfunction

  genvar i,j;

  generate
    for (j=0; j<Nb; j = j + 1) begin
      assign State_out[4*j] = gmul(8'h02,State_in[4*j]) ^ gmul(8'h03,State_in[4*j+1]) ^ gmul(8'h01,State_in[4*j+2]) ^ gmul(8'h01,State_in[4*j+3]);
      assign State_out[4*j+1] = gmul(8'h01,State_in[4*j]) ^ gmul(8'h02,State_in[4*j+1]) ^ gmul(8'h03,State_in[4*j+2]) ^ gmul(8'h01,State_in[4*j+3]);
      assign State_out[4*j+2] = gmul(8'h01,State_in[4*j]) ^ gmul(8'h01,State_in[4*j+1]) ^ gmul(8'h02,State_in[4*j+2]) ^ gmul(8'h03,State_in[4*j+3]);
      assign State_out[4*j+3] = gmul(8'h03,State_in[4*j]) ^ gmul(8'h01,State_in[4*j+1]) ^ gmul(8'h01,State_in[4*j+2]) ^ gmul(8'h02,State_in[4*j+3]);
    end
  endgenerate


endmodule
