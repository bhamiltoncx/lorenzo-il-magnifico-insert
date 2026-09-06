#!/usr/bin/env bash
#
# Verify an exported STL is a closed manifold surface.
#
# In a watertight mesh every edge is shared by exactly two triangles. Slicers
# reject meshes that violate this ("non-manifold edge" in Bambu Studio,
# PrusaSlicer and Cura), so it is worth catching at build time rather than
# discovering on the print bed.
#
# OpenSCAD's own manifold report is NOT sufficient: its internal representation
# can be valid while the exported triangle soup still pinches, which is exactly
# what happened when a label plaque boundary landed tangent to a lid
# perforation. Such a tangency is a knife edge -- shifting any dimension by a
# fraction of a millimetre resolves it -- but it is invisible without a check.
#
# Usage: scripts/check-mesh.sh file.stl [file.stl ...]

set -euo pipefail

status=0

for file in "$@"; do
  awk -v name="$(basename "$file")" '
    /^[[:space:]]*vertex/ {
      v[n++] = $2 " " $3 " " $4
      if (n == 3) {
        for (i = 0; i < 3; i++) {
          a = v[i]; b = v[(i + 1) % 3]
          key = (a < b) ? a "|" b : b "|" a
          if (!(key in edge)) edges++
          edge[key]++
        }
        n = 0; tris++
      }
      next
    }
    END {
      bad = 0
      for (k in edge) if (edge[k] != 2) bad++
      if (bad > 0) {
        printf "check-mesh: FAILED %s - %d non-manifold edge(s) of %d (%d triangles)\n", name, bad, edges, tris
        for (k in edge) if (edge[k] != 2) {
          split(k, p, "|")
          printf "    edge shared by %d triangles: %s -> %s\n", edge[k], p[1], p[2]
        }
        exit 1
      }
      printf "check-mesh: ok %s (%d triangles, %d edges, all shared by exactly 2)\n", name, tris, edges
    }
  ' "$file" || status=1
done

exit $status
