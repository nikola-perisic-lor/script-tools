#!/bin/bash

##############################################################################
# Script to locally ignore scripts directory
# This uses the .git/info/exclude file which is private to your local machine

# Usage: ./ignore-scripts-folder-for-git-tracking.sh

# Date: 11.02.2026.

##############################################################################

TARGET="frontend/lor-dta-mobility-web/scripts/"

if [ ! -d ".git" ]; then
    echo "Error: Please be in a root of the project where .git folder exists"
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