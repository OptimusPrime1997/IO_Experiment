#!/bin/bash
#echo "start one case"
#sudo bash /home/ljh/exp/scripts/spdk/bridge/all_start.sh qemu_spdk1_4.sh 20190522_2_4/ 
#sleep 5
#sudo bash /home/ljh/exp/scripts/spdk/bridge/shutdown.sh

echo "start one case"
sudo bash /home/ljh/exp/scripts/spdk/bridge/all_start.sh qemu_spdk1_2.sh 20190522_2_2/ 
sleep 5
sudo bash /home/ljh/exp/scripts/spdk/bridge/shutdown.sh

echo "start one case"
sudo bash /home/ljh/exp/scripts/spdk/bridge/all_start.sh qemu_spdk1.sh 20190522_2_1/ 
sleep 5
sudo bash /home/ljh/exp/scripts/spdk/bridge/shutdown.sh

echo "start one case"
sudo bash /home/ljh/exp/scripts/spdk/bridge/all_start.sh qemu_spdk0_4.sh 20190523_1_4/ 
sleep 5
sudo bash /home/ljh/exp/scripts/spdk/bridge/shutdown.sh

echo "start one case"
sudo bash /home/ljh/exp/scripts/spdk/bridge/all_start.sh qemu_spdk0_2.sh 20190523_1_2/ 
sleep 5
sudo bash /home/ljh/exp/scripts/spdk/bridge/shutdown.sh

echo "start one case"
sudo bash /home/ljh/exp/scripts/spdk/bridge/all_start.sh qemu_spdk0.sh 20190523_1_1/ 
sleep 5
sudo bash /home/ljh/exp/scripts/spdk/bridge/shutdown.sh

