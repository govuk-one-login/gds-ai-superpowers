---
name: review-code
description: >
  Independently review the implemented diff from the dev pipeline — a separate Claude
  subagent with fresh context reads the code cold (diff + the story's acceptance criteria
  + the approved plan) and flags the bugs, edge cases, non-idiomatic patterns, and
  **tautological unit tests** a careful human reviewer would. Use once a story has been
  implemented to a green branch — "review this code", "review the diff", "code review",
  "check the implementation", or as the review step of the dev pipeline
  (`plan-and-implement`) after `implement-plan`. It runs entirely on-machine (nothing
  leaves the estate), returns structured findings, and walks them back gated: the host
  applies an approved trivial fix (then re-runs the gate suite + confirms the oracle is
  unchanged), and routes substantive findings back through the plan. It is the GENERAL
  correctness/quality lens — it does NOT re-do the security or accessibility checks (those
  are the sibling slots), does NOT merge, does NOT let the reviewer edit anything, and the
  reviewer never accepts risk on the human's behalf.
---

# Review Code (review-code)

You orchestrate an **independent review of an implemented diff by a separate Claude
subagent with fresh context** — the value is a reviewer that did not write the code and
has not seen the implementer's running reasoning, so it judges the diff on its merits,
as a careful human reviewer would rather than as the author defending it. You run the
review, present its findings, and walk them back into the branch **gated**. You never
let the reviewer edit files, and you never accept its suggestions on the dev's behalf.

The review runs **locally** — a Claude subagent dispatched with the Agent tool. Nothing
is sent to an external service.

## The thesis: `cross-model-review`, pointed at a diff

This reuses the `cross-model-review` machinery — fresh-context, local, independent,
**read-only** reviewer; structured findings; gated write-back — with **one material
addition** that skill deliberately omits: a **host-applied trivial-fix path** (Step 3).
That apply path is the genuinely new mechanism here, and the one with the risk; treat it
with the same verify-then-believe discipline `implement-plan` uses, not as an
afterthought.

**Why an apply step is allowed here when two sibling skills look like they forbid it:**
- `cross-model-review` is read-only — and the **reviewer subagent stays read-only here
  too**. What's new is the **host** applying a fix the **human approved**. The doctrine
  ("skills draft and flag; humans approve and accept") holds — what changed is the host's
  *hand*, not the *decision*.
- `verify-story` "never fixes product code" because it is **QA-phase**, acting on a
  *done* build. `review-code` is **implementation-phase**: it edits the diff *under
  review, pre-merge* — only a fix the human accepted, with the gate suite re-run after.
  Different phase, different rule — not a contradiction.

## What you take as input
- The implemented **diff** — the **story branch vs its base** (the branch point; one
  story per branch).
- The **story's acceptance criteria** (so the reviewer can judge "does this satisfy the
  contract").
- The **approved implementation plan** (from `generate-implementation-plan`).

## The dimensions it reviews
A single structured review across:
- **Correctness & bugs** — logic errors, off-by-one, null/None handling, error paths.
- **Edge cases** — the unhappy paths the story/criteria imply but the diff may skip.
- **Test quality (the specific mandate)** — the cheap implementer wrote its own unit
  tests, and coverage % guards quantity, not assertion quality. Check **each
  implementer-authored test against the anti-pattern checklist** below — a general "is
  this test good?" prompt under-triggers here. Also: does the diff genuinely satisfy the
  acceptance tests' intent (not just pass them)?
- **Reuse / simplification** — duplicated logic, a simpler formulation, an existing
  utility that should have been used.
- **Idiom / convention** — does it match the codebase and the project's conventions
  (discovered from config, same as the dev pipeline)?

It does **not** re-do the specialised checks: the code-level **security** review is
`review-security` and the code-level **accessibility** review is `review-accessibility`
(both built; `check-security-standards` / `check-accessibility` are their design-level
siblings). `review-code` is the **general** correctness/quality lens beside them.

### The test anti-pattern checklist (the reason this skill exists over green gates)
A green gate proves the tests *pass*, not that they *test anything*. For each
implementer-authored unit test, the reviewer flags:
- **assertion-free** — no assertion, or only `assert True` / a bare "it ran" check.
- **asserts-the-mock** — asserts a value the test itself configured on a mock, not real
  behaviour of the code under test.
- **asserts-a-constant** — asserts a hard-coded literal that can't fail unless the test
  is deleted.
- **re-derives-the-expected** — recomputes the function's own logic to produce the
  "expected" value and compares it to itself (always passes, tests nothing).

## Workflow

### 1. Scope + effort
Compute the diff — the **story branch vs its base** (the branch point; one story per
branch; `git diff <base>...HEAD`). Pick the review **effort**:
- **low** = high-confidence correctness/bug findings only.
- **med** = + edge cases, test quality, reuse. **(default)**
- **high** = all dimensions + lower-confidence "worth a look" findings.

**Auto-escalate to high** on a risky diff — when it touches a path in the project's
**source-map shared-module / public-API list**, or matches the project's declared
**security-sensitive path globs**. A manual effort override is always available.

> **v1 fallback:** if the project hasn't declared those risk signals yet, ship **single
> `med` effort** (no auto-escalate). The tiering slots in once the signals are wired —
> the build never blocks on them.

### 2. Dispatch the independent reviewer (read-only, fresh context)
Spawn a subagent (Agent tool, fresh context) and give it: the **reviewer persona**, the
**base ref** (so it computes the diff itself), the **acceptance criteria** + the
**approved plan** for context, the **dimensions**, the chosen **effort level**, and the
**test anti-pattern checklist**. Ask for findings only — it must not edit anything.

It must return findings in an **exact machine-parseable format** — one finding per line
as JSON, so triage is mechanical, not prose-scraping:

```
{"dimension": "...", "location": "file:line", "severity": "critical|high|medium|low", "issue": "...", "proposed_fix": "...", "confidence": "high|medium|low"}
```

Tell it: this is an **architecture-cap-and-below** code review (the diff is real code);
verify reuse/idiom claims against the actual source where one looks doubtful; do not
re-do security or accessibility (the sibling skills own those).

### 3. Triage
Drop env/noise findings; keep the real ones. Classify each:
- **trivial/local** — a fix confined to lines the diff already touches, introducing **no
  new design decision**.
- **substantive** — changes the approach / implies a plan delta.

### 4. Gated walk-back — one finding at a time
Present each finding with its proposed fix and ask **Accept / Modify / Reject / Defer**.
The reviewer subagent never edits; on **Accept** the **host** acts by class:
- **Trivial/local** → the host edits the branch, then **re-runs the repo's gate suite to
  green AND confirms the acceptance tests (the oracle) are unchanged** (diff/checksum). If
  the host's own edit reds the gates, treat it as a block — revert or re-route; **never
  leave a red branch**. (Same verify-then-believe discipline `implement-plan` uses.)
- **Substantive** → route back **`generate-implementation-plan` → `implement-plan`**, not
  straight to `implement-plan` (which consumes a *plan*, not a bare finding): record the
  finding as a **plan amendment**, re-plan, re-implement via the tiered coder, re-gate —
  then `review-code` re-reviews.

Record every disposition in the report (the assurance trail). The human owns the merge
throughout.

### 5. Output
Produce the review report (`../../_templates/code-review-report-template.md`) — findings
by dimension + the disposition table — and hand back a **review-clean branch** (or one
with routed substantive work pending). Report: the effort level used (and any
auto-escalation), the findings raised, what was applied vs routed, the host-reconfirmed
gate results for any applied fix, and confirmation the oracle is intact. Hand off to the
sibling code-level checks (security / accessibility on the diff) and ultimately the
**human merge gate**.

## Where it sits
Implementation phase, a slot in `plan-and-implement`:
`… → implement-plan → review-code → review-security → review-accessibility → reviewed branch`
then the **QA phase** (`assure-quality` / `verify-story`) verifies the running build.
`review-code` is the **general** correctness/quality gate; the code-level conformance
checks are the specialised slots beside it. Human owns the merge throughout.

## What this skill does NOT do
- It does not let the reviewer edit files — the reviewer returns findings only; the
  **host** applies, and only what the **human approved**.
- It does not apply a fix and trust it — every host-applied fix is followed by a **gate
  re-run to green + an oracle-unchanged check**; a red branch is a block, not a pass.
- It does not route a bare finding into `implement-plan` — substantive findings go
  through `generate-implementation-plan` first (a finding is not a plan).
- It does not re-do the security or accessibility review — those are the sibling
  implementation-phase slots; this is the general correctness/quality lens.
- It does not merge or sign off — it stops at a review-clean branch; the human owns the
  merge gate.
- It does not send the diff to any external service — the review is local.

## A note on validation
The review is only as good as its dimensions and the anti-pattern checklist. Before
trusting it, run the **gating pre-build check**: take one real merged PR, run the
independent reviewer over its diff by hand, and compare to what the human reviewer
caught. Then the measured test — **seed ~3 known-vacuous tests** (assertion-free,
asserts-the-mock, re-derives-the-expected) into a diff; the reviewer must **flag ≥2**. If
it misses, harden the **test anti-pattern checklist** — catching weak tests is the whole
reason this skill exists over green gates. Recurring misses on real PRs are the
iteration backlog: tighten the dimensions and the checklist, not the output by hand.
