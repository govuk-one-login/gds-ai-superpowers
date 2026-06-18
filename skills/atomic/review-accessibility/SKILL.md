---
name: review-accessibility
description: >
  Independently review an implemented diff through the **accessibility** lens — a separate
  Claude subagent with fresh context reads the UI code cold and flags the WCAG 2.2 AA
  failures that are **statically detectable** in the diff (missing alt / labels / accessible
  names, non-semantic markup, ARIA absent or state not synced, missing form labels, target
  sizes below threshold, missing focus-visible, missing lang, heading order, missing
  live-region announcements), citing the WCAG success criterion. Use once a UI story is
  implemented to a green branch — "accessibility review of this diff", "check the UI code for
  WCAG issues", "did we implement the a11y acceptance criteria", or as the code-level
  accessibility slot of the dev pipeline (`plan-and-implement`) after `review-security`. It
  is **risk-tiered** (runs when the diff touches a UI surface; otherwise records "Not
  Required"), reuses the library's accessibility standards (WCAG spine + iOS/Android/web
  lenses), and walks findings back gated (host applies an approved trivial fix then re-runs
  the gate suite + confirms the oracle; substantive findings route back through the plan). It
  **defers the runtime residue** (rendered contrast, real screen-reader announcement, live
  focus order) to the QA `accessibility-at-testing` slot via a "deferred to AT" list. It is
  the **accessibility, code-level** lens — it does NOT do general correctness (`review-code`)
  or security (`review-security`), does NOT re-do the story/design applicability review
  (`check-accessibility`), does NOT drive the running app with assistive technology or
  certify WCAG conformance (the QA AT slot + a human specialist), and never accepts risk or
  merges.
---

# Review Accessibility (review-accessibility)

You orchestrate an **independent accessibility review of an implemented diff by a separate
Claude subagent with fresh context** — a reviewer reading the UI code cold through the WCAG
lens. You run the review, present its findings, and walk them back into the branch **gated**.
You never let the reviewer edit files, and you never accept its suggestions on the dev's
behalf. The review runs **locally** (Agent tool); nothing leaves the estate.

## Accessibility across three phases (the boundary — read this)

Accessibility is reviewed at three altitudes by three skills; this is the **middle** one:

- **`check-accessibility` = story/design level.** Which WCAG SCs apply to each UI-facing
  story; adds accessibility acceptance criteria; flags design-level blockers to the TD.
- **`review-accessibility` = code/diff level (this skill).** Does the *diff* contain the
  **statically-detectable** WCAG failures, and does it realise the a11y acceptance criteria
  `check-accessibility` added? An independent review of the actual UI code.
- **`accessibility-at-testing` = QA, running UI + assistive tech.** The **runtime residue** a
  static diff can't confirm — rendered contrast, real screen-reader announcement, live focus
  order/traps. (A named QA slot in `assure-quality`.)

Beside it in the dev pipeline: `review-code` (general correctness) and `review-security`
(security) are the other code-level lenses; this one is accessibility only.

## The honest limit: static diff vs running UI

A diff review catches the **code-detectable** WCAG failures — but a real chunk of
accessibility can only be confirmed on the **running UI with assistive technology**. This
skill must not give false confidence. So it does two things: flags what it **can** detect
statically, **and** produces an explicit **"deferred to AT testing" list** of the SCs that
apply to this UI surface but need the running app — handed to the QA `accessibility-at-testing`
slot. A green code-level pass is **not** "accessibility done."

| Statically detectable (this skill checks) | Runtime residue (deferred to AT testing) |
|-------------------------------------------|------------------------------------------|
| Missing alt / `accessibilityLabel` / `contentDescription` (1.1.1) | Real screen-reader announcement / does the name read well (1.1.1 verification) |
| Non-semantic markup; `<div>` as heading/control; missing `<label for>` (1.3.1) | Actual reading/announcement order with a screen reader |
| ARIA absent or state not synced; custom control no role (4.1.2) | Whether the control actually **announces + updates** to AT (4.1.2) |
| Hardcoded target size below 24px/44pt/48dp (2.5.8) | Real hit-target size as rendered |
| Missing `:focus-visible` / focus indicator (2.4.7); DOM-vs-visual order (2.4.3) | Live keyboard/AT operability, focus traps (2.1.1); focus-not-obscured at runtime (2.4.11) |
| Missing `lang`; missing `aria-live`/`role=status` / `liveRegion` (3.1.1, 4.1.3) | Rendered colour contrast vs real backgrounds/states (1.4.3) |

## The thesis: `review-security`, pointed through the accessibility lens
Same machinery as `review-security` / `review-code` — fresh-context, local, independent,
**read-only** reviewer; structured findings; gated write-back with a **host-applied
trivial-fix path** (verify-then-believe: re-gate after). What changes is the **lens** (WCAG,
not security/correctness), the findings are cited to a **WCAG SC**, and the output carries a
**deferred-to-AT** list.

## What you take as input
- The implemented **diff** — the **story branch vs its base** (`git diff <base>...HEAD`).
- The **story's acceptance criteria** + its **"Grounds in"** surface, and the **accessibility
  acceptance criteria `check-accessibility` added** to the UI-facing stories (so the review
  verifies they are realised in the code).

## Risk-tiering — when this runs
Run when the diff touches a **UI-facing surface** — a view / screen / page / form / component
(per the story's "Grounds in", or a project-declared accessibility-sensitive path glob), or
the sizing implies UI impact. Otherwise (a backend/infra-only diff, no UI surface) **record**
"code-level accessibility review: Not Required (no UI surface in diff)" with owner + reason
and skip. If the signals aren't declared, default to **running** when any UI-facing file is in
the diff. A skip is a recorded, owned decision, never silent.

## Where the standards live
Read a `_standards/accessibility/` lens only for a surface the diff touches: web →
`../../_standards/accessibility/wcag.md` (spine + web realisation); iOS →
`../../_standards/accessibility/ios.md`; Android → `../../_standards/accessibility/android.md`.
Cite the **WCAG SC** (e.g. `1.1.1`, `4.1.2`); never inline standards text.

**Depth on demand:** when about to record an SC **Contested / applicability Unclear** and its
lens line carries a `deep:` pointer, pull that one SC's deep file
(`../../_standards/accessibility/deep/wcag-<sc>.md`) — its code-level example / pitfalls. One
whole-file read; don't re-pull within this invocation. The lens stays the citable source.

## Workflow

### 1. Tier the review
Compute the diff. Apply the risk-tiering rule: **run** or **Not Required (recorded)**. If Not
Required, write that decision to the report and stop. If running, set effort (a shared UI
component / design-system change or a new custom control → thorough; else standard).

### 2. Dispatch the independent reviewer (read-only, fresh context)
Spawn a subagent (Agent tool, fresh context) and give it: the **accessibility-reviewer
persona**, the **base ref** (compute the diff itself), the **acceptance criteria + the a11y
criteria check-accessibility added**, the **platform routing**, and the **two-job rubric**:
(a) **realisation** — are the a11y acceptance criteria implemented in the diff; (b)
**code-detectable WCAG failures** — per the static-detectable list above. Ask for findings
only — it must not edit anything. Findings as one-per-line JSON, each cited to an SC:

```
{"sc": "1.1.1|4.1.2|2.5.8|…", "platform": "web|ios|android", "location": "file:line", "severity": "critical|high|medium|low", "kind": "realisation-gap|code-wcag-failure", "issue": "...", "proposed_fix": "...", "confidence": "high|medium|low"}
```

Also ask it to return a **deferred-to-AT** list: the SCs that apply to this UI surface but
can only be confirmed on the running UI with AT (contrast-as-rendered, announce/update,
live focus). Tell it: this is a **static code-level** review — do not claim a runtime SC is
"passing"; flag it as deferred. Do not re-do general correctness, security, or the
story/design applicability review (the sibling skills own those).

### 3. Triage
Drop env/noise findings. Classify each **trivial/local** (a fix confined to lines the diff
touches, no new design decision — e.g. add an `alt`, add a `<label for>`, bump a target size)
or **substantive** (changes the approach / implies a plan delta — e.g. a custom control that
needs rebuilding on semantic foundations).

### 4. Gated walk-back — one finding at a time
Present each finding (cited SC + proposed fix) and ask **Accept / Modify / Reject / Defer**.
The reviewer never edits; on **Accept** the **host** acts by class:
- **Trivial/local** → host edits the branch, then **re-runs the repo's gate suite to green AND
  confirms the acceptance tests (the oracle) are unchanged**. A red branch is a block.
- **Substantive** → route back **`generate-implementation-plan` → `implement-plan`** as a plan
  amendment, re-implement, re-gate — then `review-accessibility` re-reviews.

Record every disposition in the report. The human owns the merge throughout.

### 5. Output
Produce the report (`../../_templates/accessibility-code-review-report-template.md`) — the
tiering decision (ran / Not Required), the SC-cited findings, the disposition table, and the
**"deferred to AT testing" list**. Report: whether it ran, the findings by SC, what was
applied vs routed, the host-reconfirmed gate results, the oracle status, and explicitly the
**runtime SCs handed to the QA `accessibility-at-testing` slot**. Hand off to the **human
merge gate**.

## What this skill does NOT do
- It does not do general correctness (`review-code`) or security (`review-security`) — those
  are the sibling code-level lenses; this is accessibility only.
- It does not re-do the story/design applicability review — that is `check-accessibility`;
  this verifies the diff **realises** those criteria and hunts code-detectable failures.
- It does not drive the running app with assistive technology, test rendered contrast, or
  certify WCAG conformance — that is the QA `accessibility-at-testing` slot + a human
  specialist. It **defers** that residue explicitly (the deferred-to-AT list); it never marks
  a runtime SC "passed" from a static diff.
- It does not let the reviewer edit files — the reviewer returns findings only; the **host**
  applies, and only what the **human approved**, with a gate re-run + oracle check after.
- It does not merge or accept risk — it stops at a review-clean branch; the merge stays the
  human's.
- It does not send the diff to any external service — the review is local.

## A note on validation
Validate against a real merged UI PR with a known a11y issue (or seed one — a custom toggle
with no role/label, an icon button with no accessible name): run the reviewer over the diff
and confirm it flags the issue, cites the right SC, and correctly **defers** the runtime-only
SCs rather than claiming them passed. Recurring misses (or false "passed" on a runtime SC) are
the iteration backlog — tighten the static-detectable list, the routing, and the
deferred-to-AT discipline, not the output by hand.
