#!/bin/bash
DIR='/home/ljh/exp/scripts/sysbench/'

echo "start read only test"
sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"read_pre.sh"
sudo bash $DIR"read_run.sh"

