#!/bin/bash
from=$(mktemp -d)
to=$(mktemp -d)

mkdir $from/subdir 

touch $from/1.txt
touch $from/2.txt
touch $from/3.cpp
touch $from/subdir/4.cpp
./task1.bash $from $to cpp
if [[ -e $to/3.cpp && -e $to/4.cpp && ! -e $to/1.txt && ! -e $to/2.txt ]]; then
	echo "test passed"
else
	echo "test failed"
fi
rm -r $from
rm -r $to
	exit 0
