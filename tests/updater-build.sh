#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
# Sanctioned LOCAL install of shared-cmake (README "Install (once)"). CI uses the action instead.
MSC_SRC="$(cd ../mavericks-shared-cmake && pwd)"
tmp="$(mktemp -d)"
cmake -S "$MSC_SRC" -B "$tmp/msc" >/dev/null
cmake --install "$tmp/msc" --prefix "$HOME/.local" >/dev/null

printf '1.5.2-mavericks.1\n' > VERSION
B="$tmp/updater"
cmake -S . -B "$B" -DCMAKE_OBJC_COMPILER=/usr/bin/clang >/dev/null
cmake --build "$B" --target LegacySupportUpdater >/dev/null
bin="$B/LegacySupportUpdater.app/Contents/MacOS/LegacySupportUpdater"
[ -x "$bin" ] || { echo "updater binary missing"; exit 1; }
! otool -L "$bin" | grep -qi MacportsLegacySupport || { echo "updater links the library it updates"; exit 1; }
echo "updater-build OK"
