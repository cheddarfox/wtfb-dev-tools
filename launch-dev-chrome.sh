#!/bin/bash

# Script to launch Chrome with a dedicated development profile
# Created by Scott Graham and Auggie (ARCHinTheIDE)

# Configuration
PROFILE_NAME="WTFB-Development"
PROFILE_DIR="/mnt/c/Users/Scott/AppData/Local/Google/Chrome/User Data/$PROFILE_NAME"
CHROME_PATH="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"

# Check if the profile directory exists, create it if it doesn't
if [ ! -d "$PROFILE_DIR" ]; then
    echo "Creating new Chrome profile directory: $PROFILE_NAME"
    mkdir -p "$PROFILE_DIR"
fi

# Launch Chrome with the development profile
echo "Launching Chrome with $PROFILE_NAME profile..."
"$CHROME_PATH" --profile-directory="$PROFILE_NAME" "$@"

echo "Chrome launched with development profile. Happy coding!"
