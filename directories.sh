#!/bin/bash

clear

# Prompt for the target if not already set
target=$(zenity --entry --text "What is your target website?" --title "Set Target Variable" 2>/dev/null)

# Exit if no target is set
if [ -z "$target" ]; then
    echo "No target specified. Exiting."
    exit 1
fi

echo "You have chosen: $target"

# Check if website needs authorized access
if [(curl -s -o /dev/null -w "%{http_code}" $target) == "401"]; then
    username=$(zenity --entry --text "What is the username?" --title "Set Username" 2>/dev/null)
    password=$(zenity --entry --text "What is the password?" --title "Set Password" 2>/dev/null)
    login="$username:$password@"
elif; then
    login=""
fi 

# Prompt for protocol selection
protocol=$(zenity --list --title="Select Protocol" --column="Protocol" "http" "https" 2>/dev/null)

# Exit if no protocol is selected
if [ -z "$protocol" ]; then
    echo "No protocol selected. Exiting."
    exit 1
fi

echo "Protocol selected: $protocol"

temp_output=$(mktemp)

# Run ffuf for a short duration to gather initial data
ffuf -u $protocol"://"$login$target"/FUZZ" -w ~/wordlists/common.txt -mc 100-299,500-599