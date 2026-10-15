# Ports: killport frees TCP ports by terminating whatever is listening.

# Kill process(es) using specified port(s)
# Usage: killport 3000
#        killport 3000 8080 9000
# Tries graceful shutdown (SIGTERM) first, then force kill (SIGKILL) after 2 seconds
killport() {
  if [ $# -eq 0 ]; then
    echo "❌ Usage: killport <port> [port2] [port3] ..."
    return 1
  fi
  
  for port in "$@"; do
    echo "🔍 Checking port $port..."
    
    local pids=$(lsof -ti:$port 2>/dev/null)
    
    if [ -z "$pids" ]; then
      echo "   ℹ️  No process on port $port"
      continue
    fi
    
    # Get process names for feedback
    local process_info=$(echo "$pids" | xargs ps -p 2>/dev/null | tail -n +2 | awk '{print $1 " (" $4 ")"}' | tr '\n' ',' | sed 's/,$//')
    
    # Try graceful shutdown first
    echo "   🎯 Killing: $process_info"
    echo "$pids" | xargs kill -15 2>/dev/null
    
    # Wait briefly then force kill if still running
    sleep 2
    local remaining=$(lsof -ti:$port 2>/dev/null)
    if [ -n "$remaining" ]; then
      echo "   💥 Force killing remaining process(es)..."
      echo "$remaining" | xargs kill -9 2>/dev/null
    fi
    
    echo "   ✅ Port $port freed"
  done
}
