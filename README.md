# Lorenzo Il Magnifico — Board Game Insert

An OpenSCAD insert for [Lorenzo Il Magnifico](https://boardgamegeek.com/boardgame/203993/lorenzo-il-magnifico),
built with the [Boardgame Insert Toolkit](https://github.com/IdoMagal/The-Boardgame-Insert-Toolkit) (BIT).

This repository imports the design as published and then applies fixes on top, so that
`git log` shows exactly what was changed and why.

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

## Rendering

Requires [OpenSCAD](https://openscad.org/). To export a single tray without editing the file,
override the globals on the command line:

```bash
OSC=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
BOX='Expansion V3: Auction Tiles, Family Tiles, Brown Pawn, Faith (no tokens)'

"$OSC" -o box.stl -D "g_isolated_print_box=\"$BOX\"" \
       -D "g_b_print_lid=false" -D "g_b_print_box=true" Lorenzo.scad
```

`g_isolated_print_box` looks the tray up by its exact name and renders it directly, bypassing
the `ENABLED_B` check — so a tray marked disabled will still export.

## Credits and license

- Original insert design: [Lorenzo Il Magnifico Insert on Printables](https://www.printables.com/model/340905-lorenzo-il-magnifico-insert)
- Boardgame Insert Toolkit: Copyright 2020 Ido Magal

Both are licensed [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/),
and this repository is distributed under the same license. See [LICENSE](LICENSE).
