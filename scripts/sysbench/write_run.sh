#/bin/bash
d=`date +%Y%m%d%H%M%S`
IP='10.0.1.105'
op='w'
ts=(1 2 4)
ts=(12)
for data in ${ts[@]}
do
	echo $data
	sudo sysbench /usr/share/sysbench/oltp_write_only.lua --threads=$data --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=13306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10 --thread-init-timeout=120 --debug=on --db-debug=on  run  > /home/ljh/exp/logs/sysbench/thread_${op}${data}_$d.log
done
#--thread-init-timeouti
#--debug=on --db-debug=on
