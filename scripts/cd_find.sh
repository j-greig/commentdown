#!/usr/bin/env bash
# List CD-enabled markdown docs under a directory (default: cwd).
# Implements the spec's Discovery rule (frontmatter-or-structural-entry):
#   branch 1: `commentdown:` frontmatter marker
#   branch 2: a valid entry heading beneath the reserved ## Comments heading
# Entry-shaped text outside the Comments section (e.g. fenced examples in a
# README) does not count.
set -euo pipefail

ROOT="${1:-.}"

find "$ROOT" -name '*.md' -type f -not -path '*/node_modules/*' -not -path '*/.git/*' -print0 |
while IFS= read -r -d '' f; do
  awk '
    NR <= 30 && /^commentdown:/ { fm = 1 }
    /^## Comments( \((newest|oldest) first\))?$/ { incom = 1; next }
    incom && /^```/ { fence = !fence }
    incom && !fence && /^## \[[A-Z]+\] cd-[0-9]{8}-[0-9]{6}-/ { entry = 1 }
    END { if (fm || entry) exit 0; exit 1 }
  ' "$f" && printf '%s\n' "$f" || true
done
