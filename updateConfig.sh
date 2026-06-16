#!/usr/bin/env bash
set -euo pipefail

DIR=`dirname $0`

cd "$DIR"

source "$DIR/load_env.sh"

read -p "APP_ENV is \"$APP_ENV\". Continue? [y/n]: " USER_CONFIRM

if [[ ! "$USER_CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

if [ "$APP_ENV" = "production" ]; then
    COMPOSE_COMMAND="docker compose -f compose.yaml -f compose.production.yaml"
else
    COMPOSE_COMMAND="docker compose -f compose.yaml"
fi

echo -e "\e[33mUpdate server\e[0m"

$COMPOSE_COMMAND run --rm $COMPOSE_SERVICE_NAME /home/steam/docker/scripts/updateConfig.sh

echo -e "\e[32mUpdated server\e[0m"
