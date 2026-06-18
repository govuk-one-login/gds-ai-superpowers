---
name: generate-implementation-plan
description: >
  Turn one user story and its approved acceptance tests into a precise,
  code-grounded **implementation plan** that a developer — or a dispatched
  implementer model — can execute. Use this once a story has acceptance tests and is
  ready to build — phrases like "plan the implementation for this story", "how should
  we build this", "write the implementation plan", "turn this story into a build
  plan", or as the second step of the dev pipeline (`plan-and-implement`). This is the
  **first skill in the library that works BELOW the architecture cap**: it specifies
  the real files to change, the functions to add/modify, the approach, the exact
  quality-gate commands and coverage target, and a recommended implementer model — all
  grounded in the repo's real code and conventions. The plan is the **human-gated
  contract** the implementer is fenced by. It does NOT write code (that is
  `implement-plan`), does NOT write the acceptance tests (it reads them — that is
  `generate-acceptance-tests`), does NOT approve its own plan, and does NOT decide a
  breaking change to a shared API — it routes that to the technical design process.
---

# Generate Implementation Plan

You are acting as a senior engineer turning a story (with its acceptance tests
already written and signed off) into a plan precise enough that a **cheaper model can
execute it safely**. The plan is the expensive, careful, human-gated step; the code
that follows is the cheap, verifiable fill-in. So the plan must be concrete, grounded
in the real codebase, and complete enough to code from without mid-flight questions.

This is the point where the library **crosses the architecture cap downward**. The
Technical Design and the user stories deliberately stopped above function/line level;
the implementation plan is exactly that next level — files, functions, the approach —
done for one story. Go there; that is this skill's job.

Your job is to **produce the implementation contract**: what to change, how it's
verified, and which model should build it. Your job is **not** to write the code, the
acceptance tests, or to approve the plan, and **never** to authorise a breaking change
to a shared API.

## What you take as input
- **One user story** + its **approved acceptance tests** (from `generate-acceptance-tests`).
- **The repo's real code**, grounded via the project source map (`.claude/source-map.md`,
  discovered from the project root) plus the working repo — the same grounding
  discipline as `generate-design-doc`, one level deeper (functions, not just modules).

## Workflow

### 1. Ground in the real code
Find the **real files and functions** the story's "Grounds in" components map to. Name
existing functions to reuse, the ones to change, and the new ones to add. Every
reference must be a real symbol you found; if you can't ground something, mark it
`[gap]` rather than inventing it.

### 2. Discover conventions and the gate suite (read the repo; don't restate)
Derive, from the repo's **real config**, the ordered **quality-gate commands** the
implementer must run to green: `format → lint → type-check → unit tests → acceptance
tests → coverage`. Read what the repo actually defines (e.g. `package.json` scripts +
eslint/prettier/tsconfig/jest config; `build.gradle(.kts)` tasks; `.swiftlint.yml` +
the test/coverage settings; detekt/lint/Kover). Determine the **coverage target** for
the repo's tier (its source-map `kind`) from the engineering-way standard
(`../../_standards/engineering-way/testing.md`, `ENG-TEST-1`): the **hybrid bar** — the
project's `.claude/standards/` value if declared, else the engineering-way **reference default**
(backend 85 / web 90 / iOS 85 / Android 75). Cite the control, don't restate it, and
**report which source set the bar** (`[source: project .claude/standards]` vs
`[source: engineering-way reference default]`). If a gate the standard expects is missing or the
repo config is below bar, record it as a **finding** (standard bar vs repo config
mismatch) rather than silently skipping it.

### 3. Check shared-module API impact
If the repo is a **shared module** (declared in the source map), check whether the plan
touches its **public API**. **Additive/backward-compatible** → proceed. **Breaking**
(remove/rename a public symbol, change a public signature) → check whether the
**Technical Design that spawned this story approved the break**. If approved → plan it
with the recorded migration. If **not** approved → **HARD STOP**: do not plan the break.
Raise it as a finding routed back to the technical design process (`produce-tech-design`)
— breaking a shared contract is an architect decision, never a plan-time one.

### 4. Write the plan (the contract artifact)
A self-contained plan a developer or a dispatched implementer can read fresh:
- **Files & functions** — reuse / extend / new, each naming a real symbol.
- **Approach** — the steps, at function/file level (this is below the cap — be concrete).
- **Gate suite** — the exact ordered commands + the coverage target.
- **Do-not-touch** — the acceptance tests are the oracle; the implementer must not edit them.
- **`recommended_implementer: sonnet | opus`** — your reasoned model recommendation
  (stage 5).
- **Shared-module note** — additive / approved-break(+migration) / N/A.
- **Gaps & risks** — any `[gap]`, any finding routed elsewhere.

### 5. Recommend the implementer model (reasoned, not blank)
You have just assessed the work, so recommend the tier and say why: **lean cheap**
(sonnet) for routine CRUD, well-trodden patterns, localized changes with good local
examples; **lean strong** (opus) for concurrency, security-sensitive code, novel
algorithms, wide cross-cutting refactors, or anywhere the plan itself felt uncertain.
Record it as `recommended_implementer` with a one-line rationale; the dev confirms or
overrides at `implement-plan`. (The implementer also auto-escalates if a cheap attempt
blocks — so this is a starting tier, not a final commitment.)

### 6. Gated walk-through (the plan is the contract; the human approves it)
Walk the human through the **key decisions**, not every line: the reuse/extend/new
calls, any new function's responsibility, the approach for anything non-obvious, the
recommended model, each `[gap]`, and any shared-module finding. Ask **Accept / Modify /
Reject / Defer** per item; apply only what they approve; record dispositions. The plan
is the human-gated contract — this approval is the meaningful checkpoint (cheap to
review, costly to get wrong).

### 7. Output
Write the approved plan as an artifact (a file the implementer reads fresh — it runs in
isolated context, so the plan must be self-contained). Report its path, the recommended
model, any routed findings (shared-module breaks, gate mismatches), and hand off to
`implement-plan`.

## What this skill does NOT do
- It does not write code — that is `implement-plan` (via a dispatched implementer).
- It does not write the acceptance tests — it **reads** them (they're the oracle from
  `generate-acceptance-tests`).
- It does not approve its own plan — a human gates it (stage 6).
- It does not authorise a breaking change to a shared module's public API — it routes
  the decision to the technical design process and hard-stops until approved.
- It does not invent code it could not ground — it marks `[gap]` and surfaces it.
- It does not run the gate suite or implement to green — it **specifies** the gates;
  the implementer runs them.

## A note on validation
Validate against a story that was already built: plan it from the story + its tests,
then compare to what the developer actually did. A divergence (a missed file, an
invented function, a wrong gate command, a missed shared-API break, a mis-tiered model
recommendation) is the iteration backlog.
