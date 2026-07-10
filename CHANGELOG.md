# Changelog

## 2026-07-10 — Commentdown 1.3.1

- `falsifies:` values now start with the literal words `wrong if ...`, so the
  line self-explains in raw markdown (`falsifies: wrong if the scanner misses a
  live doc`). Older values without the prefix stay valid. Prefer one condition;
  list multiples and state any/all. A FAIL may name the PASS conditions that
  would overturn it.
- Added `## Versioning`: patch = wording/guidance, minor = new optional syntax,
  major = breaking (a `wrong-if:` field key is reserved for 2.0).
- Decided empirically: the 12 falsifies lines from the 1.3 release were
  classified (10 operative / 1 inert / 1 ceremonial) across a three-round
  claude/codex(gpt-5.6-sol) review — thread in `dev/falsifies-review.md`.

## 2026-07-10 — Commentdown 1.3

- Added `## Discovery`: `commentdown:` frontmatter recommended as explicit marker,
  never required; tools must also recognise a valid entry under the reserved
  `## Comments` heading (fenced examples don't count). Ships with
  `scripts/cd_find.sh` implementing both branches.

- Bumped spec to 1.3 (reconciled a deployed draft that had drifted ahead of the repo).
- Added `## Order`: `commentdown.order: newest-first | oldest-first`; newest-first
  default applies only to documents declaring 1.3, older docs keep their physical
  order (compat wording from gpt-5.6-sol review, cd-20260710-072345-codex-spec-review).
- Entry Locus: entries live in the artifact under discussion, never a dedicated
  comments-only file/folder; matching Common Mistakes bullet (recurring field failure).
- `falsifies:` placeholder values (e.g. TODO) declared non-satisfying; helpers must
  fail rather than auto-fill. (Reference helper implementing the guard lives in the
  adopting repo — wibandwob-heartbeat `scripts/cdown.py` — not in this repo.)
- Runbook: new "Filing (where the comments live)" section.
- Added `install.sh` — canonical install symlinks `~/.commentdown` to the repo
  checkout so the deployed spec can never drift from git again.
- Multi-actor discussion for this release: `dev/v1.3-release.md`.


## 2026-05-09 — Standards pass

- Kept spec frontmatter, added principles/compatibility, tightened wording.
- Kept spec frontmatter minimal.

## 2026-05-09 — Public spec polish

- Switched IDs to `cd-...`, genericized core examples, clarified README status/license, added MIT license.

## 2026-05-09 — Dry comments and single spec source

- Removed duplicated skill reference spec; added dry comment and no commit/CD duplication guidance.

## 2026-05-09 — Skill iteration after dual-agent review

- Folded skill nits: helper shape, host edit variants, and proactive claim warning.

## 2026-05-09 — Initial repo seed

- Added `README.md` with the human-facing project intro and quick start.
- Added `COMMENTDOWN.md` with the terse Commentdown 1.2 draft spec for
  append-only human/agent markdown coordination.
- Added `AGENT-LOOP-RUNBOOK.md` as an optional Codex-Claude workflow profile on
  top of Commentdown.
- Added `skills/commentdown` with a portable `SKILL.md`, Codex metadata,
  reference note, and deterministic ID helper.
