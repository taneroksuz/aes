
`include "aes_config.svh"

module aes_round #(
  parameter KEY_BITS = `AES_KEY_BITS,
  parameter NK       = `AES_NK,
  parameter NR       = `AES_NR
)
(
  input logic [7:0] State_in [0:(15)],
  input logic [3:0] Index,
  input logic [31:0] KExp [0:(4*(NR+1)-1)],
  input logic [7:0] SBox [0:255],
  input logic [7:0] EXP3 [0:255],
  input logic [7:0] LN3 [0:255],
  output logic [7:0] State_out [0:(15)]
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] State_B [0:(15)];
  logic [7 : 0] State_R [0:(15)];
  logic [7 : 0] State_M [0:(15)];

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

  aes_mcol aes_mcol_comp
  (
    .State_in (State_R),
    .EXP3 (EXP3),
    .LN3 (LN3),
    .State_out (State_M)
  );

  aes_arkey aes_arkey_comp
  (
    .State_in (State_M),
    .KExp (KExp),
    .Index (Index),
    .State_out (State_out)
  );

endmodule
