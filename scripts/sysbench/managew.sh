#!/bin/bash
DIR='/home/ljh/exp/scripts/sysbench/'

echo "start write only test"
#sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"write_clean.sh"
sudo bash $DIR"write_pre.sh"
sudo bash $DIR"write_run.sh"
sudo bash $DIR"write_clean.sh"


