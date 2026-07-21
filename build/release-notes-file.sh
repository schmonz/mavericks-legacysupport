#!/bin/sh
# Print a path to a GUARANTEED non-empty Sparkle release-notes file for a release.
# The shared gen_appcast.sh rejects a missing OR empty notes file, so the appcast step
# must never hand it /dev/null. If release-notes/<TAG>.md exists and is non-empty, use it;
# otherwise generate a minimal default into a temp file and print THAT path.
#   usage: release-notes-file.sh <TAG> <FULL_VERSION>
set -eu
SELF="$(cd "$(dirname "$0")" && pwd)"
MLS_ROOT="$(cd "$SELF/.." && pwd)"
TAG="${1:?release-notes-file: TAG required}"
FULL="${2:?release-notes-file: FULL version required}"
notes="$MLS_ROOT/release-notes/${TAG}.md"
if [ -f "$notes" ] && [ -s "$notes" ]; then
  printf '%s\n' "$notes"
  exit 0
fi
tmp="$(mktemp -t mls-notes-XXXXXX)"
printf '## %s\n\nAutomated release of upstream macports-legacy-support for Mavericks (%s).\n' "$TAG" "$FULL" > "$tmp"
printf '%s\n' "$tmp"
