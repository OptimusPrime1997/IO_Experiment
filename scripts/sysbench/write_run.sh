#/bin/bash
CPU=$1
MEM=$2
IP=$3
PORT=3306
d=`date +%Y%m%d%H%M%S`
date=`date +%Y%m%d%H%M`
op='rw'
ts=(1 2 4 8 16 32 64)
ts=(4 8 16 32 64 128 256 512 )
#ts=(32 64)
#num=('01' '02' '04' '08' '16' '32' '64')
#num=('004' '008' '016' '032' '064' '128' '256' '512' )
i=0
op='w'
dir="/home/ljh/exp/logs/sysbench/"${CPU}"_"${MEM}"_"${date}"_"$op
echo $dir
#exit
if [ ! -d $dir ];then
        sudo mkdir -p $dir
fi
i=0
for data in ${ts[@]}
do
	echo $data
        dataFormat=$data
        while [ ${#dataFormat} -lt 3  ];do
                dataFormat="0"$dataFormat
        done
	sudo sysbench /usr/share/sysbench/oltp_write_only.lua --threads=$data --events=0 --time=60 --mysql-host=$IP --mysql-user=root --mysql-password=123456 --mysql-port=$PORT --db-driver=mysql --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=10  run  > $dir"/thread_"${op}${dataFormat}"_"$d".log"
	i=$[i+1]
done

sudo bash /home/ljh/exp/scripts/sysbench/handle_data.sh $dir
