package aes_wire;
  timeunit 1ns;
  timeprecision 1ps;

  typedef struct packed{
    logic [0 : 3] Nb;
    logic [0 : 3] Nk;
    logic [7 : 0] key [0:31];
    logic [7 : 0] data_in [0:31];
  } aes_in_type;

  typedef struct packed{
    logic [7 : 0] data_out [0:31];
  } aes_out_type;

endpackage
