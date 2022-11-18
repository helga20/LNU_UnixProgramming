#!/bin/bash
from=$(mktemp -d)
to=$(mktemp -d)

mkdir $from/subdir 

touch $from/1.txc
touch $from/2.txt
touch $from/3.c
touch $from/subdir/4.c
 
java task2 $from $to .c

if [[ ! -e $to/1.txc && ! -e $to/2.txt && -e $to/3.c && -e $to/4.c && -e $from/1.txc && -e $from/2.txt && -e $from/3.c && -e $from/subdir/4.c ]]; then
        echo "test passed"
else
        echo "test failed"
fi
rm -r $from
rm -r $to
exit 0

