#!/bin/bash
#start NUM VMs
NUM=$1
QUEUE=$2

#remove nvme module at first
#rmmod nvme
#load nvme-mdev module
modprobe nvme-mdev
#allocate hw queue
modprobe nvme mdev_queues=36

#to remove other devices
for dir in $(ls /sys/bus/mdev/devices/)
do
        echo 1 > /sys/bus/mdev/devices/$dir/remove
done

PCI_DEVICE_1=/sys/bus/pci/devices/0000\:06\:00.0
i=1
while [ $i -le $NUM ];do

	UUID=$(uuidgen)
	MDEV_DEVICE_1=/sys/bus/mdev/devices/${UUID}

	#ls ${PCI_DEVICE_1}/mdev_supported_types/nvme-1Q_V1/
#	if [ $QUEUE -eq 8 ];then
#		QUEUE=2
#	fi
	echo ${UUID} > ${PCI_DEVICE_1}/mdev_supported_types/nvme-${QUEUE}Q_V1/create
	echo "uuid:"${MDEV_DEVICE_1}
	p=$i
	if [ $p -ge 4 ];then
		p=$(($p+1))
	fi
	if [ $NUM -le 1 ];then
		echo n1 > ${MDEV_DEVICE_1}/namespaces/add_namespace
	else
		echo n1p${p} > ${MDEV_DEVICE_1}/namespaces/add_namespace
	fi
#cpu number start from 0
	echo $(($i*2-2)) > ${MDEV_DEVICE_1}/settings/iothread_cpu
	
	N=$i
	while [ ${#N} -lt 2 ];do
		N=0${N}
	done
	MAC="52:54:00:12:34:"$N

	/usr/local/bin/qemu-system-x86_64 \
	    -m 4G \
	    -smp 13 \
	    -M pc \
	    -name mdev-${N} \
	    -cpu host -enable-kvm -machine kernel_irqchip=on \
	    -hda "/home/ljh/image/"$N"ubuntu-server18.04.qcow2" \
	    -vnc :2$N \
  	    -net nic,model=vmxnet3,macaddr=$MAC,vectors=0 -net tap,ifname=tap$N,script=/etc/qemu-ifup-nat,downscript=/etc/qemu-ifdown-nat \
	    -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/${UUID} \
	    -name "vm2"${N} &	    
	i=$(($i+1))
done

#/usr/local/bin/qemu-system-x86_64 \
#    -m 2G \
#    -smp 12 \
#    -M pc \
#    -name mdev-${i} \
#    -cpu host -enable-kvm -machine kernel_irqchip=on \
#    -hda test.qcow2 \
#    -vnc :10${i}  \
#    -serial pty \
#    -monitor stdio  \
#    -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22 \
#    -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/${UUID}
