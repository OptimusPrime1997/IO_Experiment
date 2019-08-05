#!/bin/bash
#tpcc
sudo bash /home/ljh/exp/scripts/tpcc-mysql/tpcc_N_T.sh 4 40
#sysbench
sudo bash /home/ljh/exp/scripts/sysbench/sysbench_N_T.sh 8 15
#mysqlslap
sudo bash /home/ljh/exp/scripts/mysqlslap/slap_N_I_C_T.sh 8 29 194 10
