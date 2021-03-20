import aes_const::*;
import aes_wire::*;

module aes_state
(
  input logic rst,
  input logic clk,
  input aes_in_type aes_in,
  output aes_out_type aes_out
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [31:0] kexp [0:(Nb*(Nr+1)-1)];

  logic [7 : 0] sbox [0:255];
  logic [7 : 0] ibox [0:255];
  logic [7 : 0] exp3 [0:255];
  logic [7 : 0] ln3 [0:255];
  logic [7 : 0] rcon [0:15];

  logic [7:0] key_array[0:(4*Nk-1)];
  logic [7:0] data_array[0:(4*Nb-1)];
  logic [7:0] cipher_array[0:(4*Nb-1)];
  logic [7:0] icipher_array[0:(4*Nb-1)];

  logic [(32*Nb-1):0] cipher_data;
  logic [(32*Nb-1):0] icipher_data;

  logic [0 : 0] kexp_enable;
  logic [0 : 0] cipher_enable;
  logic [0 : 0] icipher_enable;

  logic [0 : 0] kexp_ready;
  logic [0 : 0] cipher_ready;
  logic [0 : 0] icipher_ready;

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
    .key_in (aes_in.key),
    .key_out (key_array)
  );

  aes_xdata aes_xdata_comp
  (
    .data_in (aes_in.data),
    .data_out (data_array)
  );

  aes_kexp_state aes_kexp_state_comp
  (
    .rst (rst),
    .clk (clk),
    .Key (key_array),
    .RCon (rcon),
    .SBox (sbox),
    .Enable (kexp_enable),
    .KExp (kexp),
    .Ready_out (kexp_ready)
  );

  aes_cipher_state aes_cipher_state_comp
  (
    .rst (rst),
    .clk (clk),
    .SBox (sbox),
    .EXP3 (exp3),
    .LN3 (ln3),
    .KExp (kexp),
    .Data_in (data_array),
    .Enable (cipher_enable),
    .Data_out (cipher_array),
    .Ready_out (cipher_ready)
  );

  aes_icipher_state aes_icipher_state_comp
  (
    .rst (rst),
    .clk (clk),
    .IBox (ibox),
    .EXP3 (exp3),
    .LN3 (ln3),
    .KExp (kexp),
    .Data_in (data_array),
    .Enable (icipher_enable),
    .Data_out (icipher_array),
    .Ready_out (icipher_ready)
  );

  aes_cdata aes_cdata_cipher_comp
  (
    .data_in (cipher_array),
    .data_out (cipher_data)
  );

  aes_cdata aes_cdata_icipher_comp
  (
    .data_in (icipher_array),
    .data_out (icipher_data)
  );

  always_comb begin

    kexp_enable = 0;
    cipher_enable = 0;
    icipher_enable = 0;

    if (aes_in.enable == 1) begin
      if (aes_in.func == 1) begin
        kexp_enable = 1;
      end else if (aes_in.func == 2) begin
        cipher_enable = 1;
      end else if (aes_in.func == 3) begin
        icipher_enable = 1;
      end
    end

  end

  always_comb begin

    if (kexp_ready == 1) begin
      aes_out.result = 0;
      aes_out.ready = kexp_ready;
    end else if (cipher_ready == 1) begin
      aes_out.result = cipher_data;
      aes_out.ready = cipher_ready;
    end else if (icipher_ready == 1) begin
      aes_out.result = icipher_data;
      aes_out.ready = icipher_ready;
    end else begin
      aes_out.result = 0;
      aes_out.ready = 0;
    end

  end

endmodule
