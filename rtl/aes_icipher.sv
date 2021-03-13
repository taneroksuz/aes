import aes_const::*;
import aes_wire::*;

module aes_icipher(
  input logic rst,
  input logic clk,
  input logic [7 : 0] IBox [0:255],
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
    .Index (Nr[3:0]),
    .State_out (State[Nr-1])
  );
  always_comb begin
    Ready[Nr-1] = Enable;
  end

  generate
    for (i=Nr-1; i>0; i=i-1) begin
      always_ff @(posedge clk) begin
        State_Reg[i] <= State[i];
        Ready_Reg[i] <= Ready[i];
      end
      aes_iround aes_iround_comp
      (
        .State_in (State_Reg[i]),
        .Index (i[3:0]),
        .KExp (KExp),
        .IBox (IBox),
        .EXP3 (EXP3),
        .LN3 (LN3),
        .State_out (State[i-1])
      );
      always_comb begin
        Ready[i-1] = Ready_Reg[i];
      end
    end
  endgenerate;

  always_ff @(posedge clk) begin
    State_Reg[0] <= State[0];
    Ready_Reg[0] <= Ready[0];
  end
  aes_ifround aes_ifround_comp
  (
    .State_in (State_Reg[0]),
    .Index (4'h0),
    .KExp (KExp),
    .IBox (IBox),
    .State_out (Data_out)
  );
  always_comb begin
    Ready_out = Ready_Reg[0];
  end

endmodule
