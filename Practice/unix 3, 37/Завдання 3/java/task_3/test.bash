#!/bin/bash
from=$(mktemp -d)
to=$(mktemp -d)
truncate -s 20k $from/num_1.txt
truncate -s 13k $from/num_2.txt
truncate -s 55k $from/num_3.txt
truncate -s 34k $from/num_4.txt
java source $from $to 37000 2
if [[ ! -e $to/num_1.txt && -e $from/num_1.txt && -e $from/num_2.txt && ! -e $to/num_2.txt && -e $to/num_3.txt && -e $to/num_4.txt && ! -e $from/num_3.txt && ! -e $from/num_4.txt ]]; then
	echo "Test passed"
else
	echo "Test failed"
fi
rm -r $from
rm -r $to
exit 0
