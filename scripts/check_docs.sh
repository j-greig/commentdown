#!/usr/bin/env bash
# Docs-consistency check. Run before committing a spec change (or wire as a
# pre-commit hook: ln -s ../../scripts/check_docs.sh .git/hooks/pre-commit).
#
# Catches the two drift classes that actually happened:
#   1. version strings disagreeing across spec / README / skill / helpers
#   2. instructions that contradict the spec's current defaults (stale phrases)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0

# 1. Version consistency: every "Commentdown X.Y" mention outside CHANGELOG and
#    the dev/ discussion history must match the spec frontmatter version.
spec_ver="$(awk -F'"' '/^  version:/ {print $2; exit}' COMMENTDOWN.md)"
[[ -n "$spec_ver" ]] || { echo "FAIL: no version in COMMENTDOWN.md frontmatter"; exit 1; }

while IFS=: read -r file line text; do
  ver="$(sed -E 's/.*Commentdown ([0-9]+\.[0-9]+).*/\1/' <<< "$text")"
  if [[ "$ver" != "$spec_ver" ]]; then
    echo "FAIL: $file:$line says Commentdown $ver, spec is $spec_ver"
    fail=1
  fi
done < <(grep -rn "Commentdown [0-9]\+\.[0-9]\+" README.md AGENT-LOOP-RUNBOOK.md skills/ install.sh 2>/dev/null || true)

# 2. Stale phrases: wording that contradicts current spec defaults.
#    Add a line here whenever a docs-drift bug is found — this list is the scar tissue.
declare -a stale=(
  "read the target file tail"        # pre-Order wording; latest entries follow declared order
  "at the end of \`## Comments\`"    # ditto
)
for phrase in "${stale[@]}"; do
  if hits="$(grep -rn "$phrase" README.md AGENT-LOOP-RUNBOOK.md skills/*/SKILL.md 2>/dev/null)"; then
    echo "FAIL: stale phrase '$phrase':"
    echo "$hits"
    fail=1
  fi
done

if [[ "$fail" -eq 0 ]]; then
  echo "ok: docs consistent with Commentdown $spec_ver"
fi
exit "$fail"
