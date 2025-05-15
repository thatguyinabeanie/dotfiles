#!/bin/bash

set -e

# List of test subdirectories to lint (relative to __tests__)
TEST_DIRS=("helpers" "integration" "unit")

cd __tests__

for dir in "${TEST_DIRS[@]}"; do
  if [ -d "$dir" ] && find "$dir" -maxdepth 1 -name '*.go' | grep -q .; then
    echo "Running golangci-lint in $dir..."
    golangci-lint run --config .golangci.yml --timeout=5m "$dir" || exit 1
  fi
done 