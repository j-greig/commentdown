# Commentdown 1.2 — Deeper Reference

The minimal-profile how-to is in `SKILL.md`. This file covers the rules that don't fit there: profiles, full verdict semantics, claim discipline, registry mechanics, threading, append-only contract, git, and the common-mistakes checklist.

Authoritative spec: <https://github.com/j-greig/commentdown/blob/main/COMMENTDOWN.md>. This file paraphrases for fast agent lookup; if it disagrees with the spec, the spec wins.

## Table of contents

1. Profiles (minimal vs strict)
2. Verdicts — full table with default `status:`
3. Field ownership — one fact, one owner
4. ID format and rules
5. Registry mechanics
6. Routing rules
7. Claim discipline (responsive vs proactive)
8. Threading (`replies:` / `closes:` / `tag:`)
9. Append-only contract and `[ERRATA]`
10. Privacy and trust
11. Git profile
12. Common mistakes checklist

---

## 1. Profiles

`commentdown.profile: minimal | strict` — default `minimal`.

| Field / behaviour | minimal | strict |
|---|---|---|
| `status:` | optional (inferred from badge) | mandatory; must match badge default |
| `refs:` | optional | mandatory (`refs: none` if no evidence) |
| Registry validation | best-effort | required; unknown handles invalid |
| Badge/status consistency | best-effort | enforced |
| Lint tooling | optional | expected when tooling exists |

In minimal profile, agents stay productive without ceremonial fields. In strict profile, parsers and lint tooling can rely on completeness.

Optional fields must earn their keep. Do not add `refs:`, `cc:`, `tldr:`, file
names, or reader directions just to restate what the heading, route, body, git
diff, or local filesystem already make obvious.

## 2. Verdicts — full table

| Badge | Meaning | Default `status:` |
|---|---|---|
| `REQ` | request action | `request` |
| `CLAIM` | take bounded work | `claim` |
| `INFO` | report state, no verdict | `info` |
| `WATCH` | accept direction but require attention | `review` |
| `FAIL` | reject or block | `review` |
| `PASS` | accept and close reviewer concern | `review` |
| `DEC` | record binding decision | `decision` |
| `ERRATA` | correct prior factual error | `errata` |

Badge wins if badge and `status:` disagree.

## 3. Field ownership

One fact, one owner. Don't restate the same fact in two places.

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
| Closure target | `closes:` |
| Due date | `due_by:` |
| Correction target | `errata_for:` |
| Falsifier | `falsifies:` |

Assume agents can inspect the repo with filesystem and git tools. Preserve
coordination facts that are easy to lose; do not inventory obvious files,
headings, or reading paths.

## 4. ID format and rules

`c-YYYYMMDD-HHMMSS-<author>-<slug>[-NN]`

- UTC, second resolution. **Clock-sourced. Never invented.**
- `<author>` is the registered handle without `@`.
- `<slug>` is `^[a-z0-9-]+$`, lowercased.
- `-NN` two-digit collision suffix only when another entry already exists with the same `c-YYYYMMDD-HHMMSS-<author>-<slug>` prefix.

Use `scripts/cd_id.py` (Python) or `date -u +'c-%Y%m%d-%H%M%S-<author>-<slug>'` (POSIX).

## 5. Registry mechanics

Document declares actors via frontmatter:

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

- `arbitrator` — resolves authority, profile, registry, and spec disputes.
- `driver` — sequences work.
- `reviewer` — checks work.
- `implementer` — takes scoped edits.

Every project needs at least one arbitrator.

**Registry edits mid-thread require an arbitrator `[DEC]` and the registry edit in the same change.** Don't silently add or rename handles.

## 6. Routing rules

- `[REQ]`, `[CLAIM]`, `[DEC]` require **one** primary `@<actor>:` route.
- `cc:` is FYI only — not a work assignment.
- Exact registered handles win. Role aliases ("any reviewer") are invalid unless the registry defines a broadcast handle.
- Unregistered primary routes are ambiguous — refuse to act on them; ask the arbitrator to register the handle first.

## 7. Claim discipline

Use `[CLAIM]` before editing. Body must name:

- exact write scope (paths, scripts, docs);
- expected output artifact;
- verification surface (test command, browser route);
- forbidden areas that remain out of scope.

**Responsive claim**: has `replies:` pointing to the parent `[REQ]`.

**Proactive claim**: no `replies:`. Must route to an arbitrator and explain in the body why the work was not requested first.

Do not claim overlapping write scopes. If another agent has already claimed the same path or task, reply to that claim or supersede it via a new `[CLAIM]` citing concrete evidence.

Stale claims may be closed by `[FAIL]` or superseded by a new `[CLAIM]`. Profiles define TTL; minimal has no automatic TTL.

## 8. Threading

- `replies:` links to one parent comment ID.
- `closes:` marks one request or claim closed.
- `tag:` clusters topic across entries / files.
- IDs are intended to be repo-unique.
- Keep one CD file (single `## Comments` section) until multiple files are actually needed.

File order is the physical log. Tools may present thread order by `replies:` and ID timestamp; do not require sorted rewrites after merges.

## 9. Append-only contract

Existing entries are immutable except:

- secret redaction (with explicit `[REDACTED]` marker in place);
- factual correction via `[ERRATA]` with `errata_for: c-X` — the original is **never edited**.

Do not rewrite history to make a chain look cleaner. The thread is the audit trail. Reader policy: when displaying `c-X`, scan forward for any entry with `errata_for: c-X` and merge the errata body in as a footnote.

## 10. Privacy and trust

CD is an audit convention, not authentication. Do not put credentials, customer PII, private keys, or unsafe operational instructions in CD.

Use opaque refs for private evidence:

```text
refs: private://incident-123
```

## 11. Git profile

Git is optional.

- **CD-only commit**: short subject naming doc or comment ID; body may be empty.
- **Mixed code/docs commit**: summarize code delta in the commit message; cite the CD ID.
- **Link, do not paste, CD bodies into commit messages.**

When multiple agents may edit the same markdown file, prefer mechanical heredoc append over editor-style rewrites, and re-check `git status` immediately before committing.

## 12. Common mistakes checklist

Before publishing a CD-bearing repo, verify the following are absent:

- [ ] No `## Comments` section in a CD-governed file.
- [ ] Vague `falsifies:` (must be concrete and overturning evidence).
- [ ] Route in body but no `@<actor>:` line.
- [ ] `[REQ]`, `[CLAIM]`, or `[DEC]` without a primary route.
- [ ] `cc:` treated as work assignment.
- [ ] Badge and `status:` disagree.
- [ ] Optional fields repeat obvious file names, routes, summaries, or reader steps.
- [ ] Comment inventories files, headings, or reading paths instead of recording a coordination fact.
- [ ] Project-specific gate written as core syntax (move to project docs/frontmatter).
- [ ] Commit body duplicates CD body.
- [ ] Proactive claim without arbitrator route.
- [ ] Registry changed without an arbitrator `[DEC]` in the same edit.

## Parking lot (informational; not part of the spec to write against)

Future tooling, not required for adoption: `commentdown id`, `commentdown lint`, `commentdown sort`, conformance corpus, pre-commit / CI append-only checks, migration helper. Don't depend on these existing.
