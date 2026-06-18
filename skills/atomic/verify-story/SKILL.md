---
name: verify-story
description: >
  Verify that the **running, built** software actually does what a user story's
  acceptance criteria promised — by driving the real system (API calls, a browser, a
  device simulator) and proving each criterion, then leaving behind durable end-to-end
  tests so it stays proven. Use this once a story has been implemented and you want
  QA/QE confidence — phrases like "QA this story", "verify this works end to end",
  "test the running app against the acceptance criteria", "does the built feature
  actually work", "check we have enough e2e tests", or as the verification gate after
  the dev pipeline. It selects a per-surface **driver** from the story's `kind`
  (backend→API, web-frontend→browser, ios/android→simulator), prefers to **verify by
  writing an automated e2e test** for each criterion (verify-by-automating), and routes
  any product defect back to the dev pipeline **as a failing test** — it does NOT fix
  product code itself, does NOT merge (the human owns the merge), and does NOT certify
  release. It catches what the dev pipeline's unit/gate tests structurally can't: real,
  integrated, running-system behaviour.
---

# Verify Story

You are acting as a QA/QE engineer proving a built feature does what its story
promised. The dev pipeline already made the unit/gate tests green — but "unit tests
pass" is not "it works." You drive the **running, integrated build** against each
acceptance criterion, and you leave durable end-to-end tests behind so the proof
persists.

**The thesis — verify by automating.** Verify each criterion by creating (or
confirming) an automated **e2e test** that exercises it on the running system. The act
of verification *produces the durable coverage*. Fall back to interactive driving +
captured evidence (and **flag the gap**) only where a criterion genuinely can't be
automated.

Your job is to **prove the running build against the criteria and ensure sufficient
e2e coverage exists**. Your job is **not** to fix the product code, to merge, or to
sign off the release — you produce the evidence and the tests; a human owns the gate.

## Where the template and the driver register live

- Output template: `../../_templates/verification-report-template.md`.
- **Driver register (project-owned).** The library is product-agnostic, so this skill
  cites **capabilities** — "an API e2e framework", "a browser e2e framework", "a
  simulator UI driver" — and the **consuming project declares the concrete tools** per
  `kind` in `.claude/qa-drivers.md` (house format:
  `../../_templates/project-qa-drivers-template.md`), discovered from the project root
  (nearest `.claude/`). Never hardcode a tool name in this skill.

## Selecting the driver (by surface)

Read the story's `kind` (the dev pipeline's taxonomy) and pick the driver:

| `kind` | Drive the running system with | Codify the durable test as | Status |
|--------|-------------------------------|----------------------------|--------|
| `backend` (incl. serverless) | HTTP calls against the running service | the project's declared **API e2e framework** | **first-class** |
| `web-frontend` | the environment's **browser automation** (the Chrome MCP) | the project's declared **browser e2e framework** | **first-class** |
| `ios` / `android` | the project's declared **simulator UI driver** | the project's declared **mobile UI test** | **gated** — only if the driver is wired AND validated on one real flow for this repo (see "Mobile" below); else stop and flag the prerequisite |

## Inputs
- **One built story** (its acceptance criteria + "Grounds in" surface), on the dev
  pipeline's story branch.
- **A running target** — *primary path: provided* (a URL / a booted sim with the app
  installed). The skill may **best-effort stand it up** itself (Decision below), but
  never guesses missing externals.
- The project's **driver register** and source map.

## Workflow

### 1. Resolve driver + target
From the story's `kind`, resolve the driver from the project register; confirm the tool
is wired (if a needed driver isn't declared/wired, that is a **gated prerequisite to the
human**, not a guess). **Accept a provided running target** (primary), or best-effort
stand it up from the project's **stand-up contract** (run/build/boot command + required
externals + degrade trigger) — strongest for API/web, weak for mobile; if externals
(DB, secrets, fixtures, sim) can't be satisfied, **request a provided target**.

### 2. Drive each acceptance criterion
For every Given/When/Then criterion, drive the running system through it with the driver
and assert the **observable outcome** — including the **negative/edge** criteria (an
error response/status for API; an error state / disabled control for UI). Capture the
concrete steps and selectors as you go (stage 3 needs them).

### 3. Codify a durable e2e test (the hard, lossy part — be disciplined)
Turn each verified criterion into a deterministic, re-runnable e2e test in the project's
declared framework. **Discipline, non-negotiable:** use **role / text / accessibility-id
selectors, never raw coordinates**; **no hard `sleep` waits** — wait on conditions or
elements; assert behaviour, not internals. A test that passes once but is flaky is worse
than none — it poisons the classification in stage 5.

### 4. Coverage assessment (v1 rubric)
Judge sufficiency: every acceptance criterion has a passing e2e test **or** a flagged
gap; the primary happy path is covered end to end; each error/edge path the criteria
name is covered. A criterion that genuinely can't be automated → driven evidence +
a **flagged gap**, never silently dropped. (The fuller rubric ties to the engineering
standard later.)

### 5. Classify a failing criterion BEFORE filing it (the gate's credibility)
A failure is not automatically a product defect:
- **Run the env preconditions first** (target reachable, sim booted, auth/seed present).
  A failed precondition → **environment** issue: fix-and-retry, do **not** file a defect.
- **Reproduce across ≥2 runs** with preconditions green. Environment signatures (not
  product): timeouts, connection-refused, auth/token expiry, sim/emulator-not-booted,
  missing fixtures.
- **Only a reproducible failure with preconditions green is a product defect.**
- **Ambiguous → escalate to the human; never auto-file a defect on a single failure.**

### 6. Route product defects back — gated, as failing tests (never fix product code)
For each confirmed defect: write the **failing e2e test that reproduces it** + a
Jira-ready defect record, and walk it to the human **gated** (Accept / Modify / Reject /
Defer) before routing. The loop join, precisely:
- The reproduction test is **added to the story's acceptance-test oracle** (via
  `generate-acceptance-tests`).
- The fix **re-enters at `implement-plan`** against the existing approved plan (or a
  light re-plan via `generate-implementation-plan` if non-trivial). Not a fresh
  `plan-and-implement` — it's a regression on an already-built story.
- After the fix lands, **re-verify** (stage 7): re-run on the updated branch.

### 7. Output and re-verify
Fill `../../_templates/verification-report-template.md`: per-criterion result
(verified-automated / verified-manual-gap / failed), the criterion→test map, the
coverage assessment, flagged gaps, and the per-defect dispositions table. Commit the e2e
tests as **new commits on the story branch**. Re-verify is a **manual re-invocation** on
the updated branch after a fix, diffing against the prior report. The human owns the
merge.

## Mobile (`ios` / `android`) — gated, not yet first-class
Mobile drivers are designed but **gated on per-repo validation**: the tooling is real
(e.g. an Xcode simulator MCP for iOS, a cross-platform flow runner for Android — named
in the project's driver register, not here), but "tooling exists" ≠ "the driver reliably
drives it and emits a stable test." Before a mobile driver is trusted for a repo,
validate it on **one real flow**. Until then, for an `ios`/`android` story, run the
declared driver if wired, else **stop and flag** that the mobile driver is an unmet
prerequisite — do not pretend to verify.

## What this skill does NOT do
- It does not fix product code. A defect is routed back as a failing test through the
  dev pipeline; QA writes **test** code, never **product** code.
- It does not merge or certify release — the human owns the merge gate.
- It does not hardcode tool names — capabilities here, concrete tools in the project's
  driver register.
- It does not file a defect on a single or environment-caused failure — it classifies
  first (stage 5) and escalates ambiguity to the human.
- It does not commit a flaky test — a non-deterministic e2e test is a failure, not
  coverage.
- It does not invent a running target or missing externals — it requests a provided
  target rather than guessing.

## A note on validation
Validate against a real, already-built story with a running target: verify it by hand
through each driver you have, and check both halves — could you **drive** each criterion,
and could you **codify** a stable e2e test for it? Where you couldn't automate is the
real gap list this skill must flag; where the codified test is flaky is the
codification discipline to tighten. Prove this on a real surface before trusting the
skill's output.
