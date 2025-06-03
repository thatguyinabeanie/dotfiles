#!/usr/bin/env bash

# Test Neovim startup performance
# This script measures the startup time and checks for errors

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Testing Neovim Startup Performance"
echo "====================================="

# Function to measure startup time
measure_startup() {
    local iterations=$1
    local total_time=0
    
    echo -e "${YELLOW}Running $iterations startup tests...${NC}"
    
    for _ in $(seq 1 $iterations); do
        # Measure time for headless startup
        # Use different time command based on OS
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS doesn't support nanoseconds in date, use time command
            local elapsed
            elapsed=$( (time -p nvim --headless +qa 2>/dev/null) 2>&1 | grep real | awk '{print int($2 * 1000)}' )
        else
            # Linux supports nanoseconds
            local start_time
            start_time=$(date +%s%N)
            nvim --headless +qa 2>/dev/null
            local end_time
            end_time=$(date +%s%N)
            # Calculate elapsed time in milliseconds
            local elapsed=$((($end_time - $start_time) / 1000000))
        fi
        total_time=$((total_time + elapsed))
        
        echo -n "."
    done
    echo
    
    # Calculate average
    local avg_time=$((total_time / iterations))
    echo -e "${GREEN}Average startup time: ${avg_time}ms${NC}"
    
    # Check if startup time is acceptable (under 200ms is good)
    if [ $avg_time -lt 200 ]; then
        echo -e "${GREEN}✓ Startup time is excellent!${NC}"
        return 0
    elif [ $avg_time -lt 500 ]; then
        echo -e "${YELLOW}⚠ Startup time is acceptable but could be improved${NC}"
        return 0
    else
        echo -e "${RED}✗ Startup time is too slow (${avg_time}ms > 500ms)${NC}"
        return 1
    fi
}

# Function to check for startup errors
check_startup_errors() {
    echo -e "\n${YELLOW}Checking for startup errors...${NC}"
    
    # Capture any errors during startup
    local error_output
    error_output=$(nvim --headless -c 'messages' -c 'qa' 2>&1 | grep -i -E 'error|warning|failed' || true)
    
    if [ -z "$error_output" ]; then
        echo -e "${GREEN}✓ No startup errors detected${NC}"
        return 0
    else
        echo -e "${RED}✗ Startup errors found:${NC}"
        echo "$error_output"
        return 1
    fi
}

# Function to check lazy loading
check_lazy_loading() {
    echo -e "\n${YELLOW}Checking lazy loading status...${NC}"
    
    # Create a temporary vim script to check loaded plugins
    cat > /tmp/check_lazy.vim << 'EOF'
let g:loaded_plugins = []
for [name, spec] in items(require('lazy').plugins())
    if spec._.loaded ~= v:null
        call add(g:loaded_plugins, name)
    endif
endfor
call writefile(g:loaded_plugins, '/tmp/loaded_plugins.txt')
qa!
EOF
    
    # Run the check
    nvim --headless -u ~/.config/nvim/init.lua -S /tmp/check_lazy.vim 2>/dev/null || true
    
    # Check if certain plugins that should be lazy are not loaded at startup
    if [ -f /tmp/loaded_plugins.txt ]; then
        local lazy_plugins=("codecompanion" "copilot-chat" "diffview" "overseer")
        local improperly_loaded=()
        
        for plugin in "${lazy_plugins[@]}"; do
            if grep -q "$plugin" /tmp/loaded_plugins.txt 2>/dev/null; then
                improperly_loaded+=("$plugin")
            fi
        done
        
        if [ ${#improperly_loaded[@]} -eq 0 ]; then
            echo -e "${GREEN}✓ All lazy plugins are properly configured${NC}"
        else
            echo -e "${RED}✗ The following plugins should be lazy but are loaded at startup:${NC}"
            printf '%s\n' "${improperly_loaded[@]}"
        fi
        
        # Cleanup
        rm -f /tmp/loaded_plugins.txt /tmp/check_lazy.vim
    else
        echo -e "${YELLOW}⚠ Could not check lazy loading status${NC}"
    fi
}

# Function to profile startup
profile_startup() {
    echo -e "\n${YELLOW}Generating startup profile...${NC}"
    
    # Create profile
    nvim --startuptime /tmp/nvim-startup.log --headless +qa 2>/dev/null
    
    if [ -f /tmp/nvim-startup.log ]; then
        echo -e "${GREEN}Top 10 slowest items:${NC}"
        # Extract and sort by time, show top 10
        grep -E '^[0-9]+\.[0-9]+\s+[0-9]+\.[0-9]+' /tmp/nvim-startup.log | \
            sort -k2 -nr | \
            head -10 | \
            awk '{printf "  %7.2fms  %s\n", $2, substr($0, index($0,$3))}'
        
        # Get total time
        local total_time
        total_time=$(tail -1 /tmp/nvim-startup.log | awk '{print $1}')
        echo -e "\n${GREEN}Total startup time: ${total_time}ms${NC}"
        
        # Cleanup
        rm -f /tmp/nvim-startup.log
    else
        echo -e "${RED}✗ Failed to generate startup profile${NC}"
    fi
}

# Main execution
main() {
    local failed=0
    
    # Check if nvim is available
    if ! command -v nvim &> /dev/null; then
        echo -e "${RED}✗ Neovim not found in PATH${NC}"
        exit 1
    fi
    
    # Run tests
    measure_startup 5 || failed=$((failed + 1))
    check_startup_errors || failed=$((failed + 1))
    check_lazy_loading || failed=$((failed + 1))
    profile_startup
    
    echo -e "\n====================================="
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}✓ All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}✗ $failed test(s) failed${NC}"
        exit 1
    fi
}

main "$@"