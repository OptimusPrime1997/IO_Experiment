#/bin/bash
sudo sysbench /usr/share/sysbench/oltp_read_only.lua --threads=4 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=13306 --tables=10 --table-size=1000000 --db-driver=mysql  prepare
