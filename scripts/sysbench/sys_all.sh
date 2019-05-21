#/bin/bash
IP='127.0.0.1'
ts=(1 2 4 8 16)
DIR='/home/ljh/exp/logs/sysbench/'
for data in ${ts[@]}
do
        echo $op$data
done
#exit
#read_only
sudo sysbench /usr/share/sysbench/oltp_read_only.lua --threads=4 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306 --tables=10 --table-size=1000000 --db-driver=mysql  prepare

sleep 3
d=`date +%Y%m%d%H%M%S`
op='r'
for data in ${ts[@]}
do
        echo $op$data
        sudo sysbench /usr/share/sysbench/oltp_read_only.lua --threads=$data --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > "$DIR"thread_$op${data}_$d.log
done

#read_write
sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=4 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306 --tables=10 --table-size=1000000 --db-driver=mysql  prepare
sleep 3
d=`date +%Y%m%d%H%M%S`
op='rw'
#ts=$TS
for data in ${ts[@]}
do
        echo $op$data
        sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=$data --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > "$DIR"thread_$op${data}_$d.log
done

sudo sysbench /usr/share/sysbench/oltp_read_write.lua --threads=4 --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306  --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 cleanup

#write_only
sudo sysbench /usr/share/sysbench/oltp_write_only.lua --threads=4 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306 --tables=10 --table-size=1000000 --db-driver=mysql  prepare
sleep 3
d=`date +%Y%m%d%H%M%S`
op='w'
#ts=$TS
for data in ${ts[@]}
do
        echo $op$data
        sudo sysbench /usr/share/sysbench/oltp_write_only.lua --threads=$data --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > "$DIR"thread_$op${data}_$d.log
done

sudo sysbench /usr/share/sysbench/oltp_write_only.lua --threads=4 --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306  --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 cleanup
