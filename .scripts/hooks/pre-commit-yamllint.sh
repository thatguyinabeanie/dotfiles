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

echo "🔍 Validating YAML files using Node.js YAML parser (same engine as Neovim's yaml-language-server)..."

# Use Node.js to validate YAML (same parser as yaml-language-server)
for file in "${YAML_FILES[@]}"; do
  echo "Validating: $file"
  
  # Use Node.js with js-yaml (same library used by yaml-language-server)
  if ! node -e "
    const yaml = require('js-yaml');
    const fs = require('fs');
    try {
      yaml.load(fs.readFileSync('$file', 'utf8'));
      console.log('✅ Valid YAML: $file');
    } catch (e) {
      console.error('❌ Invalid YAML in $file:', e.message);
      process.exit(1);
    }
  " 2>/dev/null; then
    # Fallback to yaml-language-server if js-yaml not available
    echo "⚠️  js-yaml not found, checking basic syntax..."
    if ! python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
      echo "❌ YAML validation failed for $file"
      exit 1
    fi
    echo "✅ Basic YAML syntax valid: $file"
  fi
done

echo "✅ All YAML files validated successfully" 