#!/bin/bash
#输入文件夹名
CPU=$1
MEM=$2

#echo "input dir:"$DIR
#exit
#echo "#execute sysbench"
#sudo bash /home/ljh/exp/scripts/sysbench/manageAll.sh $CPU $MEM

echo "#execute tpcc"
sudo bash /home/ljh/exp/scripts/tpcc-mysql/tpcc_execute.sh $CPU $MEM

