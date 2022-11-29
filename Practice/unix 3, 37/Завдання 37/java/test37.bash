#!/bin/bash
tdir=$(mktemp -d)
touch $tdir/test.html

cat > test.html << EOF
<!DOCTYPE html>
<html>
  <body>
    <h1>Hello World World</h1>
  </body>
</html>
EOF

output=$(java task37 test.html) 
string="{world=2, hello=1}"

if [[ ( "$output" = "$string" ) ]]; then
	echo "Passed"
else
        echo "Failed"
fi
rm -r $tdir
	exit 0

