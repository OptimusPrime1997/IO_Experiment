#!/bin/bash
# NUM one of [1 2 4 8]
NUM=$1
PRE=192.168.122.
BASE=75
CPU=2
MEM=2


i=1
while [ $i -le $NUM ];do
	IP=$PRE$(($BASE+$i*2))
	echo 'sudo bash /home/ljh/exp/scripts/run_tpcc_qemu.sh '$CPU' '$MEM' '$IP'  > /dev/null &'
	sudo bash /home/ljh/exp/scripts/run_tpcc_qemu.sh $CPU $MEM $IP  > /dev/null &
	i=$(($i+1))
done

