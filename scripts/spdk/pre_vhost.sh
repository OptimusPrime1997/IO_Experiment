#!/bin/bash
sudo  /home/ljh/projects/spdk/scripts/setup.sh reset
sudo HUGEMEM=2048 /home/ljh/projects/spdk/scripts/setup.sh
sudo /home/ljh/projects/spdk/app/vhost/vhost -S /var/tmp -s 1024 -m 0x3 &
