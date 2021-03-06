default: none

VERILATOR ?= /opt/verilator/bin/verilator
SYSTEMC ?= /opt/systemc
BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CYCLES ?= 1
WAVE ?= "" # "wave" for saving dump file

simulate:
	sim/run.sh ${BASEDIR} ${VERILATOR} ${SYSTEMC} ${CYCLES} ${WAVE}

all: simulate
