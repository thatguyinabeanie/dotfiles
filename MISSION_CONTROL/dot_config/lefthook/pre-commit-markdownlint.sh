#!/bin/bash

# Prefer markdownlint-cli2 if available
if command -v markdownlint-cli2 >/dev/null 2>&1; then
  MARKDOWNLINT="markdownlint-cli2"
  # Use --fix if requested
  FIX=""
  for arg in "$@"; do
    if [ "$arg" = "--fix" ]; then
      FIX="--fix"
      break
    fi
  done
else
  # Fallback to markdownlint-cli
  for path in "$(npm bin)/markdownlint" "/usr/local/bin/markdownlint" "$(yarn bin)/markdownlint" "$(pnpm bin)/markdownlint"; do
    if [ -x "$path" ]; then
      MARKDOWNLINT="$path"
      break
    fi
  done
  if [ -z "$MARKDOWNLINT" ]; then
    if command -v npx &> /dev/null; then
      MARKDOWNLINT="npx markdownlint"
    else
      echo "Error: markdownlint not found. Please install markdownlint-cli2 or markdownlint-cli." >&2
      exit 1
    fi
  fi
  FIX=""
  for arg in "$@"; do
    if [ "$arg" = "--fix" ]; then
      FIX="--fix"
      break
    fi
  done
fi

# Filter only .md and .markdown files from arguments
FILES=()
for arg in "$@"; do
  case "$arg" in
    *.md|*.markdown)
      if [ -f "$arg" ]; then
        FILES+=("$arg")
      fi
      ;;
  esac
done

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No markdown files to lint."
  exit 0
fi

# Run linter in batch mode
if [ -n "$FIX" ]; then
  $MARKDOWNLINT $FIX "${FILES[@]}"
else
  $MARKDOWNLINT "${FILES[@]}"
fi
