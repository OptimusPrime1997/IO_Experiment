#!/bin/bash
R=$1
S=$2
Q=$3
N=$4
V=$5
T=$6

fio /home/ljh/exp/scripts/fio/$R > "/home/ljh/exp/logs/fio/4K2_s"$S"_q"$Q"_"$N"_v"$V"_"$T".log"

