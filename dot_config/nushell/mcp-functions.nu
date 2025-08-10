# MCP (Model Context Protocol) Helper Functions
# Managed by chezmoi - auto-sourced in shell startup

# Check if current directory has MCP configuration
def mcp_check [] {
    if ("mcp.json" | path exists) {
        print "✅ MCP configuration found"
        if ("package.json" | path exists) and (open package.json | get -o scripts.mcp:start | is-not-empty) {
            print "🚀 MCP start script available"
        }
        true
    } else {
        print "❌ No MCP configuration found"
        false
    }
}

# Start MCP server for current project
def mcp_start [] {
    if ("mcp.json" | path exists) {
        if ("package.json" | path exists) and (open package.json | get -o scripts.mcp:start | is-not-empty) {
            print "🚀 Starting MCP server..."
            pnpm mcp:start
        } else {
            print "⚠️  No mcp:start script found in package.json"
        }
    } else {
        print "❌ No mcp.json found in current directory"
    }
}

# Stop MCP servers
def mcp_stop [] {
    print "🛑 Stopping MCP servers..."
    try {
        pkill -f "node.*mcp-server.js"
        print "✅ MCP servers stopped"
    } catch {
        print "⚠️  No MCP server processes found"
    }
}

# Restart MCP server
def mcp_restart [] {
    mcp_stop
    sleep 1sec
    mcp_start
}

# Show MCP status
def mcp_status [] {
    mcp_check
    try {
        pgrep -f "node.*mcp-server.js" | length
        print "🟢 MCP server is running"
    } catch {
        print "🔴 MCP server is not running"
    }
}

# Auto-detect MCP projects (notification only - let Neovim handle starting)
def mcp_auto_detect [] {
    if ("mcp.json" | path exists) and ("package.json" | path exists) and (open package.json | get -o scripts.mcp:start | is-not-empty) {
        print "🔌 MCP-enabled project detected"
    }
}

# MCP auto-detect hook for directory changes
def --env mcp_cd_hook [path?: string] {
    # Change directory first
    if ($path | is-empty) {
        cd ~
    } else {
        cd $path
    }
    
    # Only auto-detect in interactive mode
    if $nu.is-interactive {
        mcp_auto_detect
    }
}

# Alias for the enhanced cd function
alias cd = mcp_cd_hook