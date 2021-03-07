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

  logic [7 : 0] State [0:(4*Nb-1)];
  logic [7 : 0] State_B [0:(4*Nb-1)];
  logic [7 : 0] State_R [0:(4*Nb-1)];
  logic [7 : 0] State_M [0:(4*Nb-1)];

  integer counter;
  integer i,j,k;

  initial begin

    counter = 0;
    i = 0;
    j = 0;
    k = 0;

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

  aes_arkey #(0) aes_arkey_comp
  (
    .State_in (Data),
    .KExp (KExp),
    .State_out (State)
  );

  aes_sbyte aes_sbyte_comp
  (
    .State_in (State),
    .S_Box (SBox),
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
    .EXP_3 (EXP3),
    .LN_3 (LN3),
    .State_out (State_M)
  );

  always_ff @(posedge clk) begin
    if (counter < Nb*(Nr+1)) begin
      $write("%D -> %X\n",counter,KExp[counter]);
      counter <= counter + 1;
    end else begin
      if (i<4) begin
        if (j<Nb) begin
          // $write("%X |",Data[4*j+i]);
          // $write("%X |",State[4*j+i]);
          // $write("%X |",State_B[4*j+i]);
          // $write("%X |",State_R[4*j+i]);
          $write("%X |",State_M[4*j+i]);
          // $write("%X |",KExp[j]);
          j <= j + 1;
        end else begin
          j <= 0;
          i <= i + 1;
          $write("\n");
        end
      end else begin
        $finish;
      end
    end
  end

endmodule
