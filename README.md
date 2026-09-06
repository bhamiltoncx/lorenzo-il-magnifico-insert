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
