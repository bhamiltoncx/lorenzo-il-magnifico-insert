#!/usr/bin/env python3
"""Bake a static instance of EB Garamond Italic at a chosen weight.

OpenSCAD (2021.01) cannot select a variable-font axis at render time: asking
for a weight it has no static face for silently produces a synthesized or
substituted font instead. So we pin the weight ahead of time and vendor the
result.

The instance is renamed to the family "EB Garamond Insert" so that fontconfig
cannot confuse it with a system-installed EB Garamond. EB Garamond carries no
Reserved Font Name, so renaming is permitted but not required; we do it for
disambiguation and because a 450-weight instance is not stock EB Garamond.

Usage:
    pip install fonttools
    python3 scripts/make-font-instance.py [weight]
"""

import sys
import urllib.request

from fontTools import ttLib
from fontTools.varLib import instancer

SOURCE_URL = (
    "https://raw.githubusercontent.com/google/fonts/main/ofl/ebgaramond/"
    "EBGaramond-Italic%5Bwght%5D.ttf"
)
FAMILY = "EB Garamond Insert"
SUBFAMILY = "Italic"


def main() -> None:
    weight = int(sys.argv[1]) if len(sys.argv) > 1 else 450
    out = f"fonts/EBGaramondInsert-Italic-{weight}.ttf"

    print(f"downloading {SOURCE_URL}")
    with urllib.request.urlopen(SOURCE_URL) as response:
        source = response.read()
    with open("/tmp/EBGaramond-Italic-var.ttf", "wb") as handle:
        handle.write(source)

    font = ttLib.TTFont("/tmp/EBGaramond-Italic-var.ttf")
    axes = {a.axisTag: (a.minValue, a.maxValue) for a in font["fvar"].axes}
    low, high = axes["wght"]
    if not low <= weight <= high:
        raise SystemExit(f"weight {weight} outside supported range {low}-{high}")

    # updateFontNames=False because the STAT table only names the canonical
    # weights (400/500/600/700/800); an arbitrary weight has no axis value.
    instance = instancer.instantiateVariableFont(
        font, {"wght": weight}, updateFontNames=False
    )

    names = instance["name"]
    for name_id in (16, 17, 21, 22):  # typographic / WWS names
        names.removeNames(nameID=name_id)
    values = {
        1: FAMILY,
        2: SUBFAMILY,
        3: f"{FAMILY} {SUBFAMILY} {weight}",
        4: f"{FAMILY} {SUBFAMILY}",
        6: "EBGaramondInsert-Italic",
    }
    for name_id, value in values.items():
        names.setName(value, name_id, 3, 1, 0x409)  # Windows / Unicode BMP
        names.setName(value, name_id, 1, 0, 0)      # Macintosh / Roman

    instance.save(out)
    print(f"wrote {out}  (variable={'fvar' in instance})")
    print(f'use it as:  font = "{FAMILY}:style={SUBFAMILY}"')


if __name__ == "__main__":
    main()
