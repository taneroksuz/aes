import aes_const::*;
import aes_wire::*;

module aes_ifround
(
  input logic [7:0] State_in [0:(4*Nb-1)],
  input logic [3:0] Index,
  input logic [31:0] KExp [0:(Nb*(Nr+1)-1)],
  input logic [7:0] IBox [0:255],
  output logic [7:0] State_out [0:(4*Nb-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] State_R [0:(4*Nb-1)];
  logic [7 : 0] State_B [0:(4*Nb-1)];

  aes_isrow aes_isrow_comp
  (
    .State_in (State_in),
    .State_out (State_R)
  );

  aes_isbyte aes_isbyte_comp
  (
    .State_in (State_R),
    .IBox (IBox),
    .State_out (State_B)
  );

  aes_arkey aes_arkey_comp
  (
    .State_in (State_B),
    .KExp (KExp),
    .Index (Index),
    .State_out (State_out)
  );

endmodule
