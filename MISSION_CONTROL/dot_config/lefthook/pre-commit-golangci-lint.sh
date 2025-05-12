#!/bin/bash

GO_FILES=()
for arg in "$@"; do
  case "$arg" in
    *.go)
      if [ -f "$arg" ]; then
        GO_FILES+=("$arg")
      fi
      ;;
  esac
done

if [ ${#GO_FILES[@]} -eq 0 ]; then
  echo "No Go files to lint."
  exit 0
fi

golangci-lint run --timeout=5m "${GO_FILES[@]}" 