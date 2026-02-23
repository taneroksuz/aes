
`include "aes_config.svh"

module aes_kexp_state #(
  parameter KEY_BITS = `AES_KEY_BITS,
  parameter NK       = `AES_NK,
  parameter NR       = `AES_NR
)
(
  input logic rst,
  input logic clk,
  input logic [7:0] Key [0:(4*NK-1)],
  input logic [7:0] RCon [0:15],
  input logic [7:0] SBox [0:255],
  input logic [0:0] Enable,
  output logic [31:0] KExp [0:(4*(NR+1)-1)],
  output logic [0 : 0] Ready_out
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [31 : 0] KExp_R [0:(4*(NR+1)-1)];
  logic [31 : 0] KExp_P [0:(NK-1)];
  logic [31 : 0] KExp_N [0:(NK-1)];

  localparam LENGTH = (4*(NR+1));
  localparam WIDTH = $clog2(LENGTH);

  typedef struct packed{
    logic [3:0] state;
    logic [(WIDTH-1):0] index;
    logic [0:0] enable;
    logic [0:0] ready;
  } reg_type;

  reg_type init_reg = '{
    state : 0,
    index : 0,
    enable : 0,
    ready : 0
  };

  reg_type r,rin;
  reg_type v;

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
    KExp_P = '{default:'0};
    KExp_N = '{default:'0};
  end

  always_comb begin

    v = r;

    case (r.state)
      0 : begin
        v.index = 0;
        v.enable = 0;
        v.ready = 0;
        if (Enable == 1) begin
          v.state = 1;
          v.enable = 1;
          for (int i=0; i<NK; i=i+1) begin
            KExp_P[i] = {Key[4*i],Key[4*i+1],Key[4*i+2],Key[4*i+3]};
          end
        end
      end
      default : begin
        for (int i=0; i<NK; i=i+1) begin
          if (i == 0) begin
            KExp_P[i] = KExp_N[i] ^ SubWord(RotWord(KExp_N[NK-1])) ^ {RCon[v.state],24'h0};
          end else if (NK > 6 && i == 4) begin
            KExp_P[i] = KExp_N[i] ^ SubWord(KExp_P[i-1]);
          end else begin
            KExp_P[i] = KExp_N[i] ^ KExp_P[i-1];
          end
        end
        if (v.index > (4*(NR+1)-NK)) begin
          v.state = 0;
          v.ready = 1;
        end else begin
          v.state = v.state + 1;
          v.ready = 0;
        end
      end
    endcase

    for (int i=0; i<NK; i=i+1) begin
      if (((v.index+i[(WIDTH-1):0]) < 4*(NR+1)) && (v.enable == 1)) begin
        KExp_R[v.index+i[(WIDTH-1):0]] = KExp_P[i];
      end
    end

    v.index = v.index + NK;

    rin = v;

    KExp = KExp_R;
    Ready_out = r.ready;

  end

  always_ff @(posedge clk) begin
    KExp_N <= KExp_P;
  end

  always_ff @(posedge clk) begin
    if (rst == 0) begin
      r <= init_reg;
    end else begin
      r <= rin;
    end
  end

endmodule
