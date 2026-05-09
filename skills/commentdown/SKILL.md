---
name: commentdown
description: "Read and write Commentdown 1.2 entries in markdown. Use when posting CD [REQ]/[CLAIM]/[DEC]/[PASS]/[WATCH]/[FAIL]/[INFO]/[ERRATA] comments, generating c-... IDs, threading with replies:/closes:, routing via @actor:, or working in files with commentdown: frontmatter."
---

# Commentdown

Append-only structured comments in markdown. One log per file under `## Comments`. Each entry: heading badge says kind, ID says who/when, route says who acts next, threading via `replies:` / `closes:`, `falsifies:` keeps claims honest, `tag:` clusters topics.

## Before writing — read the room

1. Find `## Comments` in the target file.
2. Read `commentdown:` frontmatter for `version`, `profile`, `registry.handles`, and `arbitration` rules. Routes must use exact registered handles.
3. Scan the latest open `[REQ]` / `[WATCH]` / `[CLAIM]` and entries routed at your handle.
4. If responding to an existing entry, set `replies:` to its ID. If the work closes a thread, also set `closes:`.

## Generating the ID — never guess

Comment IDs are clock-sourced, never hand-authored. Use the bundled helper:

```bash
python3 scripts/cd_id.py <author> <slug> [collision]
# → c-20260509-114640-claude-reviewer-test-slug
```

Resolve `scripts/cd_id.py` relative to this skill directory.

`<author>` is your registered handle (with or without `@`). `<slug>` is `^[a-z0-9-]+$`, lowercased, ≤ ~16 chars, semantic. `[collision]` is `1..99`, only when another entry already shares the second-resolution timestamp + author + slug.

POSIX fallback when Python is unavailable:

```bash
date -u +'c-%Y%m%d-%H%M%S-<author>-<slug>'
```

## Writing the entry

Append at the end of the file (under `## Comments`). Never edit a prior entry — use `[ERRATA]` with `errata_for:` for factual corrections.

Use a heredoc; **do not** use editor-style rewrites when other agents may be appending to the same file:

```bash
cat >> path/to/file.md <<'EOF'

## [REQ] c-20260509-114640-claude-reviewer-test-slug · One-line title
@codex-driver: single sentence naming the next action.

Body. Lead with the delta. Concrete over abstract. File:line evidence inline.

falsifies: <what evidence would overturn this entry>
tag: <topic-cluster>
EOF
```

After appending, re-run `git status` and commit standalone (CD-only commits keep the audit trail clean).

## Required vs optional fields

**Always required**: heading (`## [VERDICT] <id> · <title>`), body, `falsifies:`, `tag:`.

**Conditionally required**:
- `@<actor>:` — required on `[REQ]`, `[CLAIM]`, `[DEC]`. One primary route only. `cc:` is FYI, not assignment.
- `errata_for:` — required on `[ERRATA]`.

**Optional** (recommended for long bodies): `status:`, `refs:`, `replies:`, `closes:`, `cc:`, `tldr:`, `due_by:`.

In **strict** profile, `status:` and `refs:` (or `refs: none`) become mandatory. Check the file's `commentdown.profile` — default is `minimal`.

Optional fields must earn their keep. Skip `refs:`, `cc:`, `tldr:`, file names,
or reader directions when they only repeat what the heading, route, body, git
diff, or local filesystem already show.

## Verdict choice

| Want to | Use |
|---|---|
| Ask another actor to do something | `[REQ]` |
| Take a piece of in-flight work | `[CLAIM]` |
| Record a binding decision | `[DEC]` |
| Accept and close a reviewer concern | `[PASS]` |
| Accept directionally but flag follow-ups | `[WATCH]` |
| Reject or block | `[FAIL]` |
| Report state, no verdict | `[INFO]` |
| Correct a factual error in a prior entry | `[ERRATA]` (with `errata_for:`) |

For default `status:` per badge, claim discipline (responsive vs proactive), threading rules, registry mechanics, append-only contract, git profile, and the full common-mistakes list, see `references/spec.md`.

## Style

- Lead with the delta. Skip pleasantries.
- Concrete over abstract: `polling, seen=482, age=0.4min` beats "watchdog looks fine".
- One fact, one owner. Verdict lives in the heading badge; topic in `tag:`; primary route in `@<actor>:`. Don't restate them in prose.
- Preserve coordination facts that are easy to lose; don't duplicate facts agents can discover with file search or git diff.
- Keep `falsifies:` honest and concrete — it converts a vibe into a falsifiable claim.
- Avoid CD cruft: skip the post if you have nothing material to add since the last entry.

## Worked example: respond to a routed request

You see this in the file:

```markdown
## [REQ] c-20260509-095322-reviewer-api-plan-req · API refactor review
@codex-driver: add rollback criteria and unsafe-scope notes before implementation.
…
tag: api-refactor
```

After shipping the work in a separate commit, append a closing `[INFO]` (or `[PASS]` if reviewing):

```bash
ID=$(python3 scripts/cd_id.py codex-driver api-rollback-added)
cat >> docs/API-REFACTOR.md <<EOF

## [INFO] $ID · API rollback criteria added
status: info
refs: docs/API-REFACTOR.md
closes: c-20260509-095322-reviewer-api-plan-req

Rollback criteria and unsafe-scope notes are now explicit before implementation.
Body includes concrete file:line evidence and verification commands.

falsifies: docs/API-REFACTOR.md lacks rollback criteria or still allows runtime config edits
tag: api-refactor
EOF
git add docs/API-REFACTOR.md
git commit -m "docs: cd api rollback criteria"
```

## What this skill is NOT

- Not the spec. The spec at `https://github.com/j-greig/commentdown` is authoritative; this skill is a how-to for agents writing valid entries.
- Not project-specific. Per-project safety gates (which paths are protected, which actors can promote, which writes are forbidden) live in that project's own docs/frontmatter, not here.
- Not an orchestrator. Skill helps you write one entry correctly; coordination across multiple entries / files / plans is the agent loop's job.

## Deeper reference

Read `references/spec.md` when:

- Working in a `strict` profile and unsure which fields become mandatory.
- Posting an `[ERRATA]` and need the correction-vs-revision rules.
- Authoring a proactive `[CLAIM]` (no parent `[REQ]`) and need the arbitrator-routing rule.
- Editing the `commentdown:` registry mid-thread (requires arbitrator `[DEC]`).
- Debugging a "badge and `status:` disagree" issue.
- Reading the full common-mistakes checklist before publishing a CD-bearing repo.
