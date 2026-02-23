default: all

export VERILATOR ?= /usr/local/bin/verilator
export BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

export KEY_BITS ?= 256# 128 -> AES-128, 192 -> AES-192, 256 -> AES-256

export PLAINTEXT_BYTES ?= 16

export MAXTIME ?= 1000000000
export DUMP ?= 0# 1 -> enable, 0 -> disable

compile:
	g++ -O3 ${BASEDIR}/cpp/aes.cpp ${BASEDIR}/cpp/main.cpp -o ${BASEDIR}/out/main

run:
	${BASEDIR}/out/main ${KEY_BITS} ${PLAINTEXT_BYTES}

simulate:
	${BASEDIR}/sim/run.sh

generate:
	${BASEDIR}/sh/generate.sh ${KEY_BITS} ${PLAINTEXT_BYTES};

all: generate compile run simulate
