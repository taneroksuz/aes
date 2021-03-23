default: none

VERILATOR ?= /opt/verilator/bin/verilator
SYSTEMC ?= /opt/systemc
BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CYCLES ?= 1000000000
KLENGTH ?= 128
NWORDS ?= 100
WAVE ?= "" # "wave" for saving dump file

compile:
	g++ -O3 ${BASEDIR}/cpp/aes.cpp ${BASEDIR}/cpp/main.cpp -o ${BASEDIR}/cpp/main.o

run:
	cp -r ${BASEDIR}/py/*.txt ${BASEDIR}/cpp/; \
	cd ${BASEDIR}/cpp; \
	./main.o ${KLENGTH} ${NWORDS}

simulate:
	sim/run.sh ${BASEDIR} ${VERILATOR} ${SYSTEMC} ${CYCLES} ${WAVE}

generate:
	cd ${BASEDIR}/py; \
	./generate.py -k ${KLENGTH} -w ${NWORDS};

all: generate simulate
