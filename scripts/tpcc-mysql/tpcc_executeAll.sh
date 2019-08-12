#!/bin/bash
#sudo bash /etc/init.d/sdb-init.sh
num=( 1 2 4 8 )
num=( 16 32 )
num=( 1  )
i=1
for t in ${num[@]} ; do
	sudo bash /home/ljh/exp/scripts/tpcc-mysql/tpcc_execute_C.sh $t
done
sudo rsync -au /home/ljh/exp/logs/tpcc-mysql/ root@10.0.1.105:/home/ljh/exp/logs/tpcc-mysql/
