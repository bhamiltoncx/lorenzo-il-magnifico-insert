#!/usr/bin/env bash
#
# Verify that OpenSCAD actually resolved the vendored label font.
#
# OpenSCAD substitutes a default face for an unknown font name WITHOUT
# emitting any warning, so a missing or misnamed font would otherwise ship as
# a whole set of lids quietly rendered in the wrong typeface.
#
# The check is self-calibrating: it renders the same probe string twice, once
# with the real font name and once with a name guaranteed not to exist. If the
# font resolved, the two differ. If it did not, both took the fallback path and
# produce identical geometry. Facet count is used rather than a byte compare
# because OpenSCAD emits facets in a nondeterministic order between runs.
#
# Usage: scripts/check-font.sh /path/to/openscad

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

OSCAD="${1:?usage: check-font.sh /path/to/openscad}"
FONT_FILE="fonts/EBGaramondInsert-Italic-450.ttf"
FONT_NAME="EB Garamond Insert:style=Italic"
BOGUS="ZzNoSuchFontZz:style=Italic"

if [[ ! -f "$FONT_FILE" ]]; then
  echo "check-font: missing $FONT_FILE" >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

probe() {
  cat > "$tmp/probe.scad" <<SCAD
use <$PWD/$FONT_FILE>
linear_extrude(1) resize([100,0,0],auto=true)
  text("Lorenzo il Magnifico", font="$1", size=20,
       halign="center", valign="center", \$fn=32);
SCAD
  "$OSCAD" -o "$tmp/probe.stl" "$tmp/probe.scad" >/dev/null 2>&1
  grep -c 'facet normal' "$tmp/probe.stl" || true
}

real="$(probe "$FONT_NAME")"
fallback="$(probe "$BOGUS")"

if [[ "$real" == "0" || -z "$real" ]]; then
  echo "check-font: FAILED - probe produced no geometry" >&2
  exit 1
fi

if [[ "$real" == "$fallback" ]]; then
  cat >&2 <<MSG
check-font: FAILED - "$FONT_NAME" did not resolve.
  The probe rendered identically to a deliberately bogus font name
  ($real facets both ways), which means OpenSCAD silently substituted a
  default face. Labels would be rendered in the wrong typeface.
  Check that $FONT_FILE exists and is a valid TrueType file.
MSG
  exit 1
fi

echo "check-font: ok (\"$FONT_NAME\" $real facets vs $fallback fallback)"
