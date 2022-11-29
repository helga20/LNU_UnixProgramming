#!/bin/bash
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

done=$(./task37.pl testfile.html) 
output="1. test2: (2)
2. test: (1)"

if [[ ( "$done" = "$output" ) ]]; then
	echo "Passed"
else
        echo "Failed"
fi
rm -r $tempordir
	exit 0


