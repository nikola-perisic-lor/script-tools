#!/bin/bash

##############################################################################
# Script to check for files that exceed a specific line count limit

# Usage: ./check-file-length.sh

# Date: 11.02.2026.
##############################################################################

SEARCH_DIR="../src"
MAX_LINES=400
LONG_FILES=0

echo "Checking for files longer than $MAX_LINES lines in: $SEARCH_DIR..."
echo "------------------------------------------------"

# Excluding node_modules and .git
FILES=$(find "$SEARCH_DIR" -type f \( -name "*.ts" -o -name "*.tsx" \) \
    -not -path "*/node_modules/*" \
    -not -path "*/.git/*")

for file in $FILES; do
    # Count lines in the file
    LINE_COUNT=$(wc -l < "$file")

    if [ "$LINE_COUNT" -gt "$MAX_LINES" ]; then
        echo "⚠️  $file is too long: $LINE_COUNT lines"
        ((LONG_FILES++))
    fi
done

echo "------------------------------------------------"
if [ "$LONG_FILES" -eq 0 ]; then
    echo "All files are within the limit ($MAX_LINES lines)."
    exit 0
else
    echo "Found $LONG_FILES files that exceed the $MAX_LINES line limit."
    echo "Consider breaking these files into smaller components or hooks."
    exit 1
fi