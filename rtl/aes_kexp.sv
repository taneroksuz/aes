import aes_const::*;
import aes_wire::*;

module aes_kexp
(
  input logic [7:0] Key [0:31],
  input logic [7:0] RCon [0:15],
  input logic [7:0] SBox [0:255],
  output logic [31:0] KExp [0:(Nb*(Nr+1)-1)]
);
  timeunit 1ns;
  timeprecision 1ps;

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
    for (i = 0; i < Nk; i = i + 1) begin
      assign KExp[i] = {Key[4*i],Key[4*i+1],Key[4*i+2],Key[4*i+3]};
    end
  endgenerate

  generate
    for (i = Nk; i < Nb*(Nr+1); i = i + 1) begin
      if (i % Nk == 0) begin
        assign KExp[i] = KExp[i-Nk] ^ SubWord(RotWord(KExp[i-1])) ^ {RCon[i/Nk],24'h0};
      end else if (Nk > 6 && i % Nk == 4) begin
        assign KExp[i] = KExp[i-Nk] ^ SubWord(KExp[i-1]);
      end else begin
        assign KExp[i] = KExp[i-Nk] ^ KExp[i-1];
      end
    end
  endgenerate

endmodule
