#!/bin/bash

# Simple github notifications checker
if command -v gh >/dev/null 2>&1; then
	NOTIFICATIONS=$(gh api notifications --method GET --cache 5m | jq '. | length' 2>/dev/null || echo "0")
	if [ "$NOTIFICATIONS" -gt 0 ]; then
		sketchybar --set $NAME label="$NOTIFICATIONS" icon.color=0xffffffff
	else
		sketchybar --set $NAME label="" icon.color=0xff8aadf4
	fi
else
	sketchybar --set $NAME drawing=off
fi
