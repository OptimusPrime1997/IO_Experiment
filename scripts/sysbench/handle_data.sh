#!/bin/bash
dir=$1
files=`ls -l $dir|grep log |awk '{print $9}'`
allStr=''
for data in ${files[@]}
do
	result=`grep  -A 18 "transactions:" $dir"/"$data  |grep "[0-9]" |grep -v errors |grep -v reconnects |grep -v total |awk '{print $2" "$3" "$4}' |sed 's/[a-z):]*//g' |sed 's/[0-9]* (//g'|sed 's/(//g' | sed 's/\//,/g' |sed 's/ /,/g' |sed ':a;N;s/\n/,/g;ta' | sed 's/[,][,]*/,/g' `
	resultfile=`echo $dir"/"$data | sed 's/\.log/\.csv/g'`
	#echo $result > $resultfile
	allStr=$allStr$result"\n"
done
echo -e $allStr > $dir"/allStr.csv"


