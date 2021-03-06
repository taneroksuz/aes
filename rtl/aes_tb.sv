import aes_const::*;
import aes_wire::*;

module aes_tb(
  input logic rst,
  input logic clk
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] SBox [0:255];
  logic [7 : 0] IBox [0:255];
  logic [7 : 0] EXP3 [0:255];
  logic [7 : 0] LN3 [0:255];
  logic [7 : 0] RCon [0:15];

  logic [7 : 0] Key [0:31];

  logic [31:0] KExp [0:119];

  integer counter;

  initial begin

    Key[0]=8'h2b; Key[1]=8'h7e; Key[2]=8'h15; Key[3]=8'h16; Key[4]=8'h28; Key[5]=8'hae; Key[6]=8'hd2; Key[7]=8'ha6; Key[8]=8'hab; Key[9]=8'hf7; Key[10]=8'h15; Key[11]=8'h88; Key[12]=8'h09; Key[13]=8'hcf; Key[14]=8'h4f; Key[15]=8'h3c;
    Key[16]=8'h0; Key[17]=8'h0; Key[18]=8'h0; Key[19]=8'h0; Key[20]=8'h0; Key[21]=8'h0; Key[22]=8'h0; Key[23]=8'h0; Key[24]=8'h0; Key[25]=8'h0; Key[26]=8'h0; Key[27]=8'h0; Key[28]=8'h0; Key[29]=8'h0; Key[30]=8'h0; Key[31]=8'h0;

    counter = 0;

  end

  aes_array aes_array_comp
  (
    .S_Box (SBox),
    .I_Box (IBox),
    .EXP_3 (EXP3),
    .LN_3 (LN3),
    .R_Con (RCon)
  );

  aes_kexp aes_kexp_comp
  (
    .Key (Key),
    .RCon (RCon),
    .SBox (SBox),
    .KExp (KExp)
  );

  always_ff @(posedge clk) begin
    if (counter == 120) begin
      $finish;
    end else begin
      $display("%D -> %X",counter,KExp[counter]);
      counter = counter + 1;
    end
  end

endmodule
