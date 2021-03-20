import aes_const::*;
import aes_wire::*;

module aes_kexp
(
  input logic [7:0] Key [0:(4*Nk-1)],
  input logic [7:0] RCon [0:15],
  input logic [7:0] SBox [0:255],
  input logic [0:0] Enable,
  output logic [31:0] KExp [0:(Nb*(Nr+1)-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7:0] key [0:(4*Nk-1)];

  function [31:0] RotWord;
    input [31:0] Word;
    begin
      RotWord = {Word[23:0],Word[31:24]};
    end
  endfunction

  function [31:0] SubWord;
    input [31:0] Word;
    begin
      SubWord = {SBox[Word[31:24]],SBox[Word[23:16]],SBox[Word[15:8]],SBox[Word[7:0]]};
    end
  endfunction

  genvar i;

  generate
    for (i = 0; i < 4*Nk; i = i + 1) begin
      always_comb begin
        if (Enable == 1) begin
          key[i] = Key[i];
        end
      end
    end
  endgenerate

  generate
    for (i = 0; i < Nb*(Nr+1); i = i + 1) begin
      if (i<Nk) begin
        assign KExp[i] = {key[4*i],key[4*i+1],key[4*i+2],key[4*i+3]};
      end else if (i % Nk == 0) begin
        assign KExp[i] = KExp[i-Nk] ^ SubWord(RotWord(KExp[i-1])) ^ {RCon[i/Nk],24'h0};
      end else if (Nk > 6 && i % Nk == 4) begin
        assign KExp[i] = KExp[i-Nk] ^ SubWord(KExp[i-1]);
      end else begin
        assign KExp[i] = KExp[i-Nk] ^ KExp[i-1];
      end
    end
  endgenerate

endmodule
