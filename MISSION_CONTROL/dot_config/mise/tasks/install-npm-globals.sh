#!/bin/bash
# Task to install global npm packages
# Run with: mise run install-npm-globals

set -euo pipefail

echo "📦 Installing global npm packages..."

# Global npm packages to install
NPM_PACKAGES=(
  "@anthropic-ai/claude-code"
  "@modelcontextprotocol/server-filesystem"
  "@modelcontextprotocol/server-memory"
  "markdownlint-cli"
  "markdownlint-cli2"
  "mcp-hub"
  "mcp-neovim-server"
  "pnpm"
)

for package in "${NPM_PACKAGES[@]}"; do
  echo "  Installing $package..."
  npm install -g "$package" || echo "  ⚠️  Failed to install $package"
done

echo "✅ Global npm packages installed!"