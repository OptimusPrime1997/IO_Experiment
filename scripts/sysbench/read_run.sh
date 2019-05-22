#/bin/bash
d=`date +%Y%m%d%H%M%S`
op='r'
ts=(1 2 4 8 16)
#ts=(4)
for data in ${ts[@]}
do
	echo $data
	#sudo bash /home/ljh/exp/scripts/tpcc-mysql/restart.sh
	sudo sysbench /usr/share/sysbench/oltp_read_only.lua --threads=$data --events=0 --time=60 --mysql-host=127.0.0.1 --mysql-user=root --mysql-password=123456 --mysql-port=13306 --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10   run  > /home/ljh/exp/logs/sysbench/thread_$op_${data}_$d.log
done
