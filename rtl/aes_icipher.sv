import aes_const::*;
import aes_wire::*;

module aes_icipher(
  input logic rst,
  input logic clk,
  logic [7 : 0] IBox [0:255],
  logic [7 : 0] EXP3 [0:255],
  logic [7 : 0] LN3 [0:255],
  input logic [31:0] KExp [0:(Nb*(Nr+1)-1)],
  input logic [7 : 0] Data_in [0:(4*Nb-1)],
  output logic [7 : 0] Data_out [0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i;

  logic [7 : 0] State [0:Nr][0:(4*Nb-1)];

  aes_arkey aes_arkey_comp
  (
    .State_in (Data_in),
    .KExp (KExp),
    .Index (Nr),
    .State_out (State[Nr-1])
  );

  generate
    for (i=Nr-1; i>0; i=i-1) begin
      aes_iround aes_iround_comp
      (
        .State_in (State[i]),
        .Index (i[3:0]),
        .KExp (KExp),
        .IBox (IBox),
        .EXP3 (EXP3),
        .LN3 (LN3),
        .State_out (State[i-1])
      );
    end
  endgenerate;

  aes_ifround aes_ifround_comp
  (
    .State_in (State[0]),
    .Index (0),
    .KExp (KExp),
    .IBox (IBox),
    .State_out (Data_out)
  );

endmodule
