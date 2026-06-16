#!/usr/bin/env bash
set -euo pipefail

DIR=`dirname $0`

cd "$DIR"

source "$DIR/load_env.sh"

if [ "$APP_ENV" = "production" ]; then
    COMPOSE_COMMAND="docker compose -f compose.yaml -f compose.production.yaml"
else
    COMPOSE_COMMAND="docker compose -f compose.yaml"
fi

$COMPOSE_COMMAND stop
