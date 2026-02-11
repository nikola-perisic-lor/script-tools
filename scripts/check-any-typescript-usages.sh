#!/bin/bash

##############################################################################
# Script to prevent TypeScript files for 'any' type usage
#
# Usage: ./check-any-typescript-usages.sh
#
# Date: 11.02.2026.
##############################################################################

SEARCH_DIR="../src"
ANY_USAGE_FOUND=0

echo "Auditing for 'any' type usage in: $SEARCH_DIR..."
echo "------------------------------------------------"

# -r: recursive, -n: line number, -E: regex
# Searches for ': any' or ':any' while excluding node_modules
ANY_USAGE=$(grep -rnE ":\s*any" "$SEARCH_DIR" --exclude-dir=node_modules --include="*.ts" --include="*.tsx")

if [ -z "$ANY_USAGE" ]; then
    echo "Congratulations! No 'any' types found. Your TypeScript is strong."
    exit 0
else
    echo "⚠️ Found 'any' type usage:"
    echo "$ANY_USAGE"
    echo "------------------------------------------------"
    exit 1
fi