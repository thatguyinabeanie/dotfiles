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
            MCP_PID=$!
            echo $MCP_PID > .mcp_server.pid
            echo "📝 MCP server PID: $MCP_PID"
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
    local pattern="${MCP_SERVER_PATTERN:-node.*mcp-server.js}"
    
    # First try to stop via PID file if it exists
    if [[ -f ".mcp_server.pid" ]]; then
        local pid=$(cat .mcp_server.pid)
        if kill "$pid" 2>/dev/null; then
            echo "✅ MCP server stopped (PID: $pid)"
            rm -f .mcp_server.pid
            return 0
        else
            echo "⚠️  PID $pid not found, trying pattern matching..."
            rm -f .mcp_server.pid
        fi
    fi
    
    # Fallback to pattern matching
    pkill -f "$pattern" && echo "✅ MCP servers stopped" || echo "⚠️  No MCP server processes found"
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
    local pattern="${MCP_SERVER_PATTERN:-node.*mcp-server.js}"
    
    # Check via PID file first
    if [[ -f ".mcp_server.pid" ]]; then
        local pid=$(cat .mcp_server.pid)
        if kill -0 "$pid" 2>/dev/null; then
            echo "🟢 MCP server is running (PID: $pid)"
            return 0
        else
            echo "⚠️  Stale PID file found, removing..."
            rm -f .mcp_server.pid
        fi
    fi
    
    # Fallback to pattern matching
    if pgrep -f "$pattern" > /dev/null; then
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