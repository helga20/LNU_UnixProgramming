#!/bin/bash
tdir=$(mktemp -d)
touch $tdir/test.html

cat > test.html << EOF
<!DOCTYPE html>
<html>
  <body>
    <h1>Hello, World!</h1>
    <h2>world</h2>
  </body>
</html>
EOF

output=$(./task37.py test.html) 
string="[('world', 2), ('hello', 1)]"

if [[ ( "$output" = "$string" ) ]]; then
	echo "Test passed"
else
        echo "Test failed"
fi
rm -r $tdir
	exit 0

