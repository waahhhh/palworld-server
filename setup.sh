#!/usr/bin/env bash
set -euo pipefail

DIR=`dirname $0`

cd "$DIR"

source "$DIR/load_env.sh"

read -p "APP_ENV is \"$APP_ENV\". Continue? [y/n]: " USER_CONFIRM

if [[ ! "$USER_CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "\e[31mAborted\e[0m"
    exit 1
fi

if [ "$APP_ENV" = "production" ]; then
    COMPOSE_COMMAND="docker compose -f compose.yaml -f compose.production.yaml"
else
    COMPOSE_COMMAND="docker compose -f compose.yaml"
fi

echo -e "\e[33mSetup server\e[0m"

# build the docker container
$COMPOSE_COMMAND build

# update the dedicated server
yes | $DIR/update.sh

# update the server configuration
$DIR/updateConfig.sh

# cleanup
$COMPOSE_COMMAND down --remove-orphans

echo -e "\e[32mSetup server done\e[0m"
