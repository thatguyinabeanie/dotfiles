#!/bin/bash
# Task to install Python MCP servers
# Run with: mise run install-python-mcp

set -euo pipefail

echo "🐍 Installing Python MCP servers..."

# Install Python-based MCP servers using uv (fastest option)
if command -v uv &> /dev/null; then
    echo "📦 Installing with uv..."
    uv tool install mcp-server-fetch
    uv tool install mcp-server-git
elif command -v pipx &> /dev/null; then
    echo "📦 Installing with pipx..."
    pipx install mcp-server-fetch
    pipx install mcp-server-git
else
    echo "⚠️  No suitable Python package manager found (uv or pipx)"
    echo "   Install uv or pipx first"
fi

echo "✅ Python MCP servers installed!"