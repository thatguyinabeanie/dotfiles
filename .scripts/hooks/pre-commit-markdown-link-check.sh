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
  echo "No Markdown files to check for broken links"
  exit 0
fi

# Check if markdown-link-check is installed
if ! command -v markdown-link-check &> /dev/null; then
  echo "❌ markdown-link-check is not installed. Install with: mise install markdown-link-check"
  exit 1
fi

echo "Running markdown-link-check on ${#md_files[@]} Markdown file(s)..."

# Run markdown-link-check on each file
# Use --quiet to reduce output noise, --config if needed
for file in "${md_files[@]}"; do
  echo "  Checking links in: $file"
  # Check only relative/internal links, ignore external URLs in pre-commit
  markdown-link-check "$file" --quiet --config .markdown-link-check.json 2>&1 || true
done

echo "Link check completed"
