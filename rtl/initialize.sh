#!/bin/bash

DIR=${1}
KEYLENGTH=${2}
NW=${3}

if [[ "$KEYLENGTH" = "128" ]];
then
  NB=4
  NK=4
  NR=10
elif [[ "$KEYLENGTH" = "192" ]];
then
  NB=4
  NK=6
  NR=12
elif [[ "$KEYLENGTH" = "256" ]];
then
  NB=4
  NK=8
  NR=14
else
  NB=4
  NK=4
  NR=10
fi

echo "package aes_const;" > $DIR/rtl/aes_const.sv
echo "  timeunit 1ns;" >> $DIR/rtl/aes_const.sv
echo "  timeprecision 1ps;" >> $DIR/rtl/aes_const.sv
echo "" >> $DIR/rtl/aes_const.sv
echo "  parameter Nb = $NB;" >> $DIR/rtl/aes_const.sv
echo "  parameter Nk = $NK;" >> $DIR/rtl/aes_const.sv
echo "  parameter Nr = $NR;" >> $DIR/rtl/aes_const.sv
echo "  parameter Nw = $NW;" >> $DIR/rtl/aes_const.sv
echo "" >> $DIR/rtl/aes_const.sv
echo "endpackage" >> $DIR/rtl/aes_const.sv
