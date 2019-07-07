#/bin/bash
CPU=$1
MEM=$2
IP='192.168.122.77'
PORT=3306
d=`date +%Y%m%d%H%M%S`
date=`date +%Y%m%d`
op='rw'
ts=(1 2 4 8 16 32 64)
#ts=(32 64)
num=('01' '02' '04' '08' '16' '32' '64')
i=0
dir="/home/ljh/exp/logs/tpcc-mysql/"${CPU}"_"${MEM}"_"${date}"/"
echo $dir
#exit
if [ ! -d $dir ];then
        sudo mkdir -p $dir
fi
op='rw'
i=0
for data in ${ts[@]}
do
	echo $data
	sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=$data --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=$PORT --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > $dir"thread_"${op}${num[$i]}"_"$d".log"
	i=$[i+1]
done
