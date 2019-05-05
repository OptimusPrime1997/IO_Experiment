#!/bin/bash
#prepare data
mysql -uroot -p123456 -h 10.0.3.190 -P 13306 benchmarker < /home/ljh/projects/tpcc-mysql/create_table.sql
mysql -uroot -p123456 -h 10.0.3.190 -P 13306 benchmarker < /home/ljh/projects/tpcc-mysql/add_fkey_idx.sql
sudo /home/ljh/projects/tpcc-mysql/tpcc_load -h 10.0.3.190 -P 13306 -d benchmarker -uroot -p123456 -w11
