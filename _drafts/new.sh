#!/bin/sh

stamp=$(date --date='9:00 next day' +'%Y-%m-%d')
topic=${*:-untitled}

topic=$(echo "$topic" |sed -e 's/[^a-zA-Z0-9]/-/g' -e 's/--/-/g')

FILE="${stamp}-${topic}.md"
echo "$FILE"
touch "$FILE"
