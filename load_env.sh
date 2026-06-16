#!/usr/bin/env bash
set -euo pipefail

DIR=`dirname $0`

cd "$DIR"

ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: $ENV_FILE file not found at $ENV_FILE" >&2

    return 1 2>/dev/null || exit 1
fi

# Read line-by-line, ignore comments (#), and ignore empty lines
while IFS= read -r line || [ -n "$line" ]; do
    # Remove carriage returns and leading/trailing whitespace
    cleaned_line=$(echo "$line" | tr -d '\r' | xargs)

    # Skip empty lines and lines starting with '#'
    if [[ -z "$cleaned_line" || "$cleaned_line" =~ ^# ]]; then
        continue
    fi

    # Extract the key and value
    key=$(echo "$cleaned_line" | cut -d'=' -f1)
    value=$(echo "$cleaned_line" | cut -d'=' -f2-)

    # Strip matching single or double quotes around the value
    value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")

    # Dynamically export the variable to the shell environment
    export "$key"="$value"
done < "$ENV_FILE"
