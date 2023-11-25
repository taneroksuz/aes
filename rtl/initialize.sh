#!/bin/bash

if [[ "$KEY_LENGTH" = "0" ]];
then
  NB=4
  NK=4
  NR=10
elif [[ "$KEY_LENGTH" = "1" ]];
then
  NB=4
  NK=6
  NR=12
elif [[ "$KEY_LENGTH" = "2" ]];
then
  NB=4
  NK=8
  NR=14
else
  NB=4
  NK=4
  NR=10
fi

echo "package aes_const;" > $BASEDIR/rtl/aes_const.sv
echo "  timeunit 1ns;" >> $BASEDIR/rtl/aes_const.sv
echo "  timeprecision 1ps;" >> $BASEDIR/rtl/aes_const.sv
echo "" >> $BASEDIR/rtl/aes_const.sv
echo "  parameter Nb = $NB;" >> $BASEDIR/rtl/aes_const.sv
echo "  parameter Nk = $NK;" >> $BASEDIR/rtl/aes_const.sv
echo "  parameter Nr = $NR;" >> $BASEDIR/rtl/aes_const.sv
echo "  parameter Nw = $CASE_NUMBER;" >> $BASEDIR/rtl/aes_const.sv
echo "" >> $BASEDIR/rtl/aes_const.sv
echo "endpackage" >> $BASEDIR/rtl/aes_const.sv
