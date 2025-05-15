#!/bin/bash

# Install lefthook and markdown-oxide
brew install lefthook markdown-oxide

# Install lefthook
lefthook install

# Install pre-commit hooks
pre-commit install

# Install Go dependencies
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Install shellcheck if not already installed
if ! command -v shellcheck >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install shellcheck
  else
    echo "Please install shellcheck manually"
  fi
fi

echo "Lefthook has been installed and configured successfully!" 