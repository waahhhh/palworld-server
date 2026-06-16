#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT_DIR="/app"

export LD_LIBRARY_PATH=.

cd "$GAME_ROOT_DIR"

./PalServer.sh \
    -useperfthreads \
    -NoAsyncLoadingThread \
    -UseMultithreadForDS
