#!/bin/bash

set -e

# Filter for .md files only
md_files=()
for file in "$@"; do
  if [[ "$file" == *.md ]]; then
    md_files+=("$file")
  fi
done

# Only run if we have Markdown files
if [ ${#md_files[@]} -eq 0 ]; then
  echo "No Markdown files to lint"
  exit 0
fi

# Check if markdownlint-cli2 is installed
if ! command -v markdownlint-cli2 &> /dev/null; then
  echo "❌ markdownlint-cli2 is not installed. Install with: bun add -g markdownlint-cli2"
  exit 1
fi

echo "Running markdownlint-cli2 on ${#md_files[@]} Markdown file(s)..."
markdownlint-cli2 "${md_files[@]}"
