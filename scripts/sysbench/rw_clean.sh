#/bin/bash
IP='192.168.122.77'
PORT='3306'

sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=4 --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=$PORT  --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 cleanup

#sudo sync
#sudo echo 3 > /proc/sys/vm/drop_caches
#sudo swapoff -a
#sudo swapon -a
