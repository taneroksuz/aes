import aes_const::*;
import aes_wire::*;

module aes
(
  input logic rst,
  input logic clk,
  input aes_in_type aes_in,
  output aes_out_type aes_out
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] SBox [0:255];
  logic [7 : 0] IBox [0:255];
  logic [7 : 0] EXP3 [0:255];
  logic [7 : 0] LN3 [0:255];
  logic [7 : 0] RCon [0:15];

  logic [31:0] KExp [0:(Nb*(Nr+1)-1)];

  localparam [1:0] idle = 2'h0;
  localparam [1:0] kexp = 2'h1;
  localparam [1:0] cipher  = 2'h2;
  localparam [1:0] icipher = 2'h3;

  aes_reg_type r,rin;
  aes_reg_type v;

  always_comb begin

    v = r;

    if (r.state == idle) begin
      if (aes_in.enable == 1) begin
        if (aes_in.func == kexp) begin
          v.key = aes_in.data;
          v.state = key_exp;
        end else if (aes_in.func == cipher) begin
          v.data = aes_in.data;
          v.state = cipher;
        end else if (aes_in.func == icipher) begin
          v.data = aes_in.data;
          v.state = icipher;
        end
      end
    end else if (r.state == kexp) begin
      v.state = idle;
    end else if (r.state == cipher) begin
      v.state = idle;
    end else if (r.state == icipher) begin
      v.state = idle;
    end

    rin = v;

  end

  always_ff @(posedge clk) begin
    if (rst == 0) begin
      r <= init_aes_reg;
    end else begin
      r <= rin;
    end
  end

endmodule
