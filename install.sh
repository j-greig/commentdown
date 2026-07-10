#!/usr/bin/env bash
# Canonical install: symlink ~/.commentdown -> this repo checkout.
# A symlink (not a copy) means the deployed spec can never drift from git again.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${HOME}/.commentdown"

if [[ -L "$TARGET" ]]; then
  current="$(readlink "$TARGET")"
  if [[ "$current" == "$REPO_DIR" ]]; then
    echo "ok: $TARGET already links to $REPO_DIR"
    exit 0
  fi
  backup="${TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  echo "backing up existing symlink: $TARGET (-> $current) as $backup"
  mv "$TARGET" "$backup"
elif [[ -d "$TARGET" ]]; then
  backup="${TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  echo "backing up existing directory: $TARGET -> $backup"
  mv "$TARGET" "$backup"
elif [[ -e "$TARGET" ]]; then
  echo "error: $TARGET exists and is not a directory or symlink" >&2
  exit 1
fi

ln -s "$REPO_DIR" "$TARGET"
echo "installed: $TARGET -> $REPO_DIR"
