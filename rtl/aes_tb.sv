import aes_const::*;
import aes_wire::*;

module aes_tb(
  input logic rst,
  input logic clk
);

  timeunit 1ns;
  timeprecision 1ps;

  aes_in_type aes_in;
  aes_out_type aes_out;

  logic [(32*Nb-1):0] result;
  logic [(32*Nb-1):0] orig;

  logic [0:0] enable;

  integer state;

  integer j,k,l,m;

  always_ff @(posedge clk) begin
    if (rst == 0) begin
      aes_in.key <= 0;
      aes_in.data <= 0;
      aes_in.func <= 0;
      aes_in.enable <= 0;
      enable <= 1;
      state <= 0;
      result <= 0;
      orig <= 0;
    end else begin
      if (state == 0) begin
        aes_in.key <= key;
        aes_in.data <= 0;
        aes_in.func <= 1;
        aes_in.enable <= enable;
        enable <= 1;
        state <= state + 1;
      end else if (state == 1) begin
        aes_in.key <= 0;
        aes_in.data <= data;
        aes_in.func <= 2;
        aes_in.enable <= enable;
        enable <= 0;
        if (aes_out.ready == 1) begin
          enable <= 1;
          state <= state + 1;
          $display("Cipher: %X",aes_out.result);
          result <= aes_out.result;
        end
      end else if (state == 2) begin
        aes_in.key <= 0;
        aes_in.data <= result;
        aes_in.func <= 3;
        aes_in.enable <= enable;
        enable <= 0;
        if (aes_out.ready == 1) begin
          state <= state + 1;
          $display("ICipher: %X",aes_out.result);
          orig <= aes_out.result;
        end
      end else begin
        $finish;
      end
    end
  end

  aes aes_comp
  (
    .rst (rst),
    .clk (clk),
    .aes_in (aes_in),
    .aes_out (aes_out)
  );

endmodule
