#/bin/bash
taskset -c 11,13,15,17 qemu-system-x86_64 \
  --enable-kvm \
  -cpu host \
  -smp 4 \
  -m 2G \
  -object memory-backend-file,id=mem0,size=2G,mem-path=/dev/hugepages,share=on \
  -numa node,memdev=mem0 \
  -hda /home/ljh/image/ubuntu-server18.04.qcow2 \
  -chardev socket,id=spdk_vhost_blk0,path=/var/ljh/mem/vhost.10 \
  -device vhost-user-blk-pci,id=blk0,chardev=spdk_vhost_blk0,num-queues=4 \
  -vnc :0 \
  -net nic,model=vmxnet3,name=nic0204,vectors=0 -net tap,ifname=tap1,script=/etc/qemu-ifup-nat,downscript=/etc/qemu-ifdown-nat \
  -name vm0 &


#  taskset -c 2,3 qemu-system-x86_64 \
# --enable-kvm \
#  -cpu host \
#  -smp 2 \
#  -m 1G \
#  -object memory-backend-file,id=mem0,size=1G,mem-path=/dev/hugepages,share=on \
#  -numa node,memdev=mem0 \
#  -drive file=/home/ljh/image/ubuntu-server18.04.qcow2,if=none,id=disk \
#  -cdrom /home/ljh/image/ubuntu-18.04.2-live-server-amd64.iso \
#  -device ide-hd,drive=disk,bootindex=0 \
  #vhost-blk
#  -chardev socket,id=spdk_vhost_blk0,path=/var/tmp/vhost.0 \
#  -device vhost-user-blk-pci,id=blk0,chardev=spdk_vhost_blk0,num-queues=4 \
  #vhost-blk
#  -chardev socket,id=spdk_vhost_blk0,path=/var/tmp/vhost.1 \
#  -device vhost-user-blk-pci,chardev=spdk_vhost_blk0,num-queues=4 \
  #vhost-NVMe(experimental)
  #-chardev socket,id=spdk_vhost_nvme0,path=/var/tmp/vhost.2 \
  #-device vhost-user-nvme,id=nvme0,chardev=spdk_vhost_nvme0,num_io_queues=4 \

#  -vnc :0 \
#  -net nic -net user,tftp=/root/tftp,hostfwd=tcp::5022-:22 \
#  -name vm0 &

