#!/bin/bash

# Simple Spotify integration
PLAYER_STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null || echo "stopped")

case "$PLAYER_STATE" in
    "playing")
        sketchybar --set $NAME drawing=on icon.color=0xffa6da95
        ;;
    "paused")
        sketchybar --set $NAME drawing=on icon.color=0xffeed49f
        ;;
    *)
        sketchybar --set $NAME drawing=off
        ;;
esac