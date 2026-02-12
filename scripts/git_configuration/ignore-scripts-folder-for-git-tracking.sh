#!/bin/bash

##############################################################################
# Script to locally ignore scripts directory
# This uses the .git/info/exclude file which is private to your local machine

# Usage: ./ignore-scripts-folder-for-git-tracking.sh

# Date: 12.02.2026.
##############################################################################

ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$ROOT_DIR" ]; then
    echo "Error: Please be inside a git repository."
    exit 1
fi

cd "$ROOT_DIR"

TARGET="frontend/lor-dta-mobility-web/scripts/"

if [ ! -d ".git" ]; then
    echo "Error: .git folder not found at $ROOT_DIR"
    exit 1
fi

if grep -Fxq "$TARGET" .git/info/exclude; then
    echo "Path is already in the exclude file"
else
    echo "$TARGET" >> .git/info/exclude
    echo "Added: $TARGET -> .git/info/exclude"
fi

git rm -r --cached "$TARGET" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Folder was tracked, but has now been removed from the index and will be ignored for future commits."
else
    echo "Directory was not in the index or an error occurred. It will now be ignored for future commits."
fi

echo "Finished! Git will not track scripts directory: $TARGET"