#!/bin/bash
echo "start qemu"
script=$1
dir=$2

sudo bash /home/ljh/exp/scripts/spdk/bridge/$script

sleep 60
echo "execute test"
sudo bash /home/ljh/exp/scripts/run_all.sh $dir
