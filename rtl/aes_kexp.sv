import aes_const::*;
import aes_wire::*;

module aes_kexp
(
  input logic rst,
  input logic clk,
  input logic [7:0] Key [0:(4*Nk-1)],
  input logic [7:0] RCon [0:15],
  input logic [7:0] SBox [0:255],
  input logic [0:0] Enable,
  output logic [31:0] KExp [0:(Nb*(Nr+1)-1)],
  output logic [0 : 0] Ready_out
);
  timeunit 1ns;
  timeprecision 1ps;

  localparam Nx = ((Nb*(Nr+1))+Nk-1)/Nk;

  logic [31 : 0] KExp_R [0:(Nb*(Nr+1)-1)];

  logic [31 : 0] KExp_P [0:(Nx-1)][0:(Nk-1)];
  logic [31 : 0] KExp_N [0:(Nx-1)][0:(Nk-1)];

  logic [0 : 0] Ready_P [0:(Nx-1)];
  logic [0 : 0] Ready_N [0:(Nx-1)];

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

  initial begin
    KExp_P = '{default:'{default:'0}};
    KExp_N = '{default:'{default:'0}};
  end

  genvar i,j;

  generate
    for (i = 0; i < Nk; i = i + 1) begin
      always_comb begin
        if (Enable == 1) begin
          KExp_P[0][i] = {Key[4*i],Key[4*i+1],Key[4*i+2],Key[4*i+3]};
        end
      end
    end
  endgenerate
  always_comb begin
    KExp_R[0:(Nk-1)] = KExp_P[0];
    Ready_P[0] = Enable;
  end
  always_ff @(posedge clk) begin
    KExp_N[0] <= KExp_P[0];
    Ready_N[0] <= Ready_P[0];
  end

  generate
    for (i = 1; i < $ceil((Nb*(Nr+1))/Nk); i = i + 1) begin
      for (j = 0; j < Nk; j = j + 1) begin
        if (j % Nk == 0) begin
          assign KExp_P[i][j] = KExp_N[i-1][j] ^ SubWord(RotWord(KExp_P[i-1][Nk-1])) ^ {RCon[i],24'h0};
        end else if (Nk > 6 && j % Nk == 4) begin
          assign KExp_P[i][j] = KExp_N[i-1][j] ^ SubWord(KExp_P[i][j-1]);
        end else begin
          assign KExp_P[i][j] = KExp_N[i-1][j] ^ KExp_P[i][j-1];
        end
      end
      always_comb begin
        KExp_R[Nk*i:(Nk*(i+1)-1)] = KExp_P[i];
        Ready_P[i] = Ready_N[i-1];
      end
      always_ff @(posedge clk) begin
        KExp_N[i] <= KExp_P[i];
        Ready_N[i] <= Ready_P[i];
      end
    end
  endgenerate

  always_comb begin
    KExp = KExp_R;
    Ready_out = Ready_N[Nx-1];
  end

endmodule
