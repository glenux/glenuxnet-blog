#!/bin/sh

stamp=$(date --date='9:00 next Thu' +'%Y-%m-%d')
topic=${*:-}

if [ -z "$topic" ]; then
	echo "ERROR: no topic given"
	exit 1
fi
topic=$(echo "$topic" |sed -e 's/[^a-zA-Z0-9]/-/g' -e 's/--/-/g')

FILE="${stamp}-${topic}.md"
echo "$FILE"
touch "$FILE"
