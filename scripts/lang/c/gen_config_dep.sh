#!/usr/bin/env dash
# Generate makefile dep file on stdout
# for all the CONFIG_* which a preprocessed code
# possibly depends on

# Work in progress (this script is noop)
exit 0

set -e

if [ ! $# -eq 1 ]; then
  >&2 echo "Usage: $0 <input C file> [extra macro include file]"
  exit 1
fi

if [ ! -n "$TMPDIR" ]; then
  TMPDIR="$TEMP_DIR"
  if [ ! -n "$TEMP_DIR" ]; then
    TMPDIR=/tmp
  fi
fi

temp_preproc=$(mktemp -p "$TMPDIR" preproc.XXXXXXXXXX)
trap 'rm -f "$temp_preproc"' EXIT

if [ -n "$2" ]; then
  CFLAGS="-imacros \"$2\" $CFLAGS"
fi

# -ffreestanding and -undef make sure gcc preprocessor
# don't define any gcc specifics
$CPP -ffreestanding -undef -dU -E "$1" $CFLAGS -o "$temp_preproc"

cat $temp_preproc #| grep "#define "



