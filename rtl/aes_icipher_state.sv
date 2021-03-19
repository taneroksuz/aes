import aes_const::*;
import aes_wire::*;

module aes_icipher_state(
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

  typedef struct packed{
    logic [3:0] state;
    logic [0:0] ready;
  } reg_type;

  reg_type init_reg = '{
    state : Nr,
    ready : 0
  };

  reg_type r,rin;
  reg_type v;

  logic [7 : 0] State_B_in [0:(4*Nb-1)];
  logic [7 : 0] State_R_in [0:(4*Nb-1)];
  logic [7 : 0] State_M_in [0:(4*Nb-1)];
  logic [7 : 0] State_A_in [0:(4*Nb-1)];

  logic [7 : 0] State_B_out [0:(4*Nb-1)];
  logic [7 : 0] State_R_out [0:(4*Nb-1)];
  logic [7 : 0] State_M_out [0:(4*Nb-1)];
  logic [7 : 0] State_A_out [0:(4*Nb-1)];

  logic [7 : 0] State_P [0:(4*Nb-1)];
  logic [7 : 0] State_N [0:(4*Nb-1)];

  logic [3 : 0] Index;

  initial begin
    State_P = '{default:'0};
    State_N = '{default:'0};
  end

  always_comb begin

    v = r;

    case (r.state)
      Nr :
        begin
          if (Enable == 1) begin
            v.state = Nr-1;
          end
          v.ready = 0;
          State_A_in = Data_in;
          State_P = State_A_out;
          Index = Nr[3:0];
        end
      0 :
        begin
          v.state = Nr;
          v.ready = 1;
          State_R_in = State_N;
          State_B_in = State_R_out;
          State_A_in = State_B_out;
          State_P = State_A_out;
          Index = 4'h0;
        end
      default:
        begin
          v.state = v.state - 1;
          v.ready = 0;
          State_R_in = State_N;
          State_B_in = State_R_out;
          State_A_in = State_B_out;
          State_M_in = State_A_out;
          State_P = State_M_out;
          Index = r.state;
        end
    endcase

    rin = v;

    Data_out = State_N;
    Ready_out = r.ready;

  end

  always_ff @(posedge clk) begin
    State_N <= State_P;
  end

  aes_isrow aes_isrow_comp
  (
    .State_in (State_R_in),
    .State_out (State_R_out)
  );

  aes_isbyte aes_isbyte_comp
  (
    .State_in (State_B_in),
    .IBox (IBox),
    .State_out (State_B_out)
  );

  aes_arkey aes_arkey_comp
  (
    .State_in (State_A_in),
    .KExp (KExp),
    .Index (Index),
    .State_out (State_A_out)
  );

  aes_imcol aes_imcol_comp
  (
    .State_in (State_M_in),
    .EXP3 (EXP3),
    .LN3 (LN3),
    .State_out (State_M_out)
  );

  always_ff @(posedge clk) begin
    if (rst == 0) begin
      r <= init_reg;
    end else begin
      r <= rin;
    end
  end

endmodule
