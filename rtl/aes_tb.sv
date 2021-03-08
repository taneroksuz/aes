import aes_const::*;
import aes_wire::*;

module aes_tb(
  input logic rst,
  input logic clk
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [31:0] kexp [0:(Nb*(Nr+1)-1)];

  logic [7 : 0] sbox [0:255];
  logic [7 : 0] ibox [0:255];
  logic [7 : 0] exp3 [0:255];
  logic [7 : 0] ln3 [0:255];
  logic [7 : 0] rcon [0:15];

  logic [7 : 0] Key [0:(4*Nk-1)];
  logic [7 : 0] Data [0:(4*Nb-1)];
  logic [7 : 0] Result [0:(4*Nb-1)];
  logic [7 : 0] Orig [0:(4*Nb-1)];

  integer j,k,l,m;

  aes_array aes_array_comp
  (
    .SBox (sbox),
    .IBox (ibox),
    .EXP3 (exp3),
    .LN3 (ln3),
    .RCon (rcon)
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
    .RCon (rcon),
    .SBox (sbox),
    .KExp (kexp)
  );

  aes_cipher aes_cipher_comp
  (
    .rst (rst),
    .clk (clk),
    .SBox (sbox),
    .EXP3 (exp3),
    .LN3 (ln3),
    .KExp (kexp),
    .Data_in (Data),
    .Data_out (Result)
  );

  aes_icipher aes_icipher_comp
  (
    .rst (rst),
    .clk (clk),
    .IBox (ibox),
    .EXP3 (exp3),
    .LN3 (ln3),
    .KExp (kexp),
    .Data_in (Result),
    .Data_out (Orig)
  );

  always_ff @(posedge clk) begin
    if (rst == 0) begin
      j <= 0;
      k <= 0;
      m <= 0;
    end else begin
      if (j < Nb*(Nr+1)) begin
        $write("%D -> %X\n",j,kexp[j]);
        j <= j + 1;
      end else begin
        if (l<4) begin
          if (m<Nb) begin
            $write("%X |",Orig[4*m+l]);
            m <= m + 1;
          end else begin
            m <= 0;
            l <= l + 1;
            $write("\n");
          end
        end else begin
          $finish;
        end
      end
    end
  end

endmodule
