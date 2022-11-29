#!/bin/bash
if [[ ($1 == "--help") ]]; then 
	echo "Usage: run.bash DIR DIR_TO SIZE"
	echo "Copy all files exceeding SIZE from DIR to DIR_TO"
	echo "-h, --help show info about program"
	echo "-t, --test start program with same parameters"
	exit 0
fi

if [[ ($1 == "--test") ]]; then
	from=$(mktemp -d)
	to=$(mktemp -d)
	truncate -s 20k $from/num_1.txt
	truncate -s 13k $from/num_2.txt
	truncate -s 55k $from/num_3.txt
	truncate -s 34k $from/num_4.txt
	./run.bash $from $to 37000 2
	if [[ ! -e $to/num_1.txt && -e $from/num_1.txt && -e $from/num_2.txt && ! -e $to/num_2.txt && -e $to/num_3.txt && -e $to/num_4.txt && ! -e $from/num_3.txt && ! -e $from/num_4.txt ]]; then
		echo "Passed"
	else
		echo "Failed"
	fi
	rm -r $from
	rm -r $to
	exit 0
fi 


if [[($# == 4)]]; then 
	filesize=0
	filecount=0
	filesize_max=$3
	filecount_max=$4
	for fullfile in $(find $1 -type f -printf "%s;%p\n" | sort -n | cut -d ";" -f 2 )
	do
		filecount=$(($filecount+1))
		current_file_size=$(ls -l $fullfile | awk '{print  $5}')
		filesize=$(($filesize+$current_file_size))
		if [[ ( $filecount -le $filecount_max && $filesize < $filesize_max) ]]; then 
			continue
		else 
			filename=$(basename -- "$fullfile")
			mv $fullfile $2/$filename
		fi 
	done
	echo "DONE."
fi

