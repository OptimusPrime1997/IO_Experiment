#!/bin/bash
dir=$1
files=`ls -l $dir|grep log |awk '{print $9}'`
allStr=''
allTpmc=''
for data in ${files[@]}
do
	echo $data
	tpmc=`grep -A 1 "tpmC" $dir"/"$data  | tail -n 1 | awk '{print $2","$4}'`
	echo $tpmc
	allTpmc=${allTpmc}${tpmc}"\n"
done
echo -e ${allTpmc}
echo -e ${allTpmc} > $dir"/allStr.csv"

