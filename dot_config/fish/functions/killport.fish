# Kill process(es) using specified port(s)
# Usage: killport 3000
#        killport 3000 8080 9000
# Tries graceful shutdown (SIGTERM) first, then force kill (SIGKILL) after 2 seconds

function killport --description "Kill process(es) using specified port(s)"
    if test (count $argv) -eq 0
        echo "❌ Usage: killport <port> [port2] [port3] ..."
        return 1
    end

    for port in $argv
        echo "🔍 Checking port $port..."

        set -l pids (lsof -ti:$port 2>/dev/null)

        if test -z "$pids"
            echo "   ℹ️  No process on port $port"
            continue
        end

        # Get process names for feedback
        set -l process_info (echo $pids | xargs ps -p 2>/dev/null | tail -n +2 | awk '{print $1 " (" $4 ")"}' | tr '\n' ',' | sed 's/,$//')

        # Try graceful shutdown first
        echo "   🎯 Killing: $process_info"
        echo $pids | xargs kill -15 2>/dev/null

        # Wait briefly then force kill if still running
        sleep 2
        set -l remaining (lsof -ti:$port 2>/dev/null)
        if test -n "$remaining"
            echo "   💥 Force killing remaining process(es)..."
            echo $remaining | xargs kill -9 2>/dev/null
        end

        echo "   ✅ Port $port freed"
    end
end
