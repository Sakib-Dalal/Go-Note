#!/bin/bash

# Get current date and time
current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

# Add all files to git
git add .

# Commit with timestamp message
git commit -m "Auto commit: $current_datetime"

# Check if commit was successful
if [ $? -eq 0 ]; then
    echo "Successfully committed all changes with message: 'Auto commit: $current_datetime'"
else
    echo "Commit failed or no changes to commit"
fi
