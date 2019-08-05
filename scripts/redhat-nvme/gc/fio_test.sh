#!/bin/bash

# Adjust any of the variables below
numOfHoursToPrepDrive=1
# Variables fioRuntime and fioRamptime are in seconds
fioRuntime=600
fioRamptime=600
numOfIterations=3
# If unsure of what CPU the NVMe SSDs are on, set "affinitized=false"
affinitized=true
# If NVMe SSDs are installed on 1st CPU then set "numaCpu=0"
# If NVMe SSDs are installed on 2nd CPU then set "numaCpu=1"
numaCpu=1
# Adjust variable "fioDevice" to applicable device like /dev/nvme0n1 for pass-through 
fioDevice=/dev/nvme0n1
raidVolume="Passthru"

# Start of pre-defined functions
RunFioTest ()
{
	iostatRuntime=$(( tempRuntime + tempRamptime - 2 ))
	tempFioOutputStr="${configName}_${blockSize}_${SeqOrRandom}_${writePercent}write_IODepth${iodepth}_Workers${workers}_${iteration}"
	iostatFile="./${resultsFolder}/${tempFioOutputStr}_iostat.txt"
	fioParams="--time_based --ioengine=libaio --direct=1 --buffered=0 --norandommap"
	fioParams="${fioParams} --refill_buffers --stonewall"
	fioParams="${fioParams} --disable_slat=1 --disable_lat=1 --disable_bw=1"
	fioParams="${fioParams} --randrepeat=0 --thread --unified_rw_reporting=1"
	fioParams="${fioParams} --group_reporting --do_verify=0"
	if [[ $affinitized == true ]]; then
		fioParams="${fioParams} --cpus_allowed_policy=split --cpus_allowed=${affinity}"
	fi
	if [[ "${SeqOrRandom}" == "Random" ]]; then
		fioParams="${fioParams} --percentage_random=100 --random_generator=tausworthe64"
	fi
	fioParams="${fioParams} --runtime=${tempRuntime} --ramp_time=${tempRamptime}"
	fioParams="${fioParams} --name=${tempFioOutputStr}"
	fioParams="${fioParams} --size=100%"
	fioParams="${fioParams} --filename=${fioDevice}"
	if [ $writePercent -eq 100 ] && [[ "${SeqOrRandom}" == "Seq" ]]; then
		fioParams="${fioParams} --rw=write"
	elif [ $writePercent -eq 0 ] && [[ "${SeqOrRandom}" == "Seq" ]]; then
		fioParams="${fioParams} --rw=read"
	elif [ $writePercent -eq 100 ] && [[ "${SeqOrRandom}" == "Random" ]]; then
		fioParams="${fioParams} --rw=randwrite --rwmixwrite=100"
	elif [ $writePercent -eq 0 ] && [[ "${SeqOrRandom}" == "Random" ]]; then
		fioParams="${fioParams} --rw=randread --rwmixread=100"
	else
		fioParams="${fioParams} --rw=randrw --rwmixwrite=${writePercent}"
	fi
	fioParams="${fioParams} --bs=${blockSize}"
	fioParams="${fioParams} --iodepth=${iodepth} --iodepth_batch=${iodepth}"
	fioParams="${fioParams} --iodepth_batch_complete_min=${iodepth}"
	fioParams="${fioParams} --numjobs=${workers}"
	fioParams="${fioParams} --minimal --eta=never"
	fioParams="${fioParams} --output=./${resultsFolder}/${tempFioOutputStr}.csv"
	echo "$(date +%x_%T)__FioTest_${tempFioOutputStr}"
	iostat -tmy -p ${fioDevice} 1 ${iostatRuntime} > ${iostatFile} &
	$numactlCmd fio ${fioParams} &
	wait $(pidof fio)
	# The below commands change the results from semicolon delimited to comma delimited
	sed -i -e 's/;/,/g' ./${resultsFolder}/${tempFioOutputStr}.csv
	sed -i -e 's/_/,/g' ./${resultsFolder}/${tempFioOutputStr}.csv
}
# End of pre-defined functions


#######################################################################################

# Stopping irqbalance service
systemctl stop irqbalance

# Setting CPU affinity command and applicable CPUs if variable "affinitized=true"
numactlCmd=""
if [[ $affinitized == true ]]; then
	numactlCmd="numactl --cpunodebind=$numaCpu"
	numOfNumaNodes=$(( $( lscpu | grep "NUMA node(s):" | rev | awk '{print $1}' | rev ) ))
	numaNodesStrings=( $( lscpu | grep "NUMA node" | grep "CPU" | awk '{print $2}' ) )
	if [ $numaCpu -ge $numOfNumaNodes ] && [ $numOfNumaNodes -ge 1 ]; then
		numaCpu=$(( numOfNumaNodes - 1 ))
	fi
	if [ $numaCpu -lt $numOfNumaNodes ]; then
		nodeCpus=$( lscpu | grep "NUMA ${numaNodesStrings[$numaCpu]}" | awk '{print $4}' )
		nodeCpus=( ${nodeCpus/,/ } )
		affinity=${nodeCpus[0]}
	fi
fi

configName="vm1-${raidVolume}"
timestamp=$(date +%Y_%m%d_%H%M)
resultsFolder=${timestamp}_${configName}
mkdir -p ./${resultsFolder}

# Start of sequential workload testing section
SeqOrRandom=Seq
for blockSize in 128k; do
	workers=1
	# Start of pre-conditioning section
	iteration=Prep; writePercent=100; iodepth=128
	tempRuntime=$(( numOfHoursToPrepDrive * 60 * 60 )); tempRamptime=30
	RunFioTest
	# End of pre-conditioning section
	for (( iteration=1; iteration<=$numOfIterations; iteration++ )); do
		for writePercent in 100 0; do
			# Modify the below iodepths with whatever workloads are needed
			for iodepth in 4 1; do
				for workers in 4 1; do
					tempRuntime=${fioRuntime}; tempRamptime=${fioRamptime}
				    RunFioTest
				done
			done
		done
	done
done
# End of sequential workload testing section

# Start of random workload testing section
SeqOrRandom=Random
for blockSize in 4k; do
	# Start of pre-conditioning section
	iteration=Prep; writePercent=100; workers=8; iodepth=32
	tempRuntime=$(( numOfHoursToPrepDrive * 60 * 60 )); tempRamptime=30
	RunFioTest
	# End of pre-conditioning section
	for (( iteration=1; iteration<=$numOfIterations; iteration++ )); do
		for writePercent in 100 30 0; do
			for workers in 4 1; do
				# Modify the below iodepths with whatever workloads are needed
				if [ $workers -eq 16 ]; then
					iodepths=(256 128 64 32 16 8)
				elif [ $workers -eq 8 ]; then
					iodepths=(256 128 64 32 16 8)
				elif [ $workers -eq 4 ]; then
					iodepths=(4 1)
				else
					iodepths=(4 1)
				fi
				for iodepth in "${iodepths[@]}"; do
					tempRuntime=${fioRuntime}; tempRamptime=${fioRamptime}
					RunFioTest
				done
			done
		done
	done
done
# End of random workload testing section

# Combining all results into one file
cat ./${resultsFolder}/*.csv > ./${resultsFolder}/AllFioResults.csv

# Resuming irqbalance service
systemctl start irqbalance
