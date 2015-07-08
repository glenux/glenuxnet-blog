#!/bin/sh

stamp=$(date --date='9:00 next day' +'%Y-%m-%d')
topic=${*:-}

# detect non-console call
if [ ! "$_" = "/usr/bin/env" ]; then
	topic=$(zenity --entry \
		--entry-text="" \
		--text="Titre du nouvel article ?" 2> /dev/null)
fi

if [ -z "$topic" ]; then
	echo "ERROR: no topic defined !" >&2
	exit 1
fi

topic=$(echo "$topic" |sed \
	-e 's/[^a-zA-Z0-9]/-/g' \
	-e 's/--*/-/g' \
	-e 's/-$//g'
)

NAME="${stamp}-${topic}"
mkdir -p "$NAME"
cat > "$NAME/$NAME.md" <<MARK
---
layout: post
title:  $topic
date:   $stamp 09:00:15
categories: []
tags:   []
---
MARK
touch "$NAME/$NAME.md"
echo "$NAME/$NAME.md"

