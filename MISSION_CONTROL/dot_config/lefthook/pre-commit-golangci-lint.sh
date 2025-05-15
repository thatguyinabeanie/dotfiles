#!/bin/bash

set -e

# List of test subdirectories to lint
TEST_DIRS=("__tests__" "__tests__/helpers" "__tests__/integration" "__tests__/unit")

for dir in "${TEST_DIRS[@]}"; do
  if [ -d "$dir" ] && find "$dir" -maxdepth 1 -name '*.go' | grep -q .; then
    echo "Running golangci-lint in $dir..."
    golangci-lint run --config __tests__/.golangci.yml --timeout=5m "$dir" || exit 1
  fi
done 