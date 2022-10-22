#!/bin/bash
from=$(mktemp -d)
to=$(mktemp -d)

mkdir $from/subdir 

touch $from/1.txt
touch $from/2.txt
touch $from/3.c
touch $from/subdir/4.c

./task2 $from $to c

if [[ -e $to/1.txt && -e $to/2.txt && ! -e $to/3.c && ! -e $to/4.c ]]; then
	echo "test failed"
else
	echo "test passed"
fi
rm -r $from
rm -r $to
exit 0
