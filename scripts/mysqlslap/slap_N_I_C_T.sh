#!/bin/bash
N=$1
INT=$2
CHAR=$3
CLIENT=$4
IP=127.0.0.1
PW=123456
USER=root
RW=write
i=1
while [ $i -le $N ];do
	sudo mysqlslap -h $IP -p$PW -u $USER   --iterations=10 --auto-generate-sql --create-schema=mysqlslap${i} --auto-generate-sql-load-type=${RW} --auto-generate-sql-add-autoincrement --number-char-cols=$CHAR --number-int-cols=$INT --engine=innodb --number-of-queries=500000 --concurrency=${CLIENT} &
	i=$(($i+1))
done
#sudo mysqlslap -h 127.0.0.1 -p123456 -uroot   --iterations=10 --auto-generate-sql --create-schema=mysqlslap3 --auto-generate-sql-load-type=write --auto-generate-sql-add-autoincrement --number-char-cols=1 --number-int-cols=1 --engine=innodb --number-of-queries=500000 --concurrency=4
