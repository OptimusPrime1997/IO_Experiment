#!/bin/bash
#NUM one of [1 2 4 8]
NUM=$1
echo "sudo bash /home/ljh/exp/scripts/spdk/0"$NUM"pre_vhost.sh"
sudo bash "/home/ljh/exp/scripts/spdk/0"$NUM"pre_vhost.sh"
echo "sleep 10s for vhost to start"
sleep 10
i=1
while [ $i -le $NUM ];do
	echo "sudo bash /home/ljh/exp/scripts/spdk/blk/gen_qemu_spdk02_02.sh 0"$i
	sudo bash /home/ljh/exp/scripts/spdk/blk/gen_qemu_spdk02_02.sh 0$i
	i=$(($i+1))
done
