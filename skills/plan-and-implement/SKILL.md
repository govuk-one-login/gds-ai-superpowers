---
name: plan-and-implement
kind: composite
description: >
  Take one user story from a prepared backlog through to reviewed, tested code on a
  branch by running the dev pipeline end to end: write the acceptance tests (the
  oracle), plan the implementation, dispatch a chosen model (a cheaper one by default)
  to write the code to green, then independently review the diff — each step gating past
  you, the human owning the merge. Use for "implement this story", "build this story end
  to end", "take this story to code", "run the dev pipeline". It is pure orchestration —
  it owns no test, plan, coding, or review logic of its own; it reads each atomic skill
  from disk and follows it. It does NOT merge (the human owns the merge gate), does NOT
  certify security or accessibility (named follow-on checks do), and does NOT decide
  breaking changes to shared APIs (those route back to the technical design process).
---

# Plan and Implement (composite)

You orchestrate the dev pipeline: one user story in, reviewed and tested code on a
branch out, every step gated by the human, who owns the merge. You are a **thin
recipe** — you sequence the atomic skills and hand the one story's artifacts (tests →
plan → code) from step to step. You contain **no** logic of your own: the test
authoring, the planning, and the model-tiered implementation all live in the atomic
skills you run. If you ever find yourself writing a test, a plan, or dispatching a
coder directly, that logic belongs in an atomic skill, not here.

This pipeline is the first that **crosses the architecture cap downward** — it writes
real code from a story. The cap held for designs and stories; here the developer's
level is reached deliberately, through the plan.

## What you run, and how

You run, against **one story**, in this **fixed order** (the last two are risk-tiered):

1. `../generate-acceptance-tests/SKILL.md` — story's criteria → failing
   acceptance tests (the oracle); human-gated.
2. `../generate-implementation-plan/SKILL.md` — story + tests + real code →
   the implementation plan (the human-gated contract); recommends the implementer model.
3. `../implement-plan/SKILL.md` — dispatch the chosen (default cheaper) model
   to write code to green against the gate suite; block-and-escalate; host verifies.
4. `../review-code/SKILL.md` — an independent fresh-context subagent reviews
   the diff (correctness, edge cases, reuse, idiom, and the cheap coder's vacuous tests);
   gated walk-back applies trivial fixes (re-gated) and routes substantive ones back.
5. `../review-security/SKILL.md` — the **security** lens on the diff (control-cited;
   realisation + new vulns), **risk-tiered**: runs when the diff is security-relevant,
   otherwise records a "Not Required" decision. Same gated walk-back.
6. `../review-accessibility/SKILL.md` — the **accessibility** lens on the diff
   (WCAG SC-cited; statically-detectable failures), **risk-tiered**: runs when the diff
   touches a UI surface, else "Not Required". Defers the runtime residue to the QA
   `accessibility-at-testing` slot. Same gated walk-back.

**Read-then-follow** (the `produce-tech-design` pattern): at each step, Read that
skill's `SKILL.md` and follow its workflow inline — scoping, work, and its gated steps.

## The one rule that diverges from autoplan: never auto-decide

Every gate a sub-skill raises — the acceptance-test sign-off, the plan approval, the
implementer-model confirmation, an Accept/Modify/Reject/Defer — goes to the human
unchanged. Your value is sequencing and continuity, not deciding on their behalf. The
merge gate, risk acceptance, and any shared-API breaking-change approval stay human /
architect decisions.

## Workflow

### 1. Intake
Confirm the inputs: one **user story** (with acceptance criteria and a "Grounds in"
block) and the **repo** to build in. Announce: the story in one line, the fixed
sequence (tests → plan → implement), that every step is human-gated, and that the
pipeline **stops at a reviewed branch — the human merges**. Ensure a story branch.

### 2. Step 1 — generate-acceptance-tests
Follow the skill against the story. Verify the **failing** acceptance tests exist and
were human-accepted as the spec before continuing. Emit a phase summary.

**Degraded-input path:** if the story has no acceptance criteria (or
`decompose-to-stories` emitted an ungrounded stub), **stop** — route back to
`prepare-stories`; there is no oracle to build against.

### 3. Step 2 — generate-implementation-plan
Follow the skill against the story + the approved tests. Verify the plan exists, is
human-approved, and carries a `recommended_implementer`. If it routed a **shared-module
breaking change** back to the technical design process, **stop** — that must be
approved in `produce-tech-design` first. Emit a phase summary.

### 4. Step 3 — implement-plan
Follow the skill against the approved plan. The dev confirms the implementer model; the
chosen model writes the code to green; the host independently verifies the gates and
that the oracle is intact. Emit a phase summary.

### 5. Step 4 — review-code
Follow the skill against the diff (story branch vs its base) + the acceptance criteria +
the approved plan. An independent fresh-context subagent reviews; you walk each finding
back gated — applying an approved trivial fix (then re-running the gate suite + confirming
the oracle is unchanged) or routing a substantive one back via
`generate-implementation-plan` → `implement-plan`. If a substantive finding routes back,
loop the relevant earlier steps and re-review. Verify the review report exists and every
finding has a disposition before continuing. Emit a phase summary.

### 6. Step 5 — review-security *(risk-tiered)*
Follow `../review-security/SKILL.md` against the diff + the acceptance criteria +
the **TD's Security Considerations** (the committed controls) + the accepted sizing. It
**tiers first**: if the diff touches no security-sensitive surface and the sizing is
None/Minor, it records "code-level security review: Not Required (reason)" and skips;
otherwise an independent fresh-context subagent reviews the diff through the security lens
(control-cited findings — realisation gaps + new vulns), and you walk each finding back
gated, exactly as for review-code (trivial fix applied + re-gated + oracle confirmed;
substantive routed back via `generate-implementation-plan` → `implement-plan`). Verify the
report exists (with the ran/Not-Required decision recorded) before continuing. Emit a phase
summary.

### 7. Step 6 — review-accessibility *(risk-tiered)*
Follow `../review-accessibility/SKILL.md` against the diff + the acceptance
criteria + the **a11y acceptance criteria `check-accessibility` added** to the UI-facing
stories. It **tiers first**: if the diff touches no UI surface, it records "code-level
accessibility review: Not Required (no UI surface)" and skips; otherwise an independent
fresh-context subagent reviews the diff through the WCAG lens (SC-cited findings —
statically-detectable failures), and you walk each finding back gated, exactly as for
review-security. It also returns a **"deferred to AT testing" list** — the runtime SCs to
verify later in the QA `accessibility-at-testing` slot. Verify the report exists (with the
ran/Not-Required decision and any deferred-to-AT list) before continuing. Emit a phase summary.

### 8. Consolidate and hand off
Close with: the branch, the implementer model used (and any escalation), the
host-verified gate results, the review findings and their dispositions (applied vs
routed), **whether review-security and review-accessibility ran or were risk-tiered out (and
why)**, the **deferred-to-AT accessibility list** to carry into QA, and what is **NOT** done
— the **human merge gate** and the QA-phase verification. State plainly that nothing was merged.

## The code-level checks are complete
The dev sequence ships end to end: generate-acceptance-tests → generate-implementation-plan →
implement-plan → review-code → review-security → review-accessibility → reviewed branch. The
three code-level review lenses (general / security / accessibility) are all built and wired;
the two specialised ones are risk-tiered. No code-level review slots remain. (The remaining
named follow-on is the **machine shared-module API-compat gate**, `ENG-API-1`, which
`generate-implementation-plan` already routes to the TD process; building it as a discrete
gate is a separate increment.) The running-UI / AT accessibility verification is the QA-phase
`accessibility-at-testing` slot, which consumes this pipeline's deferred-to-AT list.

## What this skill does NOT do
- It contains no test/plan/coding/review logic — orchestration only.
- It never auto-decides a gate — every sign-off / approval goes to the human.
- It does not merge, certify security/accessibility, or approve a breaking change.
- It does not run the steps out of order or in parallel — code builds on the approved
  plan, which builds on the human-accepted oracle.
