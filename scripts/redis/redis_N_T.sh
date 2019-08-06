#!/bin/bash
N=$1
T=$2
i=1
while [ $i -le $N ];do
	sudo /home/ljh/projects/redis-5.0.5/src/redis-benchmark  -r 1000000 -n 2000000 -c $T -t set  --dbnum ${i} & 
	i=$(($i+1))
done
#sudo /home/ljh/projects/redis-5.0.5/src/redis-benchmark  -r 1000000 -n 2000000 -c 600 -t set   

