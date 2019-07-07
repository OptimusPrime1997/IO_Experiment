#!/bin/bash
#输入文件夹名
CPU=$1
MEM=$2
IP=$3
if [ ${#CPU} -ne 2 ];then
        CPUFormat="0"$CPU
else 
	CPUFormat=$CPU
fi
if [ ${#MEM} -ne 2 ];then
        MEMFormat="0"$MEM
else
	MEMFormat=$MEM
fi
qemu_script="/home/ljh/exp/scripts/spdk/bridge/qemu_spdk"$CPUFormat"_"$MEMFormat".sh"
echo "bash "$qemu_script
#exit
sudo bash $qemu_script
echo "qemu vm starting..."
sleep 40
echo "qemu started; run test"
#echo "input dir:"$DIR
#exit
#echo "#execute sysbench"
#sudo bash /home/ljh/exp/scripts/sysbench/manageAll.sh $CPU $MEM

echo "#execute tpcc"
sudo bash /home/ljh/exp/scripts/tpcc-mysql/tpcc_execute.sh $CPU $MEM $IP

