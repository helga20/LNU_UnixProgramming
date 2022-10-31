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

output=$(./task37.pl test.html) 
string="1. hello: (2)
2. world: (1)"

if [[ ( "$output" = "$string" ) ]]; then
	echo "Test passed"
else
        echo "Test failed"
fi
rm -r $tdir
	exit 0

