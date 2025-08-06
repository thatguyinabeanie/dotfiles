#!/bin/bash

# Get weather in both metric and imperial units with minimal format
METRIC=$(curl -s "wttr.in?m&format=1" 2>/dev/null | head -1 | sed 's/.*[[:space:]]\([+-][0-9]*°C\).*/\1/')
IMPERIAL=$(curl -s "wttr.in?u&format=1" 2>/dev/null | head -1 | sed 's/.*[[:space:]]\([+-][0-9]*°F\).*/\1/')

if [ -n "$METRIC" ] && [ -n "$IMPERIAL" ]; then
    echo "${METRIC}/${IMPERIAL}"
else
    echo "Weather unavailable"
fi