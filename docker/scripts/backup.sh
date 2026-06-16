#!/usr/bin/env bash
set -o nounset
set -o errexit

GAME_ROOT_DIR="/app"
BACKUP_DIR="/home/steam/backup"

rm -rf "$BACKUP_DIR/snapshot"
mkdir -p "$BACKUP_DIR/snapshot/Pal"
cp -r "$GAME_ROOT_DIR/Pal/Saved" "$BACKUP_DIR/snapshot/Pal/."
