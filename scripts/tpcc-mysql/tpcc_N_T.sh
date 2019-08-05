#!/bin/bash
N=$1
T=$2
i=1
WARMUP=22
TIME=60
while [ $i -le $N ];do
	sudo  /home/ljh/projects/tpcc-mysql/tpcc_start -h 127.0.0.1 -P 3306 -dbenchmarker${i} -uroot -p123456 -w11  -r ${WARMUP} -l ${TIME} -i10 -c${T} &
	i=$(($i+1))
done
sleep ${WARMUP}
iostat -m -x -c ${TIME} 1
#sudo  /home/ljh/projects/tpcc-mysql/tpcc_start -h 127.0.0.1 -P 3306 -dbenchmarker -uroot -p123456 -w11 -c256 -r22 -l60 -i10
