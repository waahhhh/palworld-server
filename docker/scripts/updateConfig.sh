#!/usr/bin/env bash
set -euo pipefail

DIR=`dirname $0`

cd "$DIR"

CONFIG_DIR="/home/steam/docker/config"
GAME_ROOT_DIR="/app"
GAME_CONFIG_DIR="$GAME_ROOT_DIR/Pal/Saved/Config/LinuxServer"

VALUES_FILE="values.ini"
ADDITIONAL_FILE="additional.ini"
OUTPUT_FILE="PalWorldSettings.ini"

if [[ ! -d "$GAME_CONFIG_DIR" ]]; then
  mkdir -p "$GAME_CONFIG_DIR"
fi

resolve_line_variables() {
    local line="$1"

    # Extract key and value strings split at '='
    local key="${line%%=*}"
    local raw_val="${line#*=}"

    # Isolate variable name (strip everything up to '$', then drop quotes and whitespace)
    local var_name="${raw_val##*\$}"
    var_name="${var_name//\"/}"
    var_name="${var_name###*([[:space:]])}"
    var_name="${var_name%%*([[:space:]])}"

    # Indirect lookup of environment variable
    local resolved_val="${!var_name}"

    # Reconstruct line matching original quote formatting
    if [[ "$raw_val" == *'"'* ]]; then
        echo "${key}=\"${resolved_val}\""
    else
        echo "${key}=${resolved_val}"
    fi
}

# --- 1. Process the main $VALUES_FILE ---
ALL_VALUES=""

while read -r VALUE; do
    # Trim leading/trailing whitespace natively
    VALUE="${VALUE###*([[:space:]])}"
    VALUE="${VALUE%%*([[:space:]])}"

    # Filter out empty entries and comment rows
    [[ -z "$VALUE" ]] && continue
    [[ "$VALUE" == \#* ]] && continue

    # Drop any trailing array delimiters (commas)
    VALUE="${VALUE%,}"

    # Handle environment variables if the target signature '$' is present
    if [[ "$VALUE" == *'$'* && "$VALUE" == *"="* ]]; then
        VALUE=$(resolve_line_variables "$VALUE")
    fi

    # Append to the global single-line array
    if [[ -z "$ALL_VALUES" ]]; then
        ALL_VALUES="$VALUE"
    else
        ALL_VALUES="$ALL_VALUES,$VALUE"
    fi
done < "$CONFIG_DIR/$VALUES_FILE"

# --- 2. Write structured $OUTPUT_FILE ---
cat << EOF > "$GAME_CONFIG_DIR/$OUTPUT_FILE"
[/Script/Pal.PalGameWorldSettings]
OptionSettings=($ALL_VALUES)
EOF

# --- 3. Process and append additional.ini ---
echo >> "$GAME_CONFIG_DIR/$OUTPUT_FILE"

while read -r ADD_LINE || [[ -n "$ADD_LINE" ]]; do
    if [[ "$ADD_LINE" == *'$'* && "$ADD_LINE" == *"="* ]]; then
        ADD_LINE=$(resolve_line_variables "$ADD_LINE")
    fi
    echo "$ADD_LINE" >> "$GAME_CONFIG_DIR/$OUTPUT_FILE"
done < "$CONFIG_DIR/$ADDITIONAL_FILE"

echo -e "\e[32mUpdated Config\e[0m"
