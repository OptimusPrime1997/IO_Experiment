#!/bin/bash
DIR='/home/ljh/exp/scripts/sysbench/'

echo "start read write test"
#sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"rw_clean.sh"
sudo bash $DIR"rw_pre.sh"
sudo bash $DIR"rw_run.sh"
sudo bash $DIR"rw_clean.sh"

echo "start write only test"
sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"write_clean.sh"
sudo bash $DIR"write_pre.sh"
sudo bash $DIR"write_run.sh"
sudo bash $DIR"write_clean.sh"


echo "start read only test"
sudo /usr/bin/expect /home/ljh/exp/scripts/tpcc-mysql/restart.sh
sudo bash $DIR"read_pre.sh"
sudo bash $DIR"read_run.sh"

