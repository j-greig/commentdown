#!/usr/bin/env python3
"""Print a deterministic Commentdown 1.2 comment ID.

Format: c-YYYYMMDD-HHMMSS-<author>-<slug>[-NN]

UTC, second resolution. Author/slug must match ^[a-z0-9-]+$. Author may be
passed with or without a leading '@'. Optional collision suffix in [1, 99].

Usage:
  python3 cd_id.py <author> <slug> [collision]
  python3 cd_id.py reviewer api-pass
  python3 cd_id.py @codex-driver api-b4 7

Spec: https://github.com/j-greig/commentdown/blob/main/COMMENTDOWN.md
Stdlib only. No external dependencies.
"""
from __future__ import annotations

import re
import sys
from datetime import UTC, datetime

SLUG = re.compile(r"^[a-z0-9-]+$")


def cid(author: str, slug: str, collision: int | None = None) -> str:
    a = author.lstrip("@").strip()
    s = slug.strip().lower()
    if not (SLUG.fullmatch(a) and SLUG.fullmatch(s)):
        raise SystemExit(f"author/slug must match ^[a-z0-9-]+$ (got {author!r} {slug!r})")
    if collision is not None and not (1 <= collision <= 99):
        raise SystemExit(f"collision must be in [1, 99] (got {collision})")
    ts = datetime.now(UTC).strftime("%Y%m%d-%H%M%S")
    suf = f"-{collision:02d}" if collision is not None else ""
    return f"c-{ts}-{a}-{s}{suf}"


def main(argv: list[str]) -> int:
    if len(argv) < 3 or len(argv) > 4:
        raise SystemExit("usage: cd_id.py <author> <slug> [collision]")
    collision = int(argv[3]) if len(argv) == 4 else None
    print(cid(argv[1], argv[2], collision))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
