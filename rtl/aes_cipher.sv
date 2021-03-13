import aes_const::*;
import aes_wire::*;

module aes_cipher(
  input logic rst,
  input logic clk,
  input logic [7 : 0] SBox [0:255],
  input logic [7 : 0] EXP3 [0:255],
  input logic [7 : 0] LN3 [0:255],
  input logic [31:0] KExp [0:(Nb*(Nr+1)-1)],
  input logic [7 : 0] Data_in [0:(4*Nb-1)],
  input logic [0 : 0] Enable,
  output logic [7 : 0] Data_out [0:(4*Nb-1)],
  output logic [0 : 0] Ready_out
);
  timeunit 1ns;
  timeprecision 1ps;

  genvar i;

  logic [7 : 0] State [0:Nr-1][0:(4*Nb-1)];
  logic [7 : 0] State_Reg [0:Nr-1][0:(4*Nb-1)];

  logic [0 : 0] Ready [0:Nr-1];
  logic [0 : 0] Ready_Reg [0:Nr-1];

  aes_arkey aes_arkey_comp
  (
    .State_in (Data_in),
    .KExp (KExp),
    .Index (4'h0),
    .State_out (State[0])
  );
  always_comb begin
    Ready[0] = Enable;
  end

  generate
    for (i=1; i<Nr; i=i+1) begin
      always_ff @(posedge clk) begin
        State_Reg[i-1] <= State[i-1];
        Ready_Reg[i-1] <= Ready[i-1];
      end
      aes_round aes_round_comp
      (
        .State_in (State_Reg[i-1]),
        .Index (i[3:0]),
        .KExp (KExp),
        .SBox (SBox),
        .EXP3 (EXP3),
        .LN3 (LN3),
        .State_out (State[i])
      );
      always_comb begin
        Ready[i] = Ready_Reg[i-1];
      end
    end
  endgenerate;

  always_ff @(posedge clk) begin
    State_Reg[Nr-1] <= State[Nr-1];
    Ready_Reg[Nr-1] <= Ready[Nr-1];
  end
  aes_fround aes_fround_comp
  (
    .State_in (State_Reg[Nr-1]),
    .Index (Nr[3:0]),
    .KExp (KExp),
    .SBox (SBox),
    .State_out (Data_out)
  );
  always_comb begin
    Ready_out = Ready_Reg[Nr-1];
  end

endmodule
