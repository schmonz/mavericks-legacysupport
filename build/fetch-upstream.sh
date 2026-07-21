#!/bin/sh
# Download + unpack the pinned upstream macports-legacy-support source. Not vendored:
# fetched by tag at build time so Renovate (which edits UPSTREAM_VERSION) drives it.
set -eu
SELF="$(cd "$(dirname "$0")" && pwd)"
MLS_ROOT="$(cd "$SELF/.." && pwd)"; export MLS_ROOT
. "$SELF/lib.sh"

U="$(upstream_version)"
DEST="${1:-$MLS_ROOT/build/upstream}"
mkdir -p "$DEST"
tarball="$DEST/v${U}.tar.gz"
url="https://github.com/macports/macports-legacy-support/archive/refs/tags/v${U}.tar.gz"
if [ ! -f "$tarball" ]; then
  tmp="$tarball.tmp.$$"
  curl -fsSL -o "$tmp" "$url"
  mv "$tmp" "$tarball"
fi
src="$DEST/macports-legacy-support-${U}"
[ -d "$src" ] || tar -xzf "$tarball" -C "$DEST"
[ -f "$src/Makefile" ] || { echo "fetch-upstream: no Makefile in $src" >&2; exit 1; }
printf '%s\n' "$src"
