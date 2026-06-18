---
name: assure-quality
description: >
  Run the QA phase on a built story: verify the running, integrated software does what
  the story's acceptance criteria promised, and leave durable end-to-end tests behind.
  Use for "QA this story", "assure quality", "run the QA phase", "verify the built
  feature works", "do we have enough e2e tests" — the verification phase after the
  implementation is done. It is the **QA-phase entry point** of the library (the SDLC
  arc: architecture → breakdown → implementation → QA), and pure orchestration — it owns
  no verification logic of its own; it reads each atomic skill from disk and follows it.
  It does NOT merge (the human owns the merge gate), does NOT fix product code (defects
  route back to the dev pipeline as failing tests), and does NOT certify release.
---

# Assure Quality (composite)

You orchestrate the **QA phase**: a built story in, a verified running build + durable
e2e coverage out, every step gated, the human owning the merge. You are a **thin
recipe** — you sequence the QA atomics and hand the one story's verification state from
step to step. You contain **no** verification logic of your own: the driving, the
test codification, the defect classification all live in the atomic skills you run.

This composite is the **discoverable front door for the QA phase**, alongside
`produce-tech-design` (architecture), `prepare-stories` (breakdown), and
`plan-and-implement` (implementation). It begins with `verify-story` and grows as more
QA atomics are built (regression, performance, exploratory, assistive-tech testing) —
that is why it is a composite even while it sequences one atomic today: it is a phase,
not a wrapper.

## Phase boundary
QA verifies the **running** build. Code-level concerns — `review-code` and the
code-level security/accessibility checks on the diff — belong to the **implementation**
phase (`plan-and-implement`), before QA. This composite starts once there is a built,
reviewed branch and a running target.

## What you run, and how

Against **one built story**:

1. `../../atomic/verify-story/SKILL.md` — drive the running build per acceptance
   criterion (driver by `kind`), verify by writing durable e2e tests, classify
   failures, and route confirmed defects back to the dev pipeline as failing tests.

**Read-then-follow** (the `produce-tech-design` pattern): Read that skill's `SKILL.md`
and follow its workflow inline — its driver selection, its drive/codify loop, its
failure classification, and its gated defect routing.

## The one rule that diverges from autoplan: never auto-decide

Every gate a sub-skill raises — a defect's Accept/Modify/Reject/Defer, a flagged
coverage gap, an unmet driver/target prerequisite — goes to the human unchanged. Your
value is sequencing and continuity, not deciding on their behalf. The merge gate and
release sign-off stay the human's.

## Workflow

### 1. Intake
Confirm the inputs: one **built story** (its acceptance criteria + "Grounds in"
surface), on the dev pipeline's story branch, and a **running target** (provided is the
primary path). Announce: the story in one line, the phase (QA), and that it **stops at a
verified branch — the human merges**.

**Degraded-input path:** if there is no running target and one can't be stood up, or the
story's driver isn't wired for its `kind`, **stop and flag the prerequisite** — QA can't
verify a system it can't run.

### 2. Step 1 — verify-story
Follow `../../atomic/verify-story/SKILL.md` against the built story + the running target.
Verify the report exists, every acceptance criterion has a result (verified-automated /
verified-manual-gap / failed), and any confirmed defects were routed back as failing
tests. Emit a phase summary.

### 3. Consolidate and hand off
Close with: the per-criterion verification results, the e2e tests committed, the
coverage assessment + any flagged gaps, the routed defects awaiting fix, and what is
**NOT** done — release sign-off and the **merge** (human). If defects were routed, note
that re-verification follows once the dev pipeline's fix lands.

## Later slots (named, not built yet)
The QA phase grows by adding atomics here as they are built:
- `regression-suite` — re-run the e2e set across the affected area, not just the story.
- `performance-test` — verify the story's NFRs (latency/throughput) on the running build.
- `exploratory-qa` — unscripted probing beyond the acceptance criteria.
- `accessibility-at-testing` — assistive-technology verification on the running UI
  (rendered contrast, real screen-reader announcement, live focus order/traps). It
  consumes the **deferred-to-AT list** `review-accessibility` produces in the dev pipeline —
  the runtime WCAG residue a static diff review can't confirm.

## What this skill does NOT do
- It contains no verification logic — orchestration only.
- It never auto-decides a gate — every disposition goes to the human.
- It does not merge, certify release, or fix product code (defects route back to the dev
  pipeline as failing tests).
- It does not run code-level review/checks — those are the implementation phase.
