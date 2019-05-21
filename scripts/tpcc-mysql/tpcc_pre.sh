#!/bin/bash
#prepare data
IP='127.0.0.1'
mysql -uroot -p123456 -h $IP -P13306 benchmarker < /home/ljh/projects/tpcc-mysql/create_table.sql
mysql -uroot -p123456 -h $IP -P13306 benchmarker < /home/ljh/projects/tpcc-mysql/add_fkey_idx.sql
sudo /home/ljh/projects/tpcc-mysql/tpcc_load -h $IP -P 13306 -dbenchmarker -uroot -p123456 -w11
