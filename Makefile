default: none

export VERILATOR ?= /opt/verilator/bin/verilator
export SYSTEMC ?= /opt/systemc
export BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
export MAXTIME ?= 1000000000
export KLENGTH ?= 128
export NWORDS ?= 100
export WAVE ?= off# on off

compile:
	g++ -O3 ${BASEDIR}/cpp/aes.cpp ${BASEDIR}/cpp/main.cpp -o ${BASEDIR}/cpp/main

run:
	cp -r ${BASEDIR}/py/*.txt ${BASEDIR}/cpp/; \
	cd ${BASEDIR}/cpp; \
	./main ${KLENGTH} ${NWORDS}

simulate:
	${BASEDIR}/rtl/initialize.sh; \
	${BASEDIR}/sim/run.sh

generate:
	cd ${BASEDIR}/py; \
	./generate.py -k ${KLENGTH} -w ${NWORDS};

all: generate compile run simulate
