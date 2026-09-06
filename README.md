# Lorenzo Il Magnifico — Board Game Insert

An OpenSCAD insert for [Lorenzo Il Magnifico](https://boardgamegeek.com/boardgame/203993/lorenzo-il-magnifico),
built with the [Boardgame Insert Toolkit](https://github.com/IdoMagal/The-Boardgame-Insert-Toolkit) (BIT).

This repository imports the design as published and then applies fixes on top, so that
`git log` shows exactly what was changed and why.

> **Fix in this repo:** the family tile compartment in the *Expansion V3* tray is too small
> for the tiles it holds. See [Family tile compartment fix](#family-tile-compartment-fix).

## Contents

| File | Description |
|---|---|
| `Lorenzo.scad` | The insert design — all trays are defined in the `data` array |
| `boardgame_insert_toolkit_lib.2.scad` | BIT library v2.45, vendored so the design renders standalone |
| `fonts/` | The label typeface, vendored so no system font install is needed |
| `build.sh` | Exports box and lid STLs per tray |
| `scripts/check-font.sh` | Guards against OpenSCAD silently substituting the label font |
| `scripts/check-mesh.sh` | Guards against exporting a mesh slicers will reject |
| `scripts/make-font-instance.py` | Regenerates the vendored font instance |

## Trays

The `data` array defines eight trays. Each is toggled by its `ENABLED_B` flag:

- Development Cards
- Player Tokens — 1p
- Resource Tokens — 2 boxes
- Coins — 2 trays
- v3 flat layer — Main Bits: Leader Cards, Excommunication Tiles, 2p–3p Tokens, Dice, Bonus Tiles, and 5p-Overlay
- Special Tokens, Visconti Tokens
- Expansion V3: Auction Tiles, Family Tiles, Brown Pawn, Faith (no tokens)
- Special Development Cards and Special Tower Tile

## Building

Requires [OpenSCAD](https://openscad.org/). The build script exports each tray as a separate
box and lid STL into `build/`:

```bash
./build.sh          # the Expansion V3 tray (default)
./build.sh --list   # list every tray name
./build.sh --all    # every tray
./build.sh "Coins - 2 trays"
```

Set `OPENSCAD=/path/to/openscad` if it isn't auto-detected. Lids carry a perforation pattern
and take considerably longer to render than box bodies — minutes rather than seconds.

Prebuilt STLs are attached to the [releases](../../releases).

### Rendering by hand

To export a single tray without the script, override the globals on the command line:

```bash
OSC=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
BOX='Expansion V3: Auction Tiles, Family Tiles, Brown Pawn, Faith (no tokens)'

"$OSC" -o box.stl -D "g_isolated_print_box=\"$BOX\"" \
       -D "g_b_print_lid=false" -D "g_b_print_box=true" Lorenzo.scad
```

`g_isolated_print_box` looks the tray up by its exact name and renders it directly, bypassing
the `ENABLED_B` check — so a tray marked disabled will still export.

## Lid labels

Every lid carries its contents name on a raised plaque, set in **EB Garamond Italic** — chosen
because it closely matches the calligraphic lettering on the game's own cover.

| Tray | Label |
|---|---|
| Development Cards | *Development Cards* |
| Player Tokens - 1p | *Player Tokens* |
| Resource Tokens - 2 boxes | *Resources* |
| Coins - 2 trays | *Coins* |
| v3 flat layer — Main Bits… | *Main Bits* |
| Special Tokens, Visconti Tokens | *Special Tokens* |
| Expansion V3… | *Expansion* |
| Special Development Cards… | *Special Cards* |

Labels are declared as a `LABEL` block inside each tray's `BOX_LID`:

```openscad
[ LABEL,
    [
        [ LBL_TEXT,     "Expansion" ],
        [ LBL_SIZE,     AUTO ],
        [ LBL_FONT,     "EB Garamond Insert:style=Italic" ],
    ]
],
```

`LBL_SIZE, AUTO` scales the text to the lid, capped at 100 mm wide. On a perforated lid the
library automatically builds a solid plaque behind the lettering — border, 45° striped infill,
raised text on top.

### Which way up

BIT mirrors lid labels — `MakeLidLabel` applies `MirrorAboutPoint([1,0,0])`, identically in
v2 and v4 — because the lid is emitted flipped relative to how it sits on the box. The label is
extruded through the full lid thickness, so it is legible from either face, but reads the right
way round from only one. Viewed from +Z in the exported STL it appears mirrored; seat the lid
with the readable face up. The lid's profile is symmetric in Z (a full-width flange at both
faces with an inset body between), so neither orientation affects the print.

### About the font

Google ships EB Garamond as a **variable** font, and OpenSCAD 2021.01 cannot select a variable
axis at render time. Asking for `EB Garamond:style=Bold` does not fail — it silently returns a
synthesized face that is not EB Garamond at all. So the weight is pinned ahead of time:
`scripts/make-font-instance.py` bakes a static instance at weight 450 and renames the family to
`EB Garamond Insert`, both to disambiguate it from any system-installed EB Garamond and because
a 450-weight instance is not stock EB Garamond. (EB Garamond carries no Reserved Font Name, so
renaming is permitted but not required.)

```bash
pip install fonttools
python3 scripts/make-font-instance.py 450
```

### Mesh validation

`build.sh` also runs `scripts/check-mesh.sh` on every STL it writes, verifying that each edge is
shared by exactly two triangles. OpenSCAD's own manifold report is not sufficient — its internal
representation can be valid while the exported triangle soup still pinches. That is not
hypothetical: the *Expansion* label's plaque boundary originally landed exactly tangent to a lid
perforation, producing a single edge shared by four triangles, which Bambu Studio rejected as a
non-manifold edge. Such a tangency is a knife edge — every perturbation tried resolved it — so
that lid sets `LID_LABELS_BG_THICKNESS` to 2.2 instead of the default 2.0.

Because a missing font produces **no warning at all**, `build.sh` runs `scripts/check-font.sh`
before rendering. It draws a probe string twice — once with the real font name, once with a name
guaranteed not to exist — and fails if the two come out identical, which is what happens when
OpenSCAD has quietly fallen back.

Weight 450 keeps the finest strokes near 0.5 mm, which prints as a single extrusion on a 0.4 mm
nozzle. Lighter script faces were considered and rejected: Tangerine's hairlines fall well under
one extrusion width and print broken or fuzzy.

## Family tile compartment fix

The *Expansion V3* tray held the family tiles in a compartment measuring **57 × 66.5 mm**,
but the tiles themselves measure **57.14 × 67.5 mm** — undersized on *both* axes. The tiles
do not fit. This was reported independently by at least one other printer of a remix of this
design.

There was 5 mm of unused space to the right of the compartment, but only 1 mm behind it, so
enlarging it meant relocating the two compartments sharing its row.

| Component | Field | Before | After |
|---|---|---|---|
| Family Tiles | `CMP_COMPARTMENT_SIZE_XYZ` | `[57, 66.5, 13]` | `[58.5, 68.5, 13]` |
| Faith Tiles | `CMP_COMPARTMENT_SIZE_XYZ` | `[89, 46, 14]` | `[89, 45, 14]` |
| Faith Tiles | `POSITION_XY` | `[68, 68.5]` | `[68, 70.5]` |
| Brown Pawn | `POSITION_XY` | `[158, 68.5]` | `[158, 70.5]` |

The extra millimetre in Y comes from the faith compartment, which had room to spare. The
brown pawn had to move with it or the enlarged family compartment would have merged into it.

Clearance is now **1.36 mm** in X and **1.00 mm** in Y. Verified by measuring the exported
mesh directly:

| Cavity | X span | Y span |
|---|---|---|
| Family stack 1 | 69.00 → 127.50 (58.50) | 2.00 → 70.50 (68.50) |
| Family stack 2 | 128.50 → 187.00 (58.50) | 2.00 → 70.50 (68.50) |
| Faith | 69.00 → 158.00 (89.00) | 71.50 → 116.50 (45.00) |

Every partition remains a full 1 mm, and the faith compartment now sits flush against the
inner back wall. The tray's outer dimensions are unchanged at 190 × 117.5 × 17 mm, and the
lid geometry is byte-for-byte identical — **if you already printed this tray, you only need
to reprint the box body, not the lid.**

## Credits and license

- Original insert design: [Lorenzo Il Magnifico Insert on Printables](https://www.printables.com/model/340905-lorenzo-il-magnifico-insert)
- Boardgame Insert Toolkit: Copyright 2020 Ido Magal

Both are licensed [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/),
and this repository is distributed under the same license. See [LICENSE](LICENSE).
