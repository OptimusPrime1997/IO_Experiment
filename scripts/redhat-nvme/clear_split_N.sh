#!/bin/bash
sudo bash /home/ljh/exp/scripts/redhat-nvme/remove_mdev_device.sh
N=$1
str=''
i=1
while [ $i -lt $N ];do
	str=${str}'d\n\n'
	i=$(($i+1))
done
str=${str}'d\n'
str=${str}'w\n'
echo -e $str
echo -e $str | sudo fdisk /dev/nvme0n1
