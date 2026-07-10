# Agent-to-Agent Loop Runbook

Practical recipe for running Codex `/goal` and Claude `/loop` together with
Commentdown.

Use this when one agent drives work and another reviews or takes bounded
sidecar tasks. This is the current practical Codex-Claude workflow; it is still
not Commentdown core.

## Roles

- `maintainer`: arbitrates scope, activation, promotion, and disputes.
- `codex-driver`: owns sequencing and integration.
- `claude-reviewer`: reviews plans, commits, and open Commentdown routes.
- `claude-driver`: takes bounded implementation only after a routed request or
  proactive claim allowed by the project profile.

Names are examples. Keep roles; rename handles per project.

## Mental Model

One markdown file is the coordination surface. Codex keeps the long-running
driver state in `/goal`; Claude wakes through `/loop`, reads the latest entries
(top of `## Comments` under newest-first; end of file under oldest-first),
replies with `PASS` / `WATCH` / `FAIL`, and only edits after a `CLAIM`.

Both agents keep chat context disposable by writing durable state into
`## Comments`.

## Runtime Hooks

For the Codex-Claude stack:

- Start Codex with `/goal` using the work file as durable state.
- Start Claude with `/loop` pointed at the same work file.
- Route each review or sidecar ask as a Commentdown `[REQ]`.
- Claude replies in Commentdown; Codex folds accepted changes into the work
  body or code, then routes the next tick when needed.

`/goal` and `/loop` are host affordances, not Commentdown syntax. Other stacks
can use the same entries with their own schedulers or prompts.

## Filing (where the comments live)

Comments live IN the artifact, not in a separate file. The "work file" IS the doc under
discussion — the PRD, plan, research doc, or spec — with a `## Comments (newest first)` section at
its bottom. Do not silo comments into a standalone `commentdown.md` or a comments-only folder; that
separates the discussion from the thing discussed. Keep one file until you genuinely need more (spec
§Threading). If a repo ships a helper (e.g. `scripts/cdown.py comment <doc> …`), use it to append.

## Setup

1. Pick one work file — the actual artifact being discussed (e.g. `dev/plans/<feature>.md`).
2. Add `commentdown:` frontmatter with handles.
3. Add `## Comments (newest first)` at the bottom (and `order: newest-first` in the frontmatter), or `(oldest first)` if you prefer the classic log.
4. Start Codex `/goal` against that file.
5. Start Claude `/loop` against that file when review or sidecar work is useful.
6. Add the first `[REQ]` from maintainer or Codex.
7. Name any forbidden paths, live systems, or approval gates in the request.
8. Put long prompts in prompt files, not in the work log.

## Loop

Each reviewer tick:

1. Read latest git status/log if the project uses git.
2. Read the latest entries at the position the file's declared order puts them
   (see spec §Order).
3. Find entries routed to your handle.
4. Check open `[CLAIM]` scopes before proposing edits.
5. Reply with one `PASS`, `WATCH`, `FAIL`, `INFO`, or `CLAIM` (or `ERRATA`
   with `errata_for:` when correcting a prior factual error).
6. If implementing, edit only the claimed scope.
7. Close or update the thread with evidence.

## Driver Discipline

Codex should:

- route asks with a single `@actor:` line;
- keep requests falsifiable (`falsifies: wrong if ...`);
- avoid broad claims;
- integrate accepted review into the plan body, not into endless comments;
- cite Commentdown IDs in commits instead of copying comment bodies;
- route a fresh review after material changes.

## Reviewer Discipline

Claude should:

- read the latest entries (per the file's declared order) before replying;
- avoid acting on `cc:`;
- answer the latest routed request, not stale chat context;
- use `WATCH` to accept direction while flagging follow-ups;
- use `FAIL` for blockers or unsafe work, even when the fix is easy;
- keep findings concrete and file/path grounded;
- assume other agents can inspect the repo; do not list obvious files or repeat
  context they can discover with search or git;
- skip praise, speed notes, and process recap;
- prefer cuts over extra process.

## Claims

Before edits, append `[CLAIM]` with:

- a primary `@<actor>:` route (responsive claims route to whoever the parent
  `[REQ]` asked; proactive claims route to the arbitrator);
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
- never duplicate the full Commentdown entry in the commit message;
- choose one home for detail: CD for coordination/rationale, commit for code
  delta.

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
- Comments include praise, timing commentary, or chat recap.
- Comments inventory obvious files, headings, or reading paths.
- Project-specific gates leak into reusable docs.

## Minimal Example

Shown oldest-first for reading flow; a real 1.3.1 document declares
`order` in frontmatter (default `newest-first`, latest entry on top).

```markdown
## [REQ] cd-20260509-120000-codex-driver-review-plan · Review draft plan
@claude-reviewer: review the plan for missing rollback and unsafe scope.

Plan is ready for review. Forbidden: runtime config and deploy scripts.

falsifies: wrong if rollback and unsafe-scope checks are already documented
tag: api-refactor

## [WATCH] cd-20260509-121000-claude-reviewer-rollback · Add rollback gate
replies: cd-20260509-120000-codex-driver-review-plan
@codex-driver: add rollback gate before activation.

Plan is close, but activation lacks a rollback condition.

falsifies: wrong if the plan contains a rollback gate before activation
tag: api-refactor
```

For use, stop here.
