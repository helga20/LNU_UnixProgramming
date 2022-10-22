#!/bin/bash
if [[ ($1 == "--test") ]]; then
	tdir=$(mktemp -d)
	touch $tdir/test.html
	 
	cat > test.html << EOF
<!DOCTYPE html>
<html>
  <body>
    <h1>Hello, World!</h1>
    <h2>Hello</h2>
  </body>
</html>
EOF
	./task37.bash test.html
	if [[ ( -s output.txt ) ]]; then
		echo "Test passed"
	else
        	echo "Test failed"
	fi               
	rm -r $tdir
	exit 0
fi

if [[ ($1 == "--help") ]]; then
	echo "Usage: task37.bash URL or *.html"
	echo "Select the 100 most used words in HTML text"
	exit 0
fi
if [[ ($# == 1) ]]; then
	tempdir=$(mktemp -d)
	#url="https://www.gnu.org/software/libc/manual/html_node/Opening-and-Closing-Files.html"
	if [[ ( -e $1 ) ]]; then
		cp $1 $tempdir/file.html
	else
		wget $1 -o $tempdir/file.html
	fi
	sed -e 's/<[^>]*>//g' $tempdir/file.html > output.txt
	tr -c '[:alnum:]' '[\n*]' < output.txt | sort | uniq -c | sort -nr | head  -100
	rm -r $tempdir
	#truncate -s 10k ~/Task1/37/output.txt
fi




