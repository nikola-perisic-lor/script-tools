#!/bin/bash

##############################################################################
# Script to prevent console.log statements

# Usage: ./check-console-logs.sh

# Date: 11.02.2026.

##############################################################################

SEARCH_DIR="../src"

LOGS=$(grep -rn "console\.log" "$SEARCH_DIR" --include=*.{ts,tsx} | grep -v '^[[:space:]]*//')

if [ -z "$LOGS" ]; then
    exit 0
else
    echo "$LOGS"
    exit 1
fi