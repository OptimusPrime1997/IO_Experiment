#!/bin/bash
N=$1
T=$2
i=1
while [ $i -le $N ];do
#	sudo sysbench /usr/share/sysbench/oltp_write_only.lua  --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=3306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 --mysql-db=sbtest${i} --threads=40 prepare 
	i=$(($i+1))
done
i=1
cd /usr/share/sysbench/
while [ $i -le $N ];do
	echo "sudo sysbench /usr/share/sysbench/oltp_write_only.lua  --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=3306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 --mysql-db=sbtest${i} --threads=${T} run &"
	sudo sysbench /usr/share/sysbench/oltp_write_only.lua  --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=3306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 --mysql-db=sbtest${i} --threads=${T} run &
	i=$(($i+1))
done
cd -
#sudo sysbench /usr/share/sysbench/oltp_write_only.lua  --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=3306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 --threads=200 run

