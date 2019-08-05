#!/bin/bash

#remove nvme module at first
rmmod nvme
#load nvme-mdev module
modprobe nvme-mdev
#allocate hw queue
modprobe nvme mdev_queues=4

UUID=$(uuidgen)
MDEV_DEVICE_1=/sys/bus/mdev/devices/${UUID}
PCI_DEVICE_1=/sys/bus/pci/devices/0000\:06\:00.0

ls ${PCI_DEVICE_1}/mdev_supported_types/nvme-1Q_V1/
echo ${UUID} > ${PCI_DEVICE_1}/mdev_supported_types/nvme-1Q_V1/create

echo n1 > ${MDEV_DEVICE_1}/namespaces/add_namespace

echo 11 > ${MDEV_DEVICE_1}/settings/iothread_cpu

/usr/local/bin/qemu-system-x86_64 \
    -m 4096 -smp 4 -M pc -name nvme-mdev-guest-0 -cpu host -enable-kvm -machine kernel_irqchip=on \
    -hda test.qcow2 \
    -vnc :1  -serial pty -monitor stdio  \
    -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/${UUID}
