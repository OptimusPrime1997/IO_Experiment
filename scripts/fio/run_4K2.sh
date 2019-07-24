#!/bin/bash
D=$1
R=$2
S=$3
Q=$4
N=$5
V=$6
T=$7

dir="/home/ljh/exp/logs/fio/"$D
if [ ! -d $dir ];then
	mkdir $dir
fi
fio /home/ljh/exp/scripts/fio/$R > "/home/ljh/exp/logs/fio/"$D"/4K2_s"$S"_q"$Q"_"$N"_v"$V"_"$T".log"

