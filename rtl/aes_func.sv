package aes_func;
  timeunit 1ns;
  timeprecision 1ps;

  function [3:0] Nr;
    input [3:0] Nb;
    input [3:0] Nk;
    begin
      if (Nb == 4 && Nk == 4) begin
        Nr = 10;
      end else if (Nb == 4 && Nk == 6) begin
        Nr = 12;
      end else if (Nb == 4 && Nk == 8) begin
        Nr = 14;
      end else if (Nb == 6 && Nk == 4) begin
        Nr = 12;
      end else if (Nb == 6 && Nk == 6) begin
        Nr = 12;
      end else if (Nb == 6 && Nk == 8) begin
        Nr = 14;
      end else if (Nb == 8 && Nk == 4) begin
        Nr = 14;
      end else if (Nb == 8 && Nk == 6) begin
        Nr = 14;
      end else if (Nb == 8 && Nk == 8) begin
        Nr = 14;
      end else begin
        Nr = 0;
      end
    end
  endfunction

endpackage
