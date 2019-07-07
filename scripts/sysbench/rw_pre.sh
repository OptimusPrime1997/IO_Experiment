#/bin/bash
IP='192.168.122.77'
PORT='3306'
sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=4 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=$PORT --tables=10 --table-size=1000000 --db-driver=mysql  prepare
