import aes_const::*;
import aes_wire::*;

module aes_isrow
(
  input logic [7:0] State_in [0:(4*Nb-1)],
  output logic [7:0] State_out [0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i,j;

  logic [2:0] C [0:2];

  always_comb begin
    if (Nb == 4) begin
      C[0] = 1;
      C[1] = 2;
      C[2] = 3;
    end else if (Nb == 6) begin
      C[0] = 2;
      C[1] = 2;
      C[2] = 3;
    end else if (Nb == 8) begin
      C[0] = 3;
      C[1] = 3;
      C[2] = 4;
    end else begin
      C[0] = 0;
      C[1] = 0;
      C[2] = 0;
    end
  end

  generate
    for (j=0; j<Nb; j = j + 1) begin
      assign State_out[4*j] = State_in[4*j];
    end
  endgenerate

  generate
    for (j=0; j<Nb; j = j + 1) begin
      for (i = 1; i < 4; i = i + 1) begin
        assign State_out[4*j+i] = State_in[4*((j+Nb-C[i-1])%Nb)+i];
      end
    end
  endgenerate


endmodule
