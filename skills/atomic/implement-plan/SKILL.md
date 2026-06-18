---
name: implement-plan
description: >
  Execute an approved implementation plan by dispatching the coding to a chosen model
  — by default a cheaper implementer (e.g. Sonnet) fenced by the plan and the repo's
  quality gates — and drive it to green, with the capable host model supervising,
  verifying, and escalating. Use this once a story has an approved implementation plan
  and acceptance tests — phrases like "implement this plan", "build this story", "write
  the code for this plan", "run the implementer", or as the third step of the dev
  pipeline (`plan-and-implement`). It reads the approved plan, recommends/confirms the
  implementer model, dispatches a subagent (in write mode, model-pinned) to write the
  code + unit tests against the plan, runs the repo's full gate suite to green, and
  handles block-and-escalate — then the host **independently re-verifies** the result.
  It does NOT merge (a human owns the merge gate), does NOT let the implementer edit
  the acceptance tests (the oracle), does NOT trust the implementer's self-report (the
  host re-runs the gates), and the cheap implementer never decides escalation or a
  breaking change.
---

# Implement Plan

You are the **host** (a capable model) supervising the implementation of one story
from an approved plan. The thesis: the plan is the human-gated contract; the code is
the cheap, verifiable fill-in. So you dispatch the actual coding to the chosen
implementer model, fence it with the plan and the repo's gate suite, and you do not
trust it — you **independently verify** what it produced.

The dispatch mechanism this relies on (host dispatches a model-pinned subagent that
writes files, whose edits persist, returning a parseable result) is **proven** (the
design's Spike 0 / 0.5). Use it deliberately and keep the safety rails.

Your job is to **get the story implemented to green against the oracle, on a branch,
ready for review** — at the right model cost, recovering safely when the cheap path
blocks. Your job is **not** to merge, to let the implementer touch the oracle, or to
take the implementer's word that it passed.

## What you take as input
- The **approved implementation plan** artifact (from `generate-implementation-plan`)
  — including its `recommended_implementer`.
- The **approved acceptance tests** (the oracle) and the repo, on a **working branch**
  (one story per branch).

## Workflow

### 1. Confirm the implementer model (reasoned, with the dev)
Read the plan's `recommended_implementer` and its rationale. Present it to the dev:
"Plan recommends **<model>** because <reason> — use it, or override?" Default is the
plan's recommendation (cheap unless it flagged otherwise). The dev confirms or
overrides. Never dispatch a model the dev didn't agree to.

### 2. Ensure an isolated working branch
Confirm you are on a story branch, not the default branch. The implementer's edits land
on the working tree; the branch is what keeps the change reviewable and unmerged.

### 3. Dispatch the implementer (model-pinned, write mode)
Dispatch a subagent via the **Agent/Task tool** with `model: <confirmed>` and a
**focused, self-contained brief** (the subagent runs in isolated context — it sees only
this brief + what it reads from disk):
- the **plan artifact path** and the **acceptance test** path(s);
- "implement per the plan; write the code **and your own unit tests**";
- the **exact ordered gate commands** + the coverage target from the plan;
- "run the full gate suite and iterate until green";
- **"do NOT modify the acceptance tests — they are the oracle"** (hard rule);
- the **return contract**: exactly `DONE | files: <changed> | gates: <final results>`
  or `BLOCKED | <one line: what you tried and what is stuck>`.

For one story, no worktree is needed (it edits the branch). Only if implementing
multiple stories in parallel, dispatch each with `isolation: worktree`.

### 4. On BLOCKED — diagnose and recover (never paper over it)
A blocked implementer is the system working: it surfaced a problem instead of shipping
wrong code. Read the block payload and route by cause:
- **Plan gap** (the plan was ambiguous/incomplete) → refine the plan
  (`generate-implementation-plan`) and re-dispatch.
- **Capability block** (it implemented but couldn't make a genuinely hard part work) →
  **escalate**: re-dispatch the same brief with `model: opus` (the stronger coder).
- **Bad oracle** (the acceptance tests are contradictory/wrong) → route back to
  `generate-acceptance-tests` / the human — the tests are human-gated; the implementer
  must not "fix" them.
Use a **bounded retry budget** (e.g. ~2 cheap attempts) before escalating; record what
escalated and why.

### 5. On DONE — verify independently (do NOT trust the self-report)
The implementer's `DONE` is a claim, not proof. The host:
- **re-runs the full gate suite itself** and confirms green (format/lint/type/unit/
  acceptance/coverage at the tier bar);
- confirms the **acceptance tests are unchanged** (the oracle wasn't edited — diff/checksum);
- reads the **actual diff** from git.
If the host's independent run is not green, treat it as a block (stage 4), not a pass.

### 6. Output
A verified, tested change on the branch + the gate results the host re-confirmed.
Report: the implementer model used (and any escalation), the files changed, the
host-verified gate results, and confirmation the oracle is intact. Hand off to
`review-code` (and the security / accessibility checks) and ultimately the human merge
gate.

## What this skill does NOT do
- It does not merge. The human owns the merge gate (per CLAUDE.md); this skill stops at
  a reviewed, verified branch.
- It does not let the implementer edit the acceptance tests. That hard rule is in the
  brief, and the host re-checks the oracle is unchanged on DONE.
- It does not trust the implementer's self-report — the host **re-runs the gates**
  before believing a green.
- The cheap implementer does not decide escalation, accept risk, or authorise a
  breaking change — those are the host's / the architect's / the human's.
- It does not invent the gate commands — it uses the ones the plan specified (which
  `generate-implementation-plan` discovered from the repo).

## A note on validation
Validate against a story that was already built: run the implement step from its
approved plan and compare the produced diff (and the model cost, and any escalations)
to what the developer actually shipped. Where the cheap path produced wrong or
non-idiomatic code that the gates didn't catch, that is the iteration backlog — tighten
the plan's completeness and the host's verification, and feed the miss to `review-code`.
