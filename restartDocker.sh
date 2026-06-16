#!/usr/bin/env bash
set -euo pipefail

DIR=`dirname $0`

echo -e "\e[33mRestart server\e[0m"

$DIR/stopDocker.sh
$DIR/startDocker.sh

echo -e "\e[33mServer restart completed\e[0m"
