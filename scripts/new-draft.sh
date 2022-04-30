#!/bin/sh

stamp=$(date --date='9:00 next day' +'%Y-%m-%d')
topic=${*:-}

if [ -z "$topic" ]; then
	echo "ERROR: no topic defined !" >&2
	exit 1
fi

topic=$(echo "$topic" \
	| iconv -f utf8 -t ascii//TRANSLIT \
	| sed \
	-e 's/[^a-zA-Z0-9]/-/g' \
	-e 's/--*/-/g' \
	-e 's/-$//g' \
	-e 's/\<\(.*\)\>/\L\1/g'
)


#NAME="${stamp}-${topic}"
NAME="${topic}"

cat > "$NAME.md" <<MARK
---
layout: post
title:  $topic
date:   $stamp 09:00:15
categories: []
tags:   []
published: false
---
MARK
touch "$NAME.md"
cp .tpl.vym "$NAME.vym"
echo "$NAME.md"

