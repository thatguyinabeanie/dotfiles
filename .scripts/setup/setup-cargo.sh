#!/usr/bin/env bash
set -euo pipefail

CARGO_YAML="$HOME/.chezmoidata/cargo.yaml"

# Install Rust if not already installed
if ! command -v cargo &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Install yq if not present
if ! command -v yq &> /dev/null; then
  pip install yq
fi

# Read and install each cargo package
for pkg in $(yq '.cargo[]' "$CARGO_YAML" | xargs); do
  cargo install "$pkg"
done 