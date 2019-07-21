#!/bin/bash
N=4
i=1
while [ $i -le $N ];do
	sudo bash /home/ljh/exp/scripts/spdk/bridge/gen_qemu_spdk13_02.sh  "0"$i 4 13
	i=$(($i+1))
done
