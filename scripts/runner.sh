#!/bin/bash

##############################################################################
# Runner for project health checks

# Usage: ./runner.sh

# Runs the following checks:
# 1. check-empty-files.sh - Checks for empty files in the src directory
# 2. check-file-length.sh - Checks for files that exceed 500 lines of code
# 3. check-console-logs.sh - Prevents for console.log statements in the code
# 4. check-any-typescript-usages.sh - Prevents 'any' type usage in TypeScript files

# Date: 11.02.2026.

##############################################################################

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ ! -d "./src" ] && [ ! -d "../src" ]; then
    echo -e "${RED}✖ Error: 'src' folder not found!${NC}"
    exit 1
fi

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}🚀 Starting project health checks...${NC}"
echo -e "${BLUE}==========================================${NC}"

FAILED=0
SEPARATOR="${BLUE}------------------------------------------${NC}"

# 1. EMPTY FILES CHECKS
if ./check-empty-files.sh > /dev/null 2>&1; then
    echo -e "${GREEN}✔ [1/3] Empty files check passed.${NC}"
else
    echo -e "${RED}✘ [1/3] Empty files check failed:${NC}"
    ./check-empty-files.sh | grep "src/"
fi
echo -e "$SEPARATOR"

# 2. FILE LENGTH CHECKS
if ./check-file-length.sh > /dev/null 2>&1; then
    echo -e "${GREEN}✔ [2/3] File length check passed.${NC}"
else
    echo -e "${RED}✘ [2/3] File length check failed:${NC}"
    ./check-file-length.sh | grep "⚠️" | sed 's/..\/src\///g'
    FAILED=1
fi
echo -e "$SEPARATOR"

# 3. CONSOLE LOG AUDIT CHECKS
if ./check-console-logs.sh > /dev/null 2>&1; then
    echo -e "${GREEN}✔ [3/3] Console log audit passed.${NC}"
else
    echo -e "${RED}✘ [3/3] Console log audit failed:${NC}"
    ./check-console-logs.sh | sed 's/..\/src\///g' | awk '{print "  ⚠️  Line "$0}'
    FAILED=1
fi
echo -e "$SEPARATOR"

# 4. TYPESCRIPT 'ANY' USAGE CHECKS
if ./check-any-typescript-usages.sh > /dev/null 2>&1; then
    echo -e "${GREEN}✔ [4/4] TS 'any' type audit passed.${NC}"
else
    echo -e "${RED}✘ [4/4] TS 'any' type audit failed:${NC}"
    ./check-any-typescript-usages.sh | grep "src/" | sed 's/..\/src\///g' | awk '{print "  ⚠️ "$0}'
    FAILED=1
fi
echo -e "$SEPARATOR"

# FINAL SUMMARY
echo -e "${BLUE}==========================================${NC}"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN} All checks passed! Your code is clean.${NC}"
    exit 0
else
    echo -e "${RED} Some checks failed. Please review above.${NC}"
    exit 1
fi