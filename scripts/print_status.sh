#!/usr/bin/env dash

set -e

if [ ! $# -eq 2 ]; then
  echo "Usage $0 <short status> <long status>"
  exit 1
fi

PROJECT=""
if [ ! -z "$SUBPROJECT" ]; then
  PROJECT="$($LUA scripts/right_pad.lua 17 "$SUBPROJECT")"
fi

PREFIX="$($LUA scripts/right_pad.lua 10 "$1")"

if [ ! -z "$PROJECT" ]; then
  echo " [$PROJECT] [$PREFIX] $2"
else
  echo " [$PREFIX] $2"
fi
exit $?

