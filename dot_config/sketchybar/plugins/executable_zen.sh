#!/bin/bash

# Simple zen mode toggle
if [ "$1" = "on" ]; then
	sketchybar --set brew drawing=off \
		--set github.bell drawing=off \
		--set volume_icon drawing=off \
		--set volume drawing=off \
		--set battery drawing=off
elif [ "$1" = "off" ]; then
	sketchybar --set brew drawing=on \
		--set github.bell drawing=on \
		--set volume_icon drawing=on \
		--set volume drawing=on \
		--set battery drawing=on
else
	# Toggle mode
	CURRENT=$(sketchybar --query brew | jq -r '.drawing')
	if [ "$CURRENT" = "on" ]; then
		"$0" on
	else
		"$0" off
	fi
fi
