---
title: Commentdown
status: draft
description: Append-only markdown comments for durable human-agent project coordination.
commentdown:
  version: "1.2"
  profile: minimal
  registry:
    handles:
      maintainer: {kind: human, role: arbitrator}
      codex-driver: {kind: agent, role: driver}
      codex-reviewer: {kind: agent, role: reviewer}
      claude-reviewer: {kind: agent, role: reviewer}
    arbitration:
      spec_changes: maintainer
---

# Commentdown

> Tiny append-only comments for humans and agents working in the same markdown
> file.
>
> Keep requests, claims, reviews, decisions, and corrections where the work
> already lives.

**TL;DR:** Commentdown is a small markdown convention for durable project
coordination. It gives each request, claim, review, decision, and correction a
stable ID, a route, a falsifier, and a topic tag. No service. No database. No
required bot. Just markdown that agents can grep and humans can read.

```markdown
## [REQ] c-20260509-120000-maintainer-api-plan · Scope API refactor
@codex-driver: propose the smallest safe refactor plan.

Need a plan that preserves current routes and names risky files.

falsifies: an accepted API refactor plan already exists
tag: api-refactor
```

## Why Agent Work Needs A Durable Shared Log

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

Read this order:

1. [COMMENTDOWN.md](COMMENTDOWN.md) through `Parking Lot`.
2. The target file's frontmatter registry.
3. The target file's latest `## Comments` entries.

Then answer only entries routed to your exact handle, unless the file's profile
defines role aliases or broadcast handles.

If you are running Codex and Claude as a pair, read
[AGENT-LOOP-RUNBOOK.md](AGENT-LOOP-RUNBOOK.md) after the spec. It is an optional
workflow profile, not core Commentdown.

## Project Status

Commentdown is an early repo. The current candidate spec is Commentdown 1.2. It
is designed to be project-agnostic and plain-markdown first.

## Comments

## [INFO] c-20260509-100143-codex-driver-oss-readme-seed · Seed future OSS README
status: info
refs: README.md; COMMENTDOWN.md
cc: @maintainer; @claude-reviewer
tldr: This repo is a human README plus terse agent spec for Commentdown.

The README intentionally starts friendly for humans, then points agents to the
spec and the `## Comments` convention. It dogfoods Commentdown lightly without
making the README feel like a protocol dump.

falsifies: a new human reader cannot understand the project in one minute, or a fresh agent cannot find the spec and comments entry point
tag: oss-readme

## [INFO] c-20260509-100152-codex-driver-readme-agent-note · Agent reading path
status: info
refs: README.md; COMMENTDOWN.md
cc: @claude-reviewer; @codex-reviewer
tldr: Agent path is README for intent, COMMENTDOWN.md for rules, target file comments for work.

Agents should not treat README prose as normative where `COMMENTDOWN.md`
disagrees. README explains the project; COMMENTDOWN.md owns the protocol.

falsifies: future agents cite README examples over COMMENTDOWN.md rules when the two diverge
tag: oss-readme

## [REQ] c-20260509-100152-codex-driver-readme-next · Review repo-shaped draft
status: request
refs: README.md; COMMENTDOWN.md
@claude-reviewer: review this folder for open-source clarity, overfit language, and unnecessary ceremony.
cc: @maintainer; @codex-reviewer
tldr: Please review the future OSS repo folder and CD back with terse PASS/WATCH/FAIL.

Prefer cuts over additions. Keep the repo usable as plain markdown.

falsifies: README plus COMMENTDOWN.md already reads as a minimal public repo with no project-specific leakage
tag: oss-readme
