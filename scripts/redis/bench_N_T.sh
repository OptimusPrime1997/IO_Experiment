#!/bin/bash
N=$1
T=$2
i=1
while [ $i -le $N ];do
	taskset -c $((2+2*$i))-$((3+2*$i)) nice -n -20 /home/ljh/projects/redis-5.0.5/src/redis-benchmark  -r 1000000 -n 2000000 -c $T -t set  -s /tmp/redis$((6379+$i)).sock   --dbnum 0 -p $((6379+$i)) & 
	i=$(($i+1))
done
#sudo /home/ljh/projects/redis-5.0.5/src/redis-benchmark  -r 1000000 -n 2000000 -c 600 -t set   

