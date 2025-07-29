#!/bin/bash

# Run tests for DDEV Drupal Site Analyzer addon

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Running DDEV Drupal Site Analyzer Addon Tests${NC}"
echo "================================================"

# Check if bats is installed
if ! command -v bats &> /dev/null; then
    echo -e "${RED}Error: bats is not installed${NC}"
    echo "Please install bats-core: https://github.com/bats-core/bats-core"
    exit 1
fi

# Check if ddev is installed
if ! command -v ddev &> /dev/null; then
    echo -e "${RED}Error: ddev is not installed${NC}"
    echo "Please install DDEV: https://ddev.readthedocs.io/en/stable/#installation"
    exit 1
fi

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Run the tests
echo "Running test suite..."
cd "${DIR}"
bats test.bats

echo -e "${GREEN}All tests completed!${NC}"