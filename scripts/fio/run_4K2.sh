#!/bin/bash
S=$1
C=$2
Q=$3
N=$4

fio /home/ljh/exp/scripts/fio/4K2.fio > "/home/ljh/exp/logs/fio/4K2_s"$S"_c"$C"_q"$Q"_"$N".log"

