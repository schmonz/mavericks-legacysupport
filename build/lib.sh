# build/lib.sh -- sourced helpers for the mavericks-legacysupport build scripts.
# No side effects on source.

# Bare upstream version (x.y.z) from the committed UPSTREAM_VERSION file.
upstream_version() {
  tr -d '[:space:]' < "${MLS_ROOT:-.}/UPSTREAM_VERSION"
}

# Absolute path to the INSTALLED mavericks-shared-cmake scripts dir. Resolved from
# the CMake user package registry (what find_package consults) -- never a hard-coded
# prefix, never a vendored copy. Override with MAVERICKS_SCRIPTS for tests.
msc_scripts() {
  if [ -n "${MAVERICKS_SCRIPTS:-}" ]; then printf '%s\n' "$MAVERICKS_SCRIPTS"; return 0; fi
  reg=$(ls "$HOME/.cmake/packages/MavericksSharedCMake/"* 2>/dev/null | head -1)
  if [ -n "$reg" ]; then
    d=$(cat "$reg")
    if [ -d "$d/scripts" ]; then printf '%s\n' "$d/scripts"; return 0; fi
  fi
  echo "msc_scripts: cannot locate installed mavericks-shared-cmake scripts" >&2
  echo "  install it (README 'Install (once)') or set MAVERICKS_SCRIPTS" >&2
  return 1
}
