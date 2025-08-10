# MCP (Model Context Protocol) Helper Functions
# Managed by chezmoi - auto-sourced in shell startup

# Check if current directory has MCP configuration
mcp_check() {
    if [[ -f "mcp.json" ]]; then
        echo "✅ MCP configuration found"
        if [[ -f "package.json" ]] && grep -q '"mcp:start"' package.json; then
            echo "🚀 MCP start script available"
        fi
        return 0
    else
        echo "❌ No MCP configuration found"
        return 1
    fi
}

# Start MCP server for current project
mcp_start() {
    if [[ -f "mcp.json" ]]; then
        if [[ -f "package.json" ]] && grep -q '"mcp:start"' package.json; then
            echo "🚀 Starting MCP server..."
            pnpm mcp:start &
        else
            echo "⚠️  No mcp:start script found in package.json"
            return 1
        fi
    else
        echo "❌ No mcp.json found in current directory"
        return 1
    fi
}

# Stop MCP servers
mcp_stop() {
    echo "🛑 Stopping MCP servers..."
    pkill -f "node.*mcp-server.js" && echo "✅ MCP servers stopped" || echo "⚠️  No MCP server processes found"
}

# Restart MCP server
mcp_restart() {
    mcp_stop
    sleep 1
    mcp_start
}

# Show MCP status
mcp_status() {
    mcp_check
    if pgrep -f "node.*mcp-server.js" > /dev/null; then
        echo "🟢 MCP server is running"
    else
        echo "🔴 MCP server is not running"
    fi
}

# Auto-detect MCP projects (notification only - let Neovim handle starting)
mcp_auto_detect() {
    if [[ -f "mcp.json" ]] && [[ -f "package.json" ]] && grep -q '"mcp:start"' package.json; then
        echo "🔌 MCP-enabled project detected"
    fi
}

# Enhanced cd function with MCP auto-detection
cd() {
    builtin cd "$@"
    # Only auto-detect in interactive shells and if not already in tmux/background
    if [[ $- == *i* ]] && [[ -z "$TMUX_AUTO_CD" ]]; then
        mcp_auto_detect
    fi
}