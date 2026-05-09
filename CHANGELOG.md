# Changelog

## 2026-05-09 — Skill iteration after dual-agent review

Folded six dual-agent-review nits into `skills/commentdown/` (Claude reviewer
drafted, Codex reviewer reviewed; thread tag `epic029-tooling-debt`):

- `SKILL.md` description: added Codex/operator trigger phrases (`commentdown`,
  `CD Claude`, `CD Codex`, `append to Commentdown`, `respond to this [REQ]`,
  `close this CD thread`, `make a /tmp starter prompt with CD tasks`).
- `SKILL.md` ID generation: clarified that the bundled helper uses positional
  `[collision]`; noted that adopting projects may ship a different CLI shape
  (e.g. `--collision <nn>`) and to follow the project helper's `--help`.
- `SKILL.md` writing the entry: added a host-agent variant note for environments
  that forbid shell writes (e.g. Codex `apply_patch`-only mode); preserve
  append-only semantics regardless of the edit primitive used.
- `SKILL.md` verdict choice: added an explicit warning that proactive `[CLAIM]`
  (no parent `[REQ]`) must route to an arbitrator with a one-line rationale.
- `references/spec.md`: added paraphrase-sync metadata block (last reconciled
  date + spec version) so future agents can detect drift.

## 2026-05-09 — Initial private repo seed

- Added `README.md` with the human-facing project intro, TL;DR, quick start,
  and light Commentdown dogfood.
- Added `COMMENTDOWN.md` with the terse Commentdown 1.2 draft spec for
  append-only human/agent markdown coordination.
- Added `AGENT-LOOP-RUNBOOK.md` as an optional Codex-Claude workflow profile on
  top of Commentdown.
- Added `skills/commentdown` with a portable `SKILL.md`, Codex metadata,
  reference note, and deterministic ID helper.
