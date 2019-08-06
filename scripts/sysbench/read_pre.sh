#/bin/bash
IP=$1
PORT='3306'
#sudo sysbench /usr/share/sysbench/oltp_read_only.lua --threads=4 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=$PORT --tables=10 --table-size=1000000 --db-driver=mysql  prepare

sudo sysbench --db-driver=mysql --mysql-user=root \
 --mysql-password=123456 --mysql-socket=mysql.sock --mysql-db=sbtest --range_size=100 \
 --table_size=1000000 --tables=10 --threads=1 --events=0 --time=60 \
  --rand-type=uniform /usr/share/sysbench/oltp_read_only.lua prepare
