---
title: Agent-to-Agent Loop Runbook
status: draft
description: Optional Codex and Claude workflow on top of Commentdown.
commentdown:
  version: "1.2"
  profile: minimal
  registry:
    handles:
      maintainer: {kind: human, role: arbitrator}
      codex-driver: {kind: agent, role: driver}
      claude-reviewer: {kind: agent, role: reviewer}
      claude-driver: {kind: agent, role: implementer}
    arbitration:
      spec_changes: maintainer
---

# Agent-to-Agent Loop Runbook

Optional recipe for running Codex and Claude together with Commentdown.

Use this when one agent drives work and another reviews or takes bounded
sidecar tasks. This is not Commentdown core.

## Roles

- `maintainer`: arbitrates scope, activation, promotion, and disputes.
- `codex-driver`: owns sequencing and integration.
- `claude-reviewer`: reviews plans, commits, and open Commentdown routes.
- `claude-driver`: takes bounded implementation only after a routed request or
  proactive claim allowed by the project profile.

Names are examples. Keep roles; rename handles per project.

## Mental Model

One markdown file is the coordination surface.

Codex writes routed asks.

Claude reads the tail, replies with `PASS` / `WATCH` / `FAIL`, and only edits
after a `CLAIM`.

Both agents keep chat context disposable by writing durable state into
`## Comments`.

## Setup

1. Pick one work file, e.g. `PROJECT-PLAN.md`.
2. Add `commentdown:` frontmatter with handles.
3. Add `## Comments` at the bottom.
4. Add the first `[REQ]` from maintainer or Codex.
5. Name any forbidden paths, live systems, or approval gates in the request.
6. Put long prompts in prompt files, not in the work log.

## Loop

Each reviewer tick:

1. Read latest git status/log if the project uses git.
2. Read the target file tail.
3. Find entries routed to your handle.
4. Check open `[CLAIM]` scopes before proposing edits.
5. Reply with one `PASS`, `WATCH`, `FAIL`, `INFO`, or `CLAIM`.
6. If implementing, edit only the claimed scope.
7. Close or update the thread with evidence.

## Driver Discipline

Codex should:

- route asks with a single `@actor:` line;
- keep requests falsifiable;
- avoid broad claims;
- integrate accepted review into the plan body, not into endless comments;
- cite Commentdown IDs in commits instead of copying comment bodies;
- route a fresh review after material changes.

## Reviewer Discipline

Claude should:

- read the tail before replying;
- avoid acting on `cc:`;
- answer the latest routed request, not stale chat context;
- use `WATCH` for fixable concerns;
- use `FAIL` for blocked or unsafe work;
- keep findings concrete and file/path grounded;
- prefer cuts over extra process.

## Claims

Before edits, append `[CLAIM]` with:

- `replies:` parent ID, unless proactive;
- exact write scope;
- expected output;
- verification surface;
- forbidden areas.

If proactive, route to the arbitrator and explain why no prior request exists.

If stale, another actor may close it with `[FAIL]` or supersede it with a new
`[CLAIM]` citing evidence. Project profile owns TTL.

## Branch And Commit Profile

Recommended, not required:

- one branch per substantial work loop;
- frequent small commits;
- CD-only commit body may be empty;
- mixed commit body cites CD ID for decision context;
- never duplicate the full Commentdown entry in the commit message.

## Stop Conditions

Stop the loop when:

- maintainer closes the work;
- no routed requests remain;
- a hard gate blocks progress;
- the target file says `status: closed`;
- reviewer has repeated idle ticks with no new routed work.

## Common Failure Modes

- Agent replies to chat memory instead of latest `## Comments`.
- Reviewer treats `cc:` as assignment.
- Driver requests work without a primary route.
- Two agents claim the same files.
- Claims do not name forbidden areas.
- Review comments accumulate after plan body should be edited.
- Commit messages duplicate CD entries.
- Project-specific gates leak into reusable docs.

## Minimal Example

```markdown
## [REQ] c-20260509-120000-codex-driver-review-plan · Review draft plan
@claude-reviewer: review the plan for missing rollback and unsafe scope.

Plan is ready for review. Forbidden: runtime config and deploy scripts.

falsifies: rollback and unsafe-scope checks are already documented
tag: api-refactor

## [WATCH] c-20260509-121000-claude-reviewer-rollback · Add rollback gate
replies: c-20260509-120000-codex-driver-review-plan
@codex-driver: add rollback gate before activation.

Plan is close, but activation lacks a rollback condition.

falsifies: plan contains a rollback gate before activation
tag: api-refactor
```

For use, stop here. `## Comments` below is review history, not extra runbook.

## Comments

## [INFO] c-20260509-100152-codex-driver-readme-next · Optional loop runbook seeded
status: info
refs: AGENT-LOOP-RUNBOOK.md; COMMENTDOWN.md
cc: @maintainer; @claude-reviewer
tldr: Added an optional Codex-Claude loop recipe without baking it into core Commentdown.

This runbook explains the agent-to-agent operating pattern for projects using
the same stack. `COMMENTDOWN.md` remains the protocol; this file is a workflow
profile.

falsifies: the runbook is required to understand core Commentdown, or it leaks project-specific strategy/trading workflow
tag: a2a-runbook
