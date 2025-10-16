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
  echo "No YAML files to validate."
  exit 0
fi

echo "🔍 Validating YAML files using yq..."

# Check if yq is installed
if ! command -v yq &> /dev/null; then
  echo "❌ yq is not installed. Install with: brew install yq"
  exit 1
fi

# Use yq to validate YAML
for file in "${YAML_FILES[@]}"; do
  echo "Validating: $file"

  if yq e '.' "$file" > /dev/null 2>&1; then
    echo "✅ Valid YAML: $file"
  else
    echo "❌ YAML validation failed for $file"
    yq e '.' "$file" 2>&1
    exit 1
  fi
done

echo "✅ All YAML files validated successfully" 