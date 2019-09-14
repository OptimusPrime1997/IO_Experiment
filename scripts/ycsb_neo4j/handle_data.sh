#!/bin/bash
dir=$1
files=`ls -l $dir|grep log |awk '{print $9}'`
allStr=''
allOps=''
for data in ${files[@]}
do
	echo $data
	#ops=`grep -A 1 "tpmC" $dir"/"$data  | tail -n 1 | awk '{print $2","$4}'`
	ops=`cat $dir"/"$data | grep 'Throughput(ops/sec)' | awk -F ',' '{print $3}'`
	ops=`echo "scale=3;$ops/1" | bc `
	echo $ops
	allOps=${allOps}${ops}"\n"
done
echo -e "\n"${allOps}
echo -e ${allOps} > $dir"/allStr.csv"

