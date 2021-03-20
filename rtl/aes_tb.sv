import aes_const::*;
import aes_wire::*;

module aes_tb(
  input logic rst,
  input logic clk
);

  timeunit 1ns;
  timeprecision 1ps;

  parameter enable_pipeline = 1;

  aes_in_type aes_in;
  aes_out_type aes_out;

  logic [(32*Nb-1):0] result;
  logic [(32*Nb-1):0] orig;

  logic [0:0] enable;

  integer state;

  integer i;

  logic [(32*Nk-1):0] key_block [0:0];
  logic [(32*Nb-1):0] data_block [0:99];
  logic [(32*Nb-1):0] encrypt_block [0:99];

  initial begin
    $readmemh("key.txt", key_block);
    $readmemh("data.txt", data_block);
    $readmemh("encrypt.txt", encrypt_block);
  end

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
      i <= 0;
    end else begin
      if (state == 0) begin
        aes_in.key <= key_block[0];
        aes_in.data <= 0;
        aes_in.func <= 1;
        aes_in.enable <= enable;
        enable <= 0;
        if (aes_out.ready == 1) begin
          enable <= 1;
          state <= state + 1;
          $display("Key: %X",key_block[0]);
        end
      end else if (state == 1) begin
        aes_in.key <= 0;
        aes_in.data <= data_block[i];
        aes_in.func <= 2;
        aes_in.enable <= enable;
        enable <= 0;
        if (aes_out.ready == 1) begin
          enable <= 1;
          state <= state + 1;
          $display("Encrypt: %X",aes_out.result);
          $display("Correct: %X",encrypt_block[i]);
          result <= aes_out.result;
          if (|(aes_out.result ^ encrypt_block[i]) == 0) begin
            $display("Encryption success!");
          end else begin
            $display("Encryption failed!");
            $finish;
          end
        end
      end else if (state == 2) begin
        aes_in.key <= 0;
        aes_in.data <= result;
        aes_in.func <= 3;
        aes_in.enable <= enable;
        enable <= 0;
        if (aes_out.ready == 1) begin
          enable <= 1;
          state <= state + 1;
          $display("Decrypt: %X",aes_out.result);
          $display("Correct: %X",data_block[i]);
          orig <= aes_out.result;
          if (|(aes_out.result ^ data_block[i]) == 0) begin
            $display("Decryption success!");
          end else begin
            $display("Decryption failed!");
            $finish;
          end
        end
      end else begin
        if (i==99) begin
          $display("Test success!");
          $finish;
        end else begin
          i <= i+1;
          state <= 1;
        end
      end
    end
  end

  generate

    if (enable_pipeline) begin

      aes aes_comp
      (
        .rst (rst),
        .clk (clk),
        .aes_in (aes_in),
        .aes_out (aes_out)
      );

    end else begin

      aes_state aes_state_comp
      (
        .rst (rst),
        .clk (clk),
        .aes_in (aes_in),
        .aes_out (aes_out)
      );

    end

  endgenerate

endmodule
