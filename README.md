# Commentdown

## Tiny append-only comments for humans and agents working in the same markdown file

Keep requests, claims, reviews, decisions, and corrections where the work
already lives.

Commentdown is a small markdown convention for durable project coordination.
Each entry gets a stable ID, a route, a falsifier, and a topic tag. No service.
No database. No required bot. Just markdown that agents can grep and humans can
read.

```markdown
## [REQ] c-20260509-120000-maintainer-api-plan · Scope API refactor
@codex-driver: propose the smallest safe refactor plan.

Need a plan that preserves current routes and names risky files.

falsifies: an accepted API refactor plan already exists
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
- `falsifies:` keeps claims honest.
- `tag:` clusters related entries.

## What It Is Not

Commentdown is not a task tracker, CI system, agent runtime, or replacement for
good prose. It is the thin coordination layer under those tools.

## Adopt

There is nothing to install for the markdown convention.

Copy the shape from [COMMENTDOWN.md](COMMENTDOWN.md), add a `## Comments`
section to a markdown file, and start appending entries.

For another project, rename the handles, choose `minimal` or `strict`, and keep
project-specific gates in that project's own docs. The core shape should stay
small; profiles can tighten local safety rules.

Tooling ideas such as `commentdown lint`, `commentdown id`, and
`commentdown sort` are parked for later. The convention must stay usable as
plain markdown.

## Quick Start

1. Pick one markdown file that owns the active work.
2. Add `## Comments` at the bottom.
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

## Project Status

Commentdown is an early repo. The current candidate spec is Commentdown 1.2. It
is designed to be project-agnostic and plain-markdown first.
