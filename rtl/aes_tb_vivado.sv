import aes_const::*;
import aes_wire::*;

module aes_tb_vivado;

  timeunit 1ns;
  timeprecision 1ps;

  logic rst;
  logic clk;

  initial begin
    clk = 1;
  end

  always begin
    #5;
    clk = !clk;
  end

  initial begin
    rst = 0;
    #100;
    rst = 1;
  end

  aes_tb aes_tb_comp
  (
    .rst (rst),
    .clk (clk)
  );

endmodule
