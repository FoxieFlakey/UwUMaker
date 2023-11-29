#!/usr/bin/env dash

if [ $# -lt 2 ]; then
  echo "Usage $0 <command> <file>"
  exit 1
fi

PREFIX="$($LUA scripts/right_pad.lua 10 " [$1] ")"
echo "${PREFIX}${2}"
exit $?

