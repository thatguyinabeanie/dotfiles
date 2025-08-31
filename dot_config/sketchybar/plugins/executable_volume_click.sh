#!/bin/bash

# Simple volume click handler
if command -v SwitchAudioSource >/dev/null 2>&1; then
	# Show audio device selector if available
	SwitchAudioSource -a | grep -v "Unknown UID"
else
	# Simple toggle mute
	osascript -e "set volume output muted not (output muted of (get volume settings))"
fi
