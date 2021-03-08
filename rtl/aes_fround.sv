import aes_const::*;
import aes_wire::*;

module aes_fround
(
  input logic [7:0] State_in [0:(4*Nb-1)],
  input logic [3:0] Index,
  input logic [31:0] KExp [0:(Nb*(Nr+1)-1)],
  input logic [7:0] SBox [0:255],
  output logic [7:0] State_out [0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] State_B [0:(4*Nb-1)];
  logic [7 : 0] State_R [0:(4*Nb-1)];

  aes_sbyte aes_sbyte_comp
  (
    .State_in (State_in),
    .SBox (SBox),
    .State_out (State_B)
  );

  aes_srow aes_srow_comp
  (
    .State_in (State_B),
    .State_out (State_R)
  );

  aes_arkey aes_arkey_comp
  (
    .State_in (State_R),
    .KExp (KExp),
    .Index (Index),
    .State_out (State_out)
  );

endmodule
