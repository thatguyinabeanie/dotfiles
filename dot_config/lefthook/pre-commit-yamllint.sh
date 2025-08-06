#!/bin/bash

YAML_FILES=()
for arg in "$@"; do
  case "$arg" in
    *.yml|*.yaml)
      if [ -f "$arg" ]; then
        YAML_FILES+=("$arg")
      fi
      ;;
  esac
done

if [ ${#YAML_FILES[@]} -eq 0 ]; then
  echo "No YAML files to lint."
  exit 0
fi

yamllint --config-file .yamllint.yml "${YAML_FILES[@]}" 