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
neo4j_pid=`ps -ef|grep neo4j |grep -v grep | awk '{print $2}' | head -n 1`
if [ -z $neo4j_pid ];then
	echo "neo4j not start,start it"
	#nohup /home/ljh/projects/neo4j-v19.1.4/neo4j start --insecure --listen-addr=localhost:26257 --store=/opt/neo4j/node26257 &
	nohup /opt/neo4j-enterprise-3.5.9/bin/neo4j start & 
	neo4j_pid=`ps -ef|grep neo4j |grep -v grep | awk '{print $2}' | head -n 1`
fi
if [ -z "$neo4j_pid" ];then
	echo "start neo4j database failed"
	exit
fi
echo "neo4j_pid="$neo4j_pid
#exit
taskset -pc 0-$(($CPU-1)) ${neo4j_pid}
#set neo4j nice
renice -n -20 -p ${neo4j_pid}

d=`date +%Y%m%d%H%M%S`
date=`date +%Y%m%d%H%M`
start=$((${#IP}-1))
IPTEMP=`expr substr $IP $start 2`
date=$date"_"$IPTEMP
op='rw'
ts=(1 2 4 8 16 32 64)
ts=(4 8 16 32 64 128)
ts=(1 2 4 8 ) 
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
dir="/home/ljh/exp/logs/ycsb_neo4j/"${CPUFormat}"_"${MEMFormat}"_"${date}"/"
echo $dir
#exit
if [ ! -d $dir ];then
	sudo mkdir -p $dir
fi
for data in ${ts[@]}
do
	num=$data
	while [ ${#num} -le 3 ];do
		num=0${num}
	done
        echo $data
	#sudo bash /home/ljh/exp/scripts/tpcc_crd/restart.sh > /dev/null 2>&1 
	sudo nice -n -20 taskset -c ${CPU}-$(($CPU+4))  /home/ljh/projects/ycsb-0.12.0/bin/ycsb.sh run basic -P /home/ljh/projects/ycsb-0.12.0/workloads/workloada -p operationcount=10000 -p db.batchsize=100 -p recordcount=10000 -threads $data > $dir"neo4j_"${num}_$d".log" 2>&1 
# /home/ljh/projects/neo4j-v19.1.4/neo4j workload run tpcc  'postgresql://root@localhost:26257?sslmode=disable'  --db=tpcc_crd   --warehouses=10 --workers=100  --duration=1m --wait=false --ramp=10s --conns=$data --concurrency=$data > $dir"crd_"${data}_$d".log" 2>&1
	#exit
	i=$[i+1]
done
#exit
sudo bash /home/ljh/exp/scripts/ycsb_neo4j/handle_data.sh $dir
res=`cat $dir"/"allStr.csv`
if [ ! -z "$res" ];then
	sudo rsync -au /home/ljh/exp/logs/ycsb_neo4j/ root@10.0.1.105:/home/ljh/exp/logs/ycsb_neo4j/
fi
