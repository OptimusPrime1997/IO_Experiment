#!/bin/bash
#excute
CPU=$1
ALL=`cat /proc/cpuinfo |grep processor | awk '{print $3}' | tail -n 1`
ALL=12
MEM=`free -h  |grep Mem | awk '{print $2}' | awk -F 'G' '{print $1}'`
MEM=$((${MEM//.*/+1}))
echo "MEM="$MEM
IP=`ifconfig  |grep inet |grep -v inet6 | awk '{print $2}' |head -n 1`
PORT=3306
#set cpu constriction
cockroach_pid=`ps -ef|grep cockroach |grep -v grep | awk '{print $2}' | head -n 1`
if [ -z $cockroach_pid ];then
	echo "cockroach not start,start it"
	nohup /home/ljh/projects/cockroach-v19.1.4/cockroach start --insecure --listen-addr=localhost:26257 --store=/opt/cockroach/node26257 &
	cockroach_pid=`ps -ef|grep cockroach |grep -v grep | awk '{print $2}' | head -n 1`
fi
if [ -z "$cockroach_pid" ];then
	echo "start cockroach database failed"
	exit
fi
echo "cockroach_pid="$cockroach_pid
#exit
taskset -pc 0-$(($CPU-1)) ${cockroach_pid}
#set cockroach nice
renice -n -20 -p ${cockroach_pid}

d=`date +%Y%m%d%H%M%S`
date=`date +%Y%m%d%H%M`
start=$((${#IP}-1))
IPTEMP=`expr substr $IP $start 2`
date=$date"_"$IPTEMP
op='rw'
ts=(1 2 4 8 16 32 64)
ts=(4 8 16 32 64 128)
ts=( 100 200 300 )
#ts=( 24 )

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
dir="/home/ljh/exp/logs/tpcc_crd/"${CPUFormat}"_"${MEMFormat}"_"${date}"/"
echo $dir
#exit
if [ ! -d $dir ];then
	sudo mkdir -p $dir
fi
for data in ${ts[@]}
do
	#num=$data
	#while [ ${#num} -le 3 ];do
	#	num=0${num}
	#done
        echo $data
	#sudo bash /home/ljh/exp/scripts/tpcc_crd/restart.sh > /dev/null 2>&1 
	sudo nice -n -20 taskset -c ${CPU}-$(($CPU+4))   /home/ljh/projects/cockroach-v19.1.4/cockroach workload run tpcc  'postgresql://root@localhost:26257?sslmode=disable'  --db=tpcc_crd   --warehouses=10 --workers=100  --duration=1m --wait=false --ramp=10s --conns=$data --concurrency=$data > $dir"crd_"${data}_$d".log" 2>&1
	# /home/ljh/projects/tpcc_crd/tpcc_start -h $IP -P $PORT -dbenchmarker -uroot -p123456 -w11 -c${data} -r22 -l60 -i10 > $dir"tpcc_"${num}_$d".log"   2>&1
	#sudo nice -n -20 taskset -c ${CPU}-${ALL}  /home/ljh/projects/tpcc_crd/tpcc_start -h $IP -P $PORT -dbenchmarker -uroot -p123456 -w11 -c${data} -r22 -l60 -i10 > $dir"tpcc_"${num}_$d".log"   2>&1
        #sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=$data --events=0 --time=60 --cockroach-host=127.0.0.1 --cockroach-user=root --cockroach-password=123456 --cockroach-port=13306 --db-driver=cockroach --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > /var/log/sysbench/thread_${op}${data}_$d.log
	i=$[i+1]
done

sudo bash /home/ljh/exp/scripts/tpcc_crd/handle_data.sh $dir
res=`cat $dir"/"allStr.csv`
if [ ! -z "$res" ];then
	sudo rsync -au /home/ljh/exp/logs/tpcc_crd/ root@10.0.1.105:/home/ljh/exp/logs/tpcc_crd/
fi
