#!/bin/bash
dir=$1
files=`ls -l $dir|grep log |awk '{print $9}'`
allStr=''
for data in ${files[@]}
do
	echo $data
	tpmc=`grep  "TpmC" $dir"/"$data  | grep -v \< |awk '{print $1}'`
	echo $tpmc
	avg=`grep -rn "avg_rt" $dir"/"$data| awk '{print $8}' | sed  ':a;N;s/\n/,/g;ta'`
	echo $avg
	echo $avg","$tpmc
	resultfile=`echo $dir"/"$data | sed 's/\.log/\.csv/g'`
	echo "resultfile:"$resultfile
	allStr=$allStr$avg","$tpmc"\n"
	echo $avg","$tpmc > $resultfile
done
echo -e $allStr
echo -e $allStr > $dir"/allStr.csv"


