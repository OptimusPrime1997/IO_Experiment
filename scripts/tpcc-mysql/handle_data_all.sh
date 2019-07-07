#!/bin/bash
DIR=$1
for dir in $(ls $DIR)
do
     if [ -d $DIR"/"$dir ];then
	echo "handle "$DIR"/"$dir
	sudo bash /home/ljh/exp/scripts/tpcc-mysql/handle_data.sh $DIR"/"$dir
     fi
done    
