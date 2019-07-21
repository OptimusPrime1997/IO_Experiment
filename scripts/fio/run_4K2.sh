#!/bin/bash
R=$1
S=$2
C=$3
Q=$4
N=$5
V=$6
F=$7
core=$8

fio /home/ljh/exp/scripts/fio/$R > "/home/ljh/exp/logs/fio/4K2_s"$S"_c"$C"_q"$Q"_"$N"_v"$V"_f"$F"_C"$core".log"

