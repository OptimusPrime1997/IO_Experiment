#!/bin/bash
N=3
sudo  /home/ljh/projects/spdk/scripts/setup.sh reset
sudo HUGEMEM=$((1024*4*$N)) /home/ljh/projects/spdk/scripts/setup.sh
sudo /home/ljh/projects/spdk/app/vhost/vhost -S /var/ljh/mem -r /var/ljh/sock/vhost0"$N".sock -s $((1024*$N))  -m 0x15 -c /home/ljh/projects/spdk/etc/spdk/vhost.conf.0"$N".in_blk &
#sudo /home/ljh/projects/spdk/app/vhost/vhost -S /var/ljh/mem -r /var/ljh/sock/vhost0.sock -s 1024 -m 0x8  &
#sleep 10
#sudo /home/ljh/projects/spdk/scripts/rpc.py construct_nvme_bdev -b Nvme0 -t pcie -a 0000:06:00.0
#sudo /home/ljh/projects/spdk/scripts/rpc.py construct_malloc_bdev 128 4096 -b Malloc0
#sudo /home/ljh/projects/spdk/scripts/rpc.py construct_vhost_scsi_controller --cpumask 0x8 vhost.0
#sudo /home/ljh/projects/spdk/scripts/rpc.py add_vhost_scsi_lun vhost.0 0 Nvme0n1

