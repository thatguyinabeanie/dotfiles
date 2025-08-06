#!/usr/bin/env bash

# Run all Neovim configuration tests
set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🧪 Running Neovim Configuration Tests"
echo "===================================="

# Change to the tests directory
cd "$(dirname "$0")"

# Run Go unit tests
echo -e "\n${YELLOW}Running Go unit tests...${NC}"
if go test -v ./unit -run TestNvim; then
    echo -e "${GREEN}✓ Go unit tests passed${NC}"
else
    echo -e "${RED}✗ Go unit tests failed${NC}"
    exit 1
fi

# Run startup performance tests if Neovim is available
if command -v nvim &> /dev/null; then
    echo -e "\n${YELLOW}Running startup performance tests...${NC}"
    if ./scripts/test_nvim_startup.sh; then
        echo -e "${GREEN}✓ Startup tests passed${NC}"
    else
        echo -e "${RED}✗ Startup tests failed${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠ Skipping startup tests (Neovim not found)${NC}"
fi

echo -e "\n${GREEN}✅ All tests completed successfully!${NC}"