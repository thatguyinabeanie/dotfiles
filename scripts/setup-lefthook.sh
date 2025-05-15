#!/bin/sh

# Install Lefthook
if command -v brew >/dev/null 2>&1; then
  brew install lefthook markdown-link-check
elif command -v npm >/dev/null 2>&1; then
  npm install -g @arkweid/lefthook
else
  echo "Please install Homebrew or npm to install Lefthook"
  exit 1
fi

# Install markdownlint-cli2 using mise
if command -v mise >/dev/null 2>&1; then
  mise install markdownlint-cli2
else
  echo "Please install mise to install markdownlint-cli2"
  exit 1
fi

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

# Initialize Lefthook
lefthook install

echo "Lefthook has been installed and configured successfully!" 