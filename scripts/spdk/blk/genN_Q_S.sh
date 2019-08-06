#!/bin/bash
N=$1
Q=$2
SMP=$3
i=1
while [ $i -le $N ];do
	sudo bash /home/ljh/exp/scripts/spdk/blk/gen_qemu_spdk13_02.sh  "0"$i $Q $SMP
	i=$(($i+1))
#	sleep 5 
done
