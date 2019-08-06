#!/bin/bash
cd /home/ljh/projects/nvme-mdev-redhat/
sudo make -j 50 && make modules_install -j 50
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-5.0.0+
sudo chmod a+x /boot/vmlinuz-5.0.0+
sudo update-initramfs -u -k 5.0.0+
sudo update-grub -o /boot/grub/grub.cfg

