---
title: Commentdown 1.2
status: draft
description: Terse project-agnostic Commentdown 1.2 spec.
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

# Commentdown 1.2

Append-only structured comments in markdown for multi-actor project work.

Mental model: `## Comments` is the log; badge says kind; ID says who/when;
route says who acts next; `replies:`/`closes:` thread work; `falsifies:` keeps
claims honest; `tag:` clusters topics.

## Agent Start

1. Find `## Comments`.
2. Read `commentdown.registry.handles`.
3. Scan latest `[REQ]`, `[WATCH]`, open `[CLAIM]`, and entries routed to you.
4. If doing work, append `[CLAIM]` before edits.
5. If replying, set `replies:` to the parent ID.
6. If closing work, set `closes:` to the opened request or claim.
7. Never rewrite prior entries. Use `[ERRATA]`.

## Minimal Entry

```markdown
## [REQ] c-20260509-120000-maintainer-api-plan · Scope API refactor
@codex-driver: propose the smallest safe refactor plan.

Need a plan that preserves current routes and names risky files.

falsifies: the current API already has a documented refactor plan with owners
tag: api-refactor
```

Required:

- heading with verdict, ID, title;
- body;
- `falsifies:`;
- `tag:`.

Conditionally required:

- `@<actor>:` on `[REQ]`, `[CLAIM]`, `[DEC]`;
- `errata_for:` on `[ERRATA]`.

Optional: `status:`, `refs:`, `replies:`, `closes:`, `cc:`, `tldr:`, `due_by:`.

## Profiles

`commentdown.profile: minimal | strict`

Default: `minimal`.

`minimal`: human-readable protocol. Optional metadata stays optional.

`strict`: parser-friendly protocol. Requires `status:`, `refs:` or
`refs: none`, registry validation, badge/status consistency, and lint when
tooling exists.

## Entry Locus

All entries live under one reserved `## Comments` heading at the bottom of the
file.

## Shape

```text
## [<verdict>] c-YYYYMMDD-HHMMSS-<author>-<slug>[-<nn>] · <scan title>
status: <enum>                            # strict; optional in minimal
refs: <evidence refs | none>              # strict; optional in minimal
@<actor>: <single next action>            # required on REQ/CLAIM/DEC
replies: c-...                            # optional parent
closes: c-...                             # optional close target
cc: @actor1, @actor2                      # optional FYI
tldr: <one-line parser summary>           # optional for long bodies
due_by: YYYY-MM-DDTHH:MM:SSZ              # optional on REQ
errata_for: c-...                         # required on ERRATA

<body>

falsifies: <concrete evidence that would overturn this entry>
tag: <topic-cluster>
```

## Verdicts

| Badge | Meaning | Default status |
|---|---|---|
| `REQ` | request action | `request` |
| `CLAIM` | take bounded work | `claim` |
| `INFO` | report state | `info` |
| `WATCH` | accept direction but require attention | `review` |
| `FAIL` | reject or block | `review` |
| `PASS` | accept and close reviewer concern | `review` |
| `DEC` | record binding decision | `decision` |
| `ERRATA` | correct prior factual error | `errata` |

`status:` is optional in minimal profile. If absent, infer from badge.

In strict profile, `status:` is mandatory and must match the badge default
unless the adopter profile narrows the mapping. If badge and `status:`
disagree, badge wins.

## Field Ownership

| Fact | Owner |
|---|---|
| Verdict | heading badge |
| Author | ID author segment |
| Timestamp | ID timestamp |
| Topic | `tag:` |
| Primary route | `@<actor>:` |
| FYI route | `cc:` |
| Evidence dependency | `refs:` |
| Evidence interpretation | body |
| Summary | `tldr:` |
| Parent | `replies:` |
| Closure | `closes:` |
| Due date | `due_by:` |
| Correction target | `errata_for:` |
| Falsifier | `falsifies:` |

One fact, one owner. Other fields may help scanning, not override.

## IDs

Format: `c-YYYYMMDD-HHMMSS-<author>-<slug>[-<nn>]`

Rules:

- UTC, second resolution.
- Clock-sourced. Never invented.
- `<author>` is the registered handle without `@`.
- `<slug>` is lowercase `^[a-z0-9-]+$`.
- `-NN` is only for same-second collision.

Portable sources:

```bash
date -u +'c-%Y%m%d-%H%M%S-<author>-<slug>'
```

```python
import re, sys
from datetime import UTC, datetime

SLUG = re.compile(r"^[a-z0-9-]+$")
author, slug = sys.argv[1].lstrip("@"), sys.argv[2].lower()
suffix = "" if len(sys.argv) < 4 else f"-{int(sys.argv[3]):02d}"
if not (SLUG.fullmatch(author) and SLUG.fullmatch(slug)):
    raise SystemExit("author/slug must match ^[a-z0-9-]+$")
if suffix and not (1 <= int(sys.argv[3]) <= 99):
    raise SystemExit("collision must be 1..99")
print(f"c-{datetime.now(UTC):%Y%m%d-%H%M%S}-{author}-{slug}{suffix}")
```

## Registry

```yaml
commentdown:
  version: "1.2"
  profile: minimal
  registry:
    handles:
      maintainer: {kind: human, role: arbitrator}
      codex-driver: {kind: agent, role: driver}
      claude-reviewer: {kind: agent, role: reviewer}
    arbitration:
      spec_changes: maintainer
```

Roles:

- `arbitrator`: resolves authority, profile, registry, and spec disputes.
- `driver`: sequences work.
- `reviewer`: checks work.
- `implementer`: takes scoped edits.

Every project needs at least one arbitrator.

Registry edits mid-thread require an arbitrator `[DEC]` and the registry edit
in the same change.

## Routing

- `[REQ]`, `[CLAIM]`, `[DEC]` require one primary route.
- `cc:` is FYI only.
- Exact registered handles win.
- Role aliases and broadcast handles are invalid unless registry defines them.
- Unregistered primary routes are ambiguous.

## Claims

Use `[CLAIM]` before editing.

Body names exact write scope, output artifact, verification surface, and
forbidden areas.

Responsive claim: has `replies:`.

Proactive claim: no `replies:`. It must route to an arbitrator and explain why
the work was not requested first.

Stale claims may be closed by `[FAIL]` or superseded by a new `[CLAIM]` citing
evidence. Profiles define TTL.

## Threading

- `replies:` links to one parent.
- `closes:` marks one request or claim closed.
- `tag:` clusters a topic across entries/files.
- IDs are intended to be repo-unique.
- Keep one CD file until multiple files are actually needed.

## Append-Only

Never edit prior entries except secret redaction or factual correction.

`[ERRATA]` appends a correction and requires `errata_for:`.

File order is the physical log. Tools may present thread order by `replies:`
and ID timestamp. Do not require sorted rewrites after merges.

## Privacy And Trust

CD is an audit convention, not authentication.

Do not put credentials, customer PII, private keys, or unsafe operational
instructions in CD.

Use opaque refs for private evidence:

```text
refs: private://incident-123
```

## Git Profile

Git is optional.

- CD-only commit: short subject naming doc or comment ID; body may be empty.
- Mixed code/docs commit: summarize code delta; cite CD ID.
- Link, do not paste, CD bodies into commit messages.

## Common Mistakes

- No `## Comments`.
- Vague `falsifies:`.
- Route in body but no `@<actor>:` line.
- `[REQ]`, `[CLAIM]`, or `[DEC]` without primary route.
- `cc:` treated as work assignment.
- Badge and `status:` disagree.
- Project-specific gate written as core syntax.
- Commit body duplicates CD body.
- Proactive claim without arbitrator route.
- Registry changed without `[DEC]`.

## Parking Lot

Future tooling, not required for adoption:

- `commentdown id`
- `commentdown lint`
- `commentdown sort`
- conformance corpus
- pre-commit / CI append-only checks
- migration helper

For use, stop here. `## Comments` below is review history, not extra spec.

## Comments

## [INFO] c-20260509-100152-codex-driver-readme-claim · Spec extract seeded
This spec keeps the agent-critical rules and drops proposal-thread history.

falsifies: this extract loses a rule needed for agent-to-agent operation or keeps source-project-specific workflow
tag: oss-spec

## [REQ] c-20260509-130342-codex-driver-final-agnostic-review · Final agnosticism pass
@claude-reviewer: do one final terse review for project-agnostic adoption, agent grokability, and avoidable ceremony.

Please prefer cuts or wording swaps over new machinery. Check whether a fresh
agent could copy the convention, rename handles, choose local safety gates, and
start using it without a validator or service.

falsifies: a fresh agent cannot adopt Commentdown from these docs without importing project-specific assumptions or unnecessary process
tag: oss-spec
