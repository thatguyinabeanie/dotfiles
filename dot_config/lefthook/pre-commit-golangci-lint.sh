#!/bin/bash

set -e

# List of test subdirectories to lint (relative to _tests_)
TEST_DIRS=("helpers" "integration" "unit")

cd _tests_

for dir in "${TEST_DIRS[@]}"; do
  if [ -d "$dir" ] && find "$dir" -maxdepth 1 -name '*.go' | grep -q .; then
    echo "Running golangci-lint in $dir..."
    golangci-lint run --config .golangci.yml --timeout=5m "$dir" || exit 1
  fi
done 
