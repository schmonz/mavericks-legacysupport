#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
# Case 1: no matching notes file -> a generated, non-empty default mentioning the version.
f="$(sh build/release-notes-file.sh 9.9.9-mavericks.1 9.9.9-mavericks.1)"
[ -f "$f" ] && [ -s "$f" ] || { echo "generated notes file missing/empty"; exit 1; }
grep -q '9.9.9-mavericks.1' "$f" || { echo "generated notes missing version"; exit 1; }
# Case 2: an existing non-empty release-notes/<tag>.md is returned verbatim.
mkdir -p release-notes
real="release-notes/0.0.0-test.md"; printf 'real notes\n' > "$real"
out="$(sh build/release-notes-file.sh 0.0.0-test 0.0.0-test)"
rm -f "$real"
[ "$out" = "$PWD/$real" ] || { echo "did not return the existing notes file (got: $out)"; exit 1; }
echo "release-notes-file OK"
