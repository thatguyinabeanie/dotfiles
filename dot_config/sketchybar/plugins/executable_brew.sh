#!/bin/bash

# Simple brew update checker
if command -v brew >/dev/null 2>&1; then
	OUTDATED=$(brew outdated --quiet | wc -l | xargs)
	if [ "$OUTDATED" -gt 0 ]; then
		sketchybar --set $NAME label="$OUTDATED" icon.color=0xffffffff
	else
		sketchybar --set $NAME label="0" icon.color=0xff8aadf4
	fi
else
	sketchybar --set $NAME drawing=off
fi
