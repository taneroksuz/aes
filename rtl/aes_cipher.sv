import aes_const::*;
import aes_wire::*;

module aes_cipher(
  input logic rst,
  input logic clk,
  logic [7 : 0] SBox [0:255],
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
    .Index (0),
    .State_out (State[0])
  );

  generate
    for (i=1; i<Nr; i=i+1) begin
      aes_round aes_round_comp
      (
        .State_in (State[i-1]),
        .Index (i),
        .KExp (KExp),
        .SBox (SBox),
        .EXP3 (EXP3),
        .LN3 (LN3),
        .State_out (State[i])
      );
    end
  endgenerate;

  aes_fround aes_fround_comp
  (
    .State_in (State[Nr-1]),
    .Index (Nr),
    .KExp (KExp),
    .SBox (SBox),
    .State_out (Data_out)
  );

endmodule
