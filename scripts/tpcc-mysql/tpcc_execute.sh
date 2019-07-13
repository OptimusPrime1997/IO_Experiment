#!/bin/bash
#excute
CPU=$1
MEM=$2
IP=$3
PORT=3306
d=`date +%Y%m%d%H%M%S`
date=`date +%Y%m%d%H%M`
IPTEMP=`expr substr $IP 13 2`
date=$date"_"$IPTEMP
op='rw'
ts=(1 2 4 8 16 32 64)
ts=( 16 32 64 128)
#ts=(32 64) 
num=('01' '02' '04' '08' '16' '32' '64')
num=('016' '032' '064' '128' )
i=0
if [ ${#CPU} -ne 2 ];then
	CPUFormat="0"$CPU
else
	CPUFormat=$CPU
fi
if [ ${#MEM} -ne 2 ];then
	MEMFormat="0"$MEM
else
	MEMFormat=$MEM
fi
dir="/home/ljh/exp/logs/tpcc-mysql/"${CPUFormat}"_"${MEMFormat}"_"${date}"/"
echo $dir
#exit
if [ ! -d $dir ];then
	sudo mkdir -p $dir
fi
for data in ${ts[@]}
do
        echo $data
#	sudo bash /home/ljh/exp/scripts/tpcc-mysql/restart.sh > /dev/null 2>&1 
	sudo taskset -c 24-31 /home/ljh/projects/tpcc-mysql/tpcc_start -h $IP -P $PORT -dbenchmarker -uroot -p123456 -w11 -c${data} -r22 -l60 -i10 > $dir"tpcc_"${num[$i]}_$d".log"   2>&1
        #sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=$data --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=13306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > /var/log/sysbench/thread_${op}${data}_$d.log
	i=$[i+1]
done

sudo bash /home/ljh/exp/scripts/tpcc-mysql/handle_data.sh $dir

