#!/bin/bash
ROCKSDB_DIR=/opt/raid/db
d=`date +%Y%m%d%H%M%S`
LOG_DIR_PREFIX=/home/ljh/exp/logs/ycsb_rocksdb/

LOADS=( a b c d e f )
#LOADS=( a )

THREADS=( 1 8 16 24 )
#THREADS=( 1 )
cd /home/ljh/projects/YCSB_rocksdb
for T in ${THREADS[@]};do
	TF=$T
	while [ ${#TF} -ne 3  ];do
		TF=0$TF
	done
#	echo $TF
#	exit
	LOG_DIR=${LOG_DIR_PREFIX}${d}"_"${TF}
	if [ ! -d $LOG_DIR ];then
		mkdir -p $LOG_DIR
	fi
	for t in ${LOADS[@]};do
		/home/ljh/projects/YCSB_rocksdb/bin/ycsb run rocksdb -s -P /home/ljh/projects/YCSB_rocksdb/workloads/workload$t -p rocksdb.dir=$ROCKSDB_DIR -threads $T 2>&1  > $LOG_DIR"/"$d"_"$TF"_"$t".log"
	done
	grep -r Throughput $LOG_DIR | awk '{print $3}' 2>&1 > $LOG_DIR"/all.csv"
done
cd -
