#!/bin/bash
if [[ ($1 == "--test") ]]; then
	tempordir=$(mktemp -d)
	touch $tempordir/testfile.html	 
	cat > testfile.html << EOF
	
<!DOCTYPE html>
<html>
  <body>
    <h1>test, test2, test2</h1>
  </body>
</html>
EOF
	done=$(./task37.bash testfile.html) 
	output="     17 
      2 test2
      1 test"
	echo "$done"
	echo "$output"
	if [[ ( "$done" = "$output" ) ]]; then
		echo "Passed"
	else
		echo "Failed"
	fi      
	rm -r $tempordir
	exit 0
fi

if [[ ($1 == "--help") ]]; then
	echo "Usage: task37.bash URL/html file"
	echo "Select 100 most used words in HTML text  that you specify by path or URL"
	echo "-h, --help show info about program"
	echo "-t, --test start program with same parameters"
	exit 0
fi
if [[ ($# == 1) ]]; then
	tempordir=$(mktemp -d)

	if [[ ( -e $1 ) ]]; then
		cp $1 $tempordir/temporfile.html
	else
		wget $1 -o $tempordir/temporfile.html
	fi
	sed -e 's/<[^>]*>//g' $tempordir/temporfile.html > done.txt
	tr -c '[:alnum:]' '[\n*]' < done.txt | sort | uniq -c | sort -nr | head  -100
	rm -r $tempordir

fi
