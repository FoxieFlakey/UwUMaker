#!/usr/bin/env dash

set -e

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage *squeak*: '$0' <filename> [error msg]" >&2
  exit 1
fi

error_msg="File not found '$1' UwU"
if [ $# -eq 2 ]; then
  error_msg="$2"
fi

if [ ! -f "$1" ]; then
  echo "$error_msg" >&2
  exit 1
fi

