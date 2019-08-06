#!/bin/bash
num=( 1 2 4 8 )
i=1
for t in ${num[@]} ; do
	sudo bash /home/ljh/exp/scripts/tpcc-mysql/tpcc_execute_C.sh $t
done
