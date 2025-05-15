#!/bin/bash

SHELL_FILES=()
for arg in "$@"; do
  case "$arg" in
    *.sh|*.bash)
      if [ -f "$arg" ]; then
        SHELL_FILES+=("$arg")
      fi
      ;;
  esac
done

if [ ${#SHELL_FILES[@]} -eq 0 ]; then
  echo "No shell scripts to lint."
  exit 0
fi

shellcheck --severity=warning "${SHELL_FILES[@]}" 