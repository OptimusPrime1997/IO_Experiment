#!/bin/bash

#remove nvme module at first
#rmmod nvme
#load nvme-mdev module
modprobe nvme-mdev
#allocate hw queue
modprobe nvme mdev_queues=4

UUID=$(uuidgen)
MDEV_DEVICE_1=/sys/bus/mdev/devices/${UUID}
PCI_DEVICE_1=/sys/bus/pci/devices/0000\:06\:00.0

#ls ${PCI_DEVICE_1}/mdev_supported_types/nvme-1Q_V1/
echo ${UUID} > ${PCI_DEVICE_1}/mdev_supported_types/nvme-1Q_V1/create

echo n1 > ${MDEV_DEVICE_1}/namespaces/add_namespace

echo 11 > ${MDEV_DEVICE_1}/settings/iothread_cpu

/usr/local/bin/qemu-system-x86_64 \
    -m 16384 -smp 12 -M pc -name nvme-mdev-guest-0 -cpu host -enable-kvm -machine kernel_irqchip=on \
    -hda test.qcow2 \
    -cdrom ubuntu-18.04.2-live-server-amd64.iso \
    -vnc :1  -serial pty -monitor stdio  \
    -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22 \
    -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/${UUID}
