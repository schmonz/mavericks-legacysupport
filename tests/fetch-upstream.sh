#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
D="$(mktemp -d)"
src="$(sh build/fetch-upstream.sh "$D")"
[ -f "$src/Makefile" ] || { echo "no Makefile in $src"; exit 1; }
[ -d "$src/include" ] || { echo "no include/ in $src"; exit 1; }
rm -rf "$D"
echo "fetch-upstream OK -> $src"
