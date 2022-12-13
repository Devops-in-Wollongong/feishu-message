#!/usr/bin/env bash

set -e
trap exit INT

SHELL_DIR=$(cd "$(dirname "$0")";pwd)

target_url=$1
notes=$2
commit=$3
project_url=$4

message=$(helm template $SHELL_DIR/notification \
  --set-string newRelease.enabled=true \
  --set-string notes="$notes" \
  --set-string git.commit="$commit" \
  --set-string git.url="$project_url" | yq -ojson)
echo $message

curl -H "Content-Type:application/json" -X POST -k $target_url -d "$message"