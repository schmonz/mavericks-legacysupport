#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
f=.github/renovate.json
python3 -m json.tool "$f" >/dev/null || { echo "invalid JSON"; exit 1; }
python3 - "$f" <<'PY'
import json, sys
c = json.load(open(sys.argv[1]))
assert "github>ModernMavericks/shared-cmake" in c.get("extends", []), "must extend the shared preset"
cm = c.get("customManagers", [])
m = [x for x in cm if x.get("depNameTemplate") == "macports/macports-legacy-support"]
assert m, "no customManager for upstream"
m = m[0]
assert m["datasourceTemplate"] == "github-tags", "wrong datasource"
assert m["fileMatch"] == ["^UPSTREAM_VERSION$"], "wrong fileMatch"
assert "extractVersionTemplate" in m, "must strip the leading v"
print("renovate OK")
PY
