import aes_const::*;
import aes_wire::*;

module aes_tb(
  input logic rst,
  input logic clk
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] SBox [0:255];
  logic [7 : 0] IBox [0:255];
  logic [7 : 0] EXP3 [0:255];
  logic [7 : 0] LN3 [0:255];
  logic [7 : 0] RCon [0:15];

  logic [7 : 0] Key [0:(4*Nk-1)];
  logic [7 : 0] Data [0:(4*Nb-1)];

  logic [31:0] KExp [0:(Nb*(Nr+1)-1)];

  integer counter;

  initial begin

    counter = 0;

  end

  aes_array aes_array_comp
  (
    .S_Box (SBox),
    .I_Box (IBox),
    .EXP_3 (EXP3),
    .LN_3 (LN3),
    .R_Con (RCon)
  );

  aes_xkey aes_xkey_comp
  (
    .key_in (key),
    .key_out (Key)
  );

  aes_xdata aes_xdata_comp
  (
    .data_in (data),
    .data_out (Data)
  );

  aes_kexp aes_kexp_comp
  (
    .Key (Key),
    .RCon (RCon),
    .SBox (SBox),
    .KExp (KExp)
  );

  always_ff @(posedge clk) begin
    if (counter == Nb*(Nr+1)) begin
      $finish;
    end else begin
      $display("%D -> %X",counter,KExp[counter]);
      counter = counter + 1;
    end
  end

endmodule
