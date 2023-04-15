import aes_const::*;
import aes_wire::*;

module aes_tb(
  input logic rst,
  input logic clk
);

  timeunit 1ns;
  timeprecision 1ps;

  parameter enable_pipeline = 0;

  aes_in_type aes_in;
  aes_out_type aes_out;

  logic [(32*Nb-1):0] result;
  logic [(32*Nb-1):0] orig;

  logic [0:0] enable;

  integer state;

  integer i;

  logic [(32*Nk-1):0] key_block [0:0];
  logic [(32*Nb-1):0] data_block [0:(Nw-1)];
  logic [(32*Nb-1):0] encrypt_block [0:(Nw-1)];

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
          $write("%c[1;34m",8'h1B);
          $write("KEY: ");
          $write("%c[0m",8'h1B);
          $display("%x",key_block[0]);
          $write("%c[1;34m",8'h1B);
          $write("DATA: ");
          $write("%c[0m",8'h1B);
          $display("%x",data_block[0]);
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
          $write("%c[1;34m",8'h1B);
          $write("ENCRYPT: ");
          $write("%c[0m",8'h1B);
          $display("%x",aes_out.result);
          $write("%c[1;34m",8'h1B);
          $write("CORRECT: ");
          $write("%c[0m",8'h1B);
          $display("%x",encrypt_block[i]);
          if (|(aes_out.result ^ encrypt_block[i]) == 0) begin
            $write("%c[1;32m",8'h1B);
            $display("TEST SUCCEEDED");
            $write("%c[0m",8'h1B);
          end else begin
            $write("%c[1;31m",8'h1B);
            $display("TEST FAILED");
            $write("%c[0m",8'h1B);
          end
          result <= aes_out.result;
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
          $write("%c[1;34m",8'h1B);
          $write("DECRYPT: ");
          $write("%c[0m",8'h1B);
          $display("%x",aes_out.result);
          $write("%c[1;34m",8'h1B);
          $write("CORRECT: ");
          $write("%c[0m",8'h1B);
          $display("%x",data_block[i]);
          orig <= aes_out.result;
          if (|(aes_out.result ^ data_block[i]) == 0) begin
            $write("%c[1;32m",8'h1B);
            $display("TEST SUCCEEDED");
            $write("%c[0m",8'h1B);
          end else begin
            $write("%c[1;31m",8'h1B);
            $display("TEST FAILED");
            $write("%c[0m",8'h1B);
          end
        end
      end else begin
        if (i==(Nw-1)) begin
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
