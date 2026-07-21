#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
fail=0
grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' UPSTREAM_VERSION || { echo "UPSTREAM_VERSION not a bare x.y.z"; fail=1; }
for pat in '^/VERSION$' '^build/$' '^dist/$'; do
  grep -Eq "$pat" .gitignore || { echo ".gitignore missing $pat"; fail=1; }
done
file updater/mavericks-legacysupport-updater.icns | grep -qi 'icon' || { echo "icns not a valid icon"; fail=1; }
[ "$fail" = 0 ] && echo "skeleton OK"
exit $fail
