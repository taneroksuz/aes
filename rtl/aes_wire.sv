package aes_wire;
  timeunit 1ns;
  timeprecision 1ps;

  typedef struct packed{
    logic [3   : 0] Nb;
    logic [3   : 0] Nk;
    logic [255 : 0] key;
    logic [255 : 0] data_in;
  } aes_in_type;

  typedef struct packed{
    logic [255 : 0] data_out;
  } aes_out_type;

endpackage
