#!/usr/bin/env bash
#
# Export printable STLs from Lorenzo.scad.
#
# Usage:
#   ./build.sh                 # build the default tray (Expansion V3)
#   ./build.sh --all           # build every tray defined in Lorenzo.scad
#   ./build.sh --list          # list tray names and exit
#   ./build.sh "Coins - 2 trays" ["Another Tray" ...]
#
# Environment:
#   OPENSCAD   path to the OpenSCAD binary (auto-detected)
#   OUT        output directory (default: build)
#
# Each tray is exported as two STLs, a box and a lid, so they can be sliced
# and printed independently. Lids carry a perforation pattern and take
# substantially longer to render than box bodies.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

SCAD_FILE="Lorenzo.scad"
OUT="${OUT:-build}"

DEFAULT_TRAY='Expansion V3: Auction Tiles, Family Tiles, Brown Pawn, Faith (no tokens)'

find_openscad() {
  if [[ -n "${OPENSCAD:-}" ]]; then
    printf '%s' "$OPENSCAD"; return
  fi
  local candidate
  for candidate in \
    "$(command -v openscad 2>/dev/null || true)" \
    "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" \
    "/usr/local/bin/openscad" \
    "/usr/bin/openscad"
  do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
      printf '%s' "$candidate"; return
    fi
  done
  echo "error: OpenSCAD not found. Install it or set OPENSCAD=/path/to/openscad" >&2
  exit 1
}

# Tray names are the quoted string that opens each entry of the data array.
list_trays() {
  sed -n 's/^[[:space:]]*\[[[:space:]]*"\(.*\)",[[:space:]]*$/\1/p' "$SCAD_FILE"
}

# Turn a tray name into a filesystem-safe slug.
slugify() {
  # Note: -E (extended regex) is required here; BSD sed does not support \+ in BRE.
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E -e 's/[^a-z0-9]+/-/g' -e 's/^-+//' -e 's/-+$//'
}

render() {
  local tray="$1" part="$2" outfile="$3"
  local print_box=false print_lid=false
  [[ "$part" == box ]] && print_box=true
  [[ "$part" == lid ]] && print_lid=true

  echo "  $part -> $outfile"
  "$OSCAD" -o "$outfile" \
    -D "g_isolated_print_box=\"$tray\"" \
    -D "g_b_print_box=$print_box" \
    -D "g_b_print_lid=$print_lid" \
    "$SCAD_FILE" 2>&1 | grep -iE '^ERROR|WARNING' || true

  if [[ ! -s "$outfile" ]]; then
    echo "error: $outfile was not produced" >&2
    exit 1
  fi
}

OSCAD="$(find_openscad)"

# Labels use a vendored font. OpenSCAD substitutes a default face for an
# unresolved font name without warning, so verify before spending minutes
# rendering lids that would silently carry the wrong typeface.
./scripts/check-font.sh "$OSCAD"

case "${1:-}" in
  --list) list_trays; exit 0 ;;
  --all)  IFS=$'\n' read -r -d '' -a TRAYS < <(list_trays && printf '\0') ;;
  "")     TRAYS=("$DEFAULT_TRAY") ;;
  *)      TRAYS=("$@") ;;
esac

mkdir -p "$OUT"
echo "OpenSCAD: $OSCAD"

for tray in "${TRAYS[@]}"; do
  if ! list_trays | grep -Fxq "$tray"; then
    echo "error: no tray named \"$tray\" in $SCAD_FILE (try --list)" >&2
    exit 1
  fi
  slug="$(slugify "$tray")"
  echo "$tray"
  render "$tray" box "$OUT/${slug}-box.stl"
  render "$tray" lid "$OUT/${slug}-lid.stl"
done

echo
echo "Wrote:"
ls -la "$OUT"/*.stl
