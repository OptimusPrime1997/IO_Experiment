#!/bin/bash
NAME=$1
IP=localhost
#d=`date +%Y%m%d%H%M%S`
LOG_DIR_PREFIX=/home/ljh/exp/logs/ycsb_redis/
CPU_LIST=( 1 2 4 8 )
LOADS=( a b c d e f )
#LOADS=( a )
redis_pid=`ps -ef|grep redis-server |grep -v grep | awk '{print $2}' | head -n 1`
MEM=`free -h  |grep Mem | awk '{print $2}' | awk -F 'G' '{print $1}'`
MEM=$((${MEM//.*/+1}))
#taskset -pc 0-$(($CPU-1)) ${redis_pid}
#set redis nice
renice -n -20 -p ${redis_pid}

THREADS=( 1 8 16 24 )
#THREADS=( 1 )
cd /home/ljh/projects/YCSB_redis
for C in ${CPU_LIST[@]};do
	taskset -pc 0-$(($C-1)) ${redis_pid}
	d=`date +%Y%m%d%H%M%S`
	LOG_DIR_PREFIX="/home/ljh/exp/logs/ycsb_redis/"${NAME}"/"$C"_"$MEM"/"
for T in ${THREADS[@]};do
	TF=$T
	while [ ${#TF} -ne 3  ];do
		TF=0$TF
	done
#	echo $TF
#	exit
	LOG_DIR=${LOG_DIR_PREFIX}${C}"_"${d}"_"${TF}
	if [ ! -d $LOG_DIR ];then
		mkdir -p $LOG_DIR
	fi
	for t in ${LOADS[@]};do
		/home/ljh/projects/YCSB_redis/bin/ycsb load redis  -P /home/ljh/projects/YCSB_redis/workloads/workload$t -p redis.host=$IP -threads $T 2>&1 > /dev/null
		taskset -c 8-12 nice -n -20 /home/ljh/projects/YCSB_redis/bin/ycsb load redis  -P /home/ljh/projects/YCSB_redis/workloads/workload$t -p redis.host=$IP -threads $T 2>&1 > $LOG_DIR"/"$d"_"$TF"_"$t".log"
#		/home/ljh/projects/YCSB_rocksdb/bin/ycsb run rocksdb -s -P /home/ljh/projects/YCSB_rocksdb/workloads/workload$t -p rocksdb.dir=$ROCKSDB_DIR -threads $T 2>&1  > $LOG_DIR"/"$d"_"$TF"_"$t".log"
	done
	cur_log=`grep -r Throughput $LOG_DIR | awk '{print $3}'| sed  ':a;N;s/\n/,/g;ta' `
	echo $LOG_DIR
	echo $cur_log
	echo -e $cur_log > $LOG_DIR"/all.csv"
	log_save=${log_save}${cur_log}"\n"
done
	echo -e $log_save 
	echo -e $log_save > $LOG_DIR_PREFIX"/total.csv"
done
cd -
