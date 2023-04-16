#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <cstring>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vaes_tb.h"

vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env)
{
  vluint64_t max_sim_time = 10000000;
  const char *filename = "aes.vcd";

  if (argc >= 2)
    max_sim_time = atoi(argv[1]);
  if (argc >= 3)
    filename = argv[2];

  Verilated::commandArgs(argc, argv);
  Vaes_tb *dut = new Vaes_tb;

#if VM_TRACE
  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  dut->trace(trace, 0);
  trace->open(filename);
#endif

  bool finished = false;

  while (sim_time < max_sim_time)
  {
    if (sim_time < 10)
      dut->rst = 0;
    else
      dut->rst = 1;

    dut->clk ^= 1;

    dut->eval();

#if VM_TRACE
    trace->dump(sim_time);
#endif

    sim_time++;

    if (Verilated::gotFinish())
    {
      finished = true;
      break;
    }
  }

  if (!finished)
  {
    std::cout << "\033[33m";
    std::cout << "TEST STOPPED" << std::endl;
    std::cout << "\033[0m";
  }

  std::cout << "simulation finished @" << sim_time << "ps" << std::endl;

#if VM_TRACE
  trace->close();
#endif

  delete dut;
  exit(EXIT_SUCCESS);
}