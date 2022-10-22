#!/bin/bash
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
./task2.bash test.html
if [[ ( -s output.txt ) ]]; then
	echo "Test passed"
else
        echo "Test failed"
fi
rm -r $tdir
	exit 0

