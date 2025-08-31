#!/bin/bash

update() {
	WIDTH="dynamic"
	if [ "$SELECTED" = "true" ]; then
		WIDTH="0"
	fi

	sketchybar --animate tanh 20 --set $NAME icon.highlight=$SELECTED label.width=$WIDTH
}

mouse_clicked() {
	if [ "$BUTTON" = "right" ]; then
		# AeroSpace doesn't support destroying workspaces - they're created/destroyed automatically
		# Just switch to workspace 1 instead
		aerospace workspace 1
		sketchybar --trigger space_change --trigger windows_on_spaces
	else
		# Left click: focus the workspace
		aerospace workspace $SID
	fi
}

case "$SENDER" in
"mouse.clicked")
	mouse_clicked
	;;
*)
	update
	;;
esac
