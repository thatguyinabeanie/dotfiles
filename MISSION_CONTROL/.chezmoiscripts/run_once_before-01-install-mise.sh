#!/bin/bash

# Install mise if not already installed
if ! command -v mise >/dev/null 2>&1; then
  echo "🟠 Installing mise version manager..."

  # Check for curl or wget
  if command -v curl >/dev/null 2>&1; then
    curl https://mise.jdx.dev/install.sh | sh
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- https://mise.jdx.dev/install.sh | sh
  else
    echo "Error: Neither curl nor wget is installed. Cannot install mise."
    exit 1
  fi

  # Add mise to PATH for the current session
  export PATH="$HOME/.local/bin:$PATH"

  echo "🔵 mise installed successfully."
fi