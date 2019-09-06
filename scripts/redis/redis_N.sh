#!/bin/bash
N=$1
i=0
while [ $i -lt $N ];do
	taskset -c $i nice -n -20 /usr/local/bin/redis-server  /home/ljh/exp/scripts/redis/redis63$((80+$i)).conf
	i=$(($i+1))
done
