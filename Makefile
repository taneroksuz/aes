default: none

VERILATOR ?= /opt/verilator/bin/verilator
SYSTEMC ?= /opt/systemc
BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CYCLES ?= 10000000
WAVE ?= "" # "wave" for saving dump file

compile:
	g++ -DDEBUG -DLINE -O3 ${BASEDIR}/cpp/aes.cpp ${BASEDIR}/cpp/main.cpp -o ${BASEDIR}/cpp/main.o
	${BASEDIR}/cpp/main.o

simulate:
	sim/run.sh ${BASEDIR} ${VERILATOR} ${SYSTEMC} ${CYCLES} ${WAVE}

all: simulate
