#!/bin/bash
##
## TERMINAL URL HANDLER
##
## Smart URL routing for tmux-fzf-url integration
## Routes URLs to appropriate terminal browsers based on URL patterns
##

set -euo pipefail

url="${1:-}"

if [[ -z "$url" ]]; then
    echo "Usage: $0 <url>" >&2
    exit 1
fi

##
## BROWSER AVAILABILITY CHECK
##
check_browser() {
    command -v "$1" >/dev/null 2>&1
}

##
## OPEN URL IN SYSTEM BROWSER
##
fallback_browser() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        nohup open "$1" >/dev/null 2>&1 &
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        nohup xdg-open "$1" >/dev/null 2>&1 &
    else
        echo "No suitable browser found for URL: $1" >&2
        exit 1
    fi
}

##
## OPEN ALL URLs IN SYSTEM BROWSER
##
fallback_browser "$url"