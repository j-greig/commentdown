# Commentdown

## Tiny append-only comments for humans and agents working in the same markdown file

Keep requests, claims, reviews, decisions, and corrections where the work
already lives.

Commentdown is a small markdown convention for durable project coordination.
Each entry gets a stable ID, a route, a falsifier, and a topic tag. No service.
No database. No required bot. Plain markdown that agents can grep and humans
can read.

```markdown
## [REQ] cd-20260509-120000-maintainer-api-plan · Scope API refactor
@agent-driver: propose the smallest safe refactor plan.

Need a plan that preserves current routes and names risky files.

falsifies: wrong if an accepted API refactor plan already exists
tag: api-refactor
```

## Why It Exists

Agent work often disappears into chat context. Humans return later and cannot
tell who asked for what, which agent claimed a file, what evidence changed a
decision, or whether a concern was ever closed.

Commentdown makes that state explicit in the repo:

- `## Comments` is the shared log.
- Badge says kind: `[REQ]`, `[CLAIM]`, `[WATCH]`, `[DEC]`, etc.
- ID says who/when.
- `@actor:` says who acts next.
- `replies:` and `closes:` thread the work.
- `falsifies: wrong if ...` keeps claims honest (every entry names what would
  disprove it).
- `tag:` clusters related entries.

## Design Principles

- Plain markdown first.
- Append-only history.
- One fact, one owner.
- Optional fields stay optional.
- Agents get enough state to continue work; humans can reconstruct the thread.

## What It Is Not

Commentdown is not a task tracker, CI system, agent runtime, or replacement for
good prose. It is the thin coordination layer under those tools.

## Adopt

There is nothing to install for the markdown convention.

Copy the shape from [COMMENTDOWN.md](COMMENTDOWN.md), add a `## Comments`
section to a markdown file, and start appending entries. Comments live in the
artifact under discussion, never in a standalone comments file.

To give local agents a stable path to the spec, run `./install.sh` — it
symlinks `~/.commentdown` to this checkout (so the deployed spec tracks git,
and agent docs can point at `~/.commentdown/COMMENTDOWN.md`).

For another project, rename the handles, choose `minimal` or `strict`, and keep
project-specific gates in that project's own docs. The core shape should stay
small; profiles can tighten local safety rules.

Tooling is optional. The convention must stay usable as plain markdown.

For clock-sourced IDs, use the bundled helper:

```bash
python3 skills/commentdown/scripts/cd_id.py <author> <slug> [collision]
```

To find every CD-enabled doc in a repo later (frontmatter marker or a real
entry under its `## Comments` heading — fenced examples don't count):

```bash
./scripts/cd_find.sh path/to/repo
```

## Quick Start

1. Pick one markdown file that owns the active work.
2. Add `## Comments (newest first)` at the bottom (latest entry on top — the
   1.3 default; `(oldest first)` gives the classic log).
3. Register actor handles if routing could be ambiguous.
4. Append `[REQ]` for asks.
5. Append `[CLAIM]` before edits.
6. Append `[WATCH]`, `[PASS]`, or `[FAIL]` for review.
7. Append `[DEC]` for decisions.
8. Use `[ERRATA]` instead of rewriting history.

## For Agents

[COMMENTDOWN.md](COMMENTDOWN.md) is normative. Answer only entries routed to
your exact handle, unless the file's profile defines role aliases or broadcast
handles.

If you are running Codex and Claude as a pair, read
[AGENT-LOOP-RUNBOOK.md](AGENT-LOOP-RUNBOOK.md) after the spec. It is an optional
workflow profile, not core Commentdown.

## Worked Example

[dev/v1.3-release.md](dev/v1.3-release.md) is a real thread: the 1.3 release
was scoped, adversarially reviewed (two FAILs, then a PASS), and arbitrated
inside its own `## Comments` section, by a human and two different agents.

## Spec Status

Commentdown 1.3.1 is a draft convention. It is project-agnostic,
plain-markdown-first, and intended to stay small.

## License

MIT.
