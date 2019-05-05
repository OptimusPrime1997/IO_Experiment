#/bin/bash
#设置hug size 2G

#sudo /home/ljh/projects/spdk/scripts/rpc.py remove_vhost_blk_controller vhost.1 Malloc1
#sudo /home/ljh/projects/spdk/scripts/rpc.py remove_vhost_scsi_lun vhost.0 1 Malloc0
#sudo /home/ljh/projects/spdk/scripts/rpc.py remove_vhost_scsi_lun vhost.0 0 Nvme0n1
#sudo /home/ljh/projects/spdk/scripts/rpc.py remove_vhost_scsi_controller  vhost.0
#sudo /home/ljh/projects/spdk/scripts/rpc.py remove_malloc_bdev Malloc0
#sudo /home/ljh/projects/spdk/scripts/rpc.py remove_nvme_bdev  Nvme0 

sudo  /home/ljh/projects/spdk/scripts/setup.sh reset
sudo HUGEMEM=2048 /home/ljh/projects/spdk/scripts/setup.sh
sudo /home/ljh/projects/spdk/app/vhost/vhost -S /var/tmp -s 1024 -m 0x3 &
#sudo bash /home/ljh/script/spdk_script/pre_vhost.sh
sudo /home/ljh/projects/spdk/scripts/rpc.py construct_nvme_bdev -b Nvme0 -t pcie -a 0000:06:00.0
sudo /home/ljh/projects/spdk/scripts/rpc.py construct_malloc_bdev 128 4096 -b Malloc0
sudo /home/ljh/projects/spdk/scripts/rpc.py construct_vhost_scsi_controller --cpumask 0x1 vhost.0
sudo /home/ljh/projects/spdk/scripts/rpc.py add_vhost_scsi_lun vhost.0 0 Nvme0n1
sudo /home/ljh/projects/spdk/scripts/rpc.py add_vhost_scsi_lun vhost.0 1 Malloc0
sudo /home/ljh/projects/spdk/scripts/rpc.py construct_malloc_bdev 64 512 -b Malloc1
sudo /home/ljh/projects/spdk/scripts/rpc.py construct_vhost_blk_controller --cpumask 0x2 vhost.1 Malloc1

