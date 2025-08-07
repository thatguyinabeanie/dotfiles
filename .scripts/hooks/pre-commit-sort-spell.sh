#!/bin/bash
# Sort nvim spell file alphabetically (case-insensitive)

set -euo pipefail

SPELL_FILE="dot_config/nvim/spell/.en.utf-8.add"

# Check if the spell file is being committed
if [[ "$*" == *"$SPELL_FILE"* ]]; then
    echo "Sorting spell file: $SPELL_FILE"
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Sort the file case-insensitively and remove duplicates
    sort -f -u "$SPELL_FILE" > "$temp_file"
    
    # Replace the original file with the sorted version
    mv "$temp_file" "$SPELL_FILE"
    
    echo "Spell file sorted successfully"
fi