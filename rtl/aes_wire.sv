package aes_wire;
  timeunit 1ns;
  timeprecision 1ps;

  import aes_const::*;

  typedef struct packed{
    logic [(32*Nk-1):0] key;
    logic [(32*Nb-1):0] data;
    logic [1 : 0] func;
    logic [0 : 0] enable;
  } aes_in_type;

  typedef struct packed{
    logic [(32*Nb-1):0] result;
    logic [0 : 0] ready;
  } aes_out_type;

endpackage
