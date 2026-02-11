#!/bin/bash

##############################################################################
# Script to check for empty files within the src directory

# Usage: ./check-empty-files.sh

# Date: 11.02.2026.
##############################################################################

SEARCH_DIR="../src"

echo "Checking for empty files in: $SEARCH_DIR..."
echo "------------------------------------------"

EMPTY_FILES=$(find "$SEARCH_DIR" -type f -size 0 \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*")

if [ -z "$EMPTY_FILES" ]; then
    echo "No empty files found. Everything looks good!"
else
    echo "⚠️ Empty files detected:"
    echo "$EMPTY_FILES"
    
    # Count the number of empty files
    COUNT=$(echo "$EMPTY_FILES" | wc -l)
    echo "------------------------------------------"
    echo "Total empty files: $COUNT"
fi