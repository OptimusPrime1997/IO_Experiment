#!/bin/bash
DIR='/home/ljh/exp/scripts/sysbench/'

CPU=$1
MEM=$2
date=`date +%Y%m%d`
dir="/home/ljh/exp/logs/sysbench/"${date}"_"${CPU}"_"${MEM}"/"

echo "start read write test"
#sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"rw_clean.sh"
sudo bash $DIR"rw_pre.sh"
sudo bash $DIR"rw_run.sh" $CPU $MEM
sudo bash $DIR"rw_clean.sh"

echo "start write only test"
#sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"write_clean.sh"
sudo bash $DIR"write_pre.sh"
sudo bash $DIR"write_run.sh" $CPU $MEM
sudo bash $DIR"write_clean.sh"


echo "start read only test"
#sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"read_pre.sh"
sudo bash $DIR"read_run.sh" $CPU $MEM

sudo bash $DIR"handle_data.sh" $dir
