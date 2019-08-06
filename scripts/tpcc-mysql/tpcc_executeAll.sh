#!/bin/bash
sudo bash /etc/init.d/sdb-init.sh
num=( 1 2 4 8 )
i=1
for t in ${num[@]} ; do
	sudo bash /home/ljh/exp/scripts/tpcc-mysql/tpcc_execute_C.sh $t
done
sudo rsync -au /home/ljh/exp/logs/tpcc-mysql/ root@192.168.122.77:/home/ljh/exp/logs/tpcc-mysql/
