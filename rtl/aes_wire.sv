package aes_wire;
  timeunit 1ns;
  timeprecision 1ps;

  typedef struct packed{
    logic [255 : 0] data;
    logic [1   : 0] func;
    logic [0   : 0] enable;
  } aes_in_type;

  typedef struct packed{
    logic [255 : 0] data;
    logic [0   : 0] ready;
  } aes_out_type;

  typedef struct packed{
    logic [1   : 0] state;
    logic [3   : 0] round;
    logic [255 : 0] key;
    logic [255 : 0] data;
    logic [255 : 0] result;
    logic [3   : 0] Nb;
    logic [3   : 0] Nk;
    logic [3   : 0] Nr;
  } aes_reg_type;

  aes_reg_type init_aes_reg = '{
    state : 0,
    round : 0,
    key : 0,
    data : 0,
    result : 0,
    Nb : 0,
    Nk : 0,
    Nr : 0
  };

endpackage
