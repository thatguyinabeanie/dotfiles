#!/bin/bash

set -e

# Filter for .lua files only
lua_files=()
for file in "$@"; do
  if [[ "$file" == *.lua ]]; then
    lua_files+=("$file")
  fi
done

# Only run if we have Lua files
if [ ${#lua_files[@]} -eq 0 ]; then
  echo "No Lua files to lint"
  exit 0
fi

echo "Running luacheck on ${#lua_files[@]} Lua file(s)..."
luacheck "${lua_files[@]}"