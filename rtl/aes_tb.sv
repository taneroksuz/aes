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

  initial begin

    Key[0]=8'h32; Key[1]=8'h43; Key[2]=8'hf6; Key[3]=8'ha8; Key[4]=8'h88; Key[5]=8'h5a; Key[6]=8'h30; Key[7]=8'h8d; Key[8]=8'h31; Key[9]=8'h31; Key[10]=8'h98; Key[11]=8'ha2; Key[12]=8'he0; Key[13]=8'h37; Key[14]=8'h07; Key[15]=8'h34;
    Key[16]=8'h0; Key[17]=8'h0; Key[18]=8'h0; Key[19]=8'h0; Key[20]=8'h0; Key[21]=8'h0; Key[22]=8'h0; Key[23]=8'h0; Key[24]=8'h0; Key[25]=8'h0; Key[26]=8'h0; Key[27]=8'h0; Key[28]=8'h0; Key[29]=8'h0; Key[30]=8'h0; Key[31]=8'h0;

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
    .SBox (SBox)
  );

endmodule
