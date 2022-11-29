#!/bin/bash
from=$(mktemp -d)
to=$(mktemp -d)
truncate -s 20k $from/1.txt
truncate -s 13k $from/2.txt
truncate -s 55k $from/3.txt
truncate -s 34k $from/4.txt
./source.py $from $to 37000 2
if [[ -e $to/1.txt && ! -e $from/1.txt && ! -e $from/2.txt && -e $to/2.txt && ! -e $to/3.txt && ! -e $to/4.txt &&  -e $from/3.txt && -e $from/4.txt ]]; then
	echo "Passed"
else
	echo "Failed"
fi
rm -r $from
rm -r $to
exit 0