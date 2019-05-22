#!/bin/bash
#excute
IP='127.0.0.1'
d=`date +%Y%m%d%H%M%S`
op='rw'
ts=(1 2 4 8 16)
#ts=(16)
for data in ${ts[@]}
do
        echo $data
	sudo bash /home/ljh/exp/scripts/tpcc-mysql/restart.sh > /dev/null 2>&1
	sudo /home/ljh/projects/tpcc-mysql/tpcc_start -h $IP -P 13306 -dbenchmarker -uroot -p123456 -w11 -c${data} -r22 -l60 -i10 > /home/ljh/exp/logs/tpcc-mysql/tpcc_${data}_${d}.log 2>&1
        #sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=$data --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=13306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > /var/log/sysbench/thread_${op}${data}_$d.log
done

