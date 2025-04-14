#!/bin/bash

# Script to launch Chrome with a dedicated development profile
# Created by Scott Graham and Auggie (ARCHinTheIDE)

# Default profile name
DEFAULT_PROFILE="Dev Chrome"

# Parse command line arguments
USE_BACKUP=false
URL_ARGS=()

for arg in "$@"; do
    if [ "$arg" == "--use-backup" ]; then
        USE_BACKUP=true
    else
        URL_ARGS+=("$arg")
    fi
done

# Configuration
if [ "$USE_BACKUP" = true ]; then
    PROFILE_NAME="WTFB-Development"
    echo "Using backup profile: $PROFILE_NAME"
else
    PROFILE_NAME="$DEFAULT_PROFILE"
    echo "Using default profile: $PROFILE_NAME"
fi

PROFILE_DIR="/mnt/c/Users/Scott/AppData/Local/Google/Chrome/User Data/$PROFILE_NAME"
CHROME_PATH="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

# Check if the profile directory exists, create it if it doesn't
if [ ! -d "$PROFILE_DIR" ]; then
    echo "Creating new Chrome profile directory: $PROFILE_NAME"
    mkdir -p "$PROFILE_DIR"
fi

# Launch Chrome with the development profile
echo "Launching Chrome with $PROFILE_NAME profile..."
"$CHROME_PATH" --profile-directory="$PROFILE_NAME" "${URL_ARGS[@]}"

echo "Chrome launched with development profile. Happy coding!"
