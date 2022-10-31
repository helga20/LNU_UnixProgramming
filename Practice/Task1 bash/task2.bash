#!/bin/bash

if [[ ($1 == "--test") ]]; then
	from=$(mktemp -d)
	to=$(mktemp -d)

	mkdir $from/subdir 

	touch $from/1.txt
	touch $from/2.txt
	touch $from/3.cpp
	touch $from/subdir/4.cpp
	./task2.bash $from $to cpp
	if [[ -e $to/3.cpp && -e $to/4.cpp && ! -e $to/1.txt && ! -e $to/2.txt ]]; then
		echo "test passed"
	else
		echo "test failed"
	fi
	rm -r $from
	rm -r $to
	exit 0
fi

if [[ ($1 == "--help") ]]; then
	echo "Usage: task1.bash DIR DIR_TO EXT"
	echo "Copy all files that have EXT extention from DIR to DIR_TO"
	exit 0
fi
if [[ ($# != 3) ]]; then
	echo "task1.bash: missing files operands"
	echo "Try 'task1.bash --help' for more information."
	exit 0
fi
if [[($# == 3) ]]; then
	for fullfile in $(find $1 -name *.$3) 
	do
		filename=$(basename -- "$fullfile")
		cp $fullfile $2/$filename
	done
	echo "Done"
fi

