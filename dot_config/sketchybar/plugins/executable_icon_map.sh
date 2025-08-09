#!/bin/bash

# Icon mapping for apps - simplified version
case "$1" in
    "Finder") echo "󰀶";;
    "Safari") echo "";;
    "Firefox") echo "󰈹";;
    "Chrome"|"Google Chrome") echo "";;
    "Terminal") echo "";;
    "Code"|"Visual Studio Code") echo "󰨞";;
    "Xcode") echo "";;
    "Spotify") echo "";;
    "Discord") echo "󰙯";;
    "Slack") echo "󰒱";;
    "Notion") echo "󰈦";;
    "Notes") echo "󰠮";;
    "Mail") echo "󰇮";;
    "Calendar") echo "󰃭";;
    "System Preferences"|"System Settings") echo "";;
    "Activity Monitor") echo "󰄨";;
    *) echo "󰀏";;
esac