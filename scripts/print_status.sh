#!/usr/bin/env dash

if [ ! $# -eq 2 ]; then
  echo "Usage $0 <short status> <long status>"
  exit 1
fi

PREFIX="$($LUA scripts/right_pad.lua 10 " [$1] ")"
echo "${PREFIX}${2}"
exit $?

