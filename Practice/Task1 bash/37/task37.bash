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
	output=$(./task37.bash test.html) 
	string="     21 
      2 Hello
      1 World"
	echo "$string"
	echo "$output"
	if [[ ( "$output" = "$string" ) ]]; then
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

	if [[ ( -e $1 ) ]]; then
		cp $1 $tempdir/file.html
	else
		wget $1 -o $tempdir/file.html
	fi
	sed -e 's/<[^>]*>//g' $tempdir/file.html > output.txt
	tr -c '[:alnum:]' '[\n*]' < output.txt | sort | uniq -c | sort -nr | head  -100
	rm -r $tempdir

fi
