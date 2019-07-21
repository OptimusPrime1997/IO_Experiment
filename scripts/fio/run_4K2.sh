#!/bin/bash
R=$1
S=$2
Q=$4
N=$5
V=$6
T=$7

fio /home/ljh/exp/scripts/fio/$R > "/home/ljh/exp/logs/fio/4K2_s"$S"_q"$Q"_"$N"_v"$V"_"$T".log"

