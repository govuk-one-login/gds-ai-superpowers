# GDS Way — Testing & coverage (`GDSW-TEST-*`)

The engineering discipline for proving the code works: a coverage bar the gate enforces, a
proportionate test shape, tests that assert real behaviour, and a CI gate that fails the
build rather than warning. Use this lens whenever a TD commits to a testing approach, a
plan sets a coverage target, or a diff is reviewed for test quality.

Scope note: this is functional test *discipline*. Performance/load testing is its own GDS
Way page (`standards/performance-testing.html`) and a later concern; security/accessibility
*testing* are governed by their own standards and cited where they meet this surface.

## Controls

### `GDSW-TEST-1` — a per-`kind` coverage bar exists and the gate enforces it
- **house convention:** this programme's coverage bars. **The GDS Way publishes no numeric
  coverage target** — it speaks of "appropriate test coverage" qualitatively
  (`manuals/code-review-guidelines.html`). The *numbers* are therefore ours, owned here.
- **Checkable:** the repo defines a coverage bar for its tier (`kind`), and the CI gate
  fails below it. The bar is the **hybrid** value: the project's `.claude/standards/`
  declaration if present, else the **reference programme default** — backend **85%**, web
  **90%**, iOS **85%**, Android **75%**. Any skill applying the bar **reports its source**
  (`[source: project .claude/standards]` vs `[source: gds-way reference default]`). An
  undeclared-and-no-config bar is a **finding** ("coverage bar undeclared"), not a silent
  pass.
- At **TD-level** this is checked as a *commitment* (does the design name a coverage bar?);
  at **code-level** as *realised* (does the repo's config meet it?).

### `GDSW-TEST-2` — proportionate test shape, weighted to fast tests
- **realises:** `standards/test-driven-development.html` (+ `manuals/code-review-guidelines.html`,
  which asks reviewers to consider whether unit tests suffice or integration tests are needed).
- **Checkable:** tests are weighted toward fast unit tests, with fewer integration and
  fewest end-to-end; a feature isn't covered by e2e alone where a unit test would do. A
  diff that adds only slow top-of-pyramid tests for unit-testable logic is a finding.

### `GDSW-TEST-3` — tests assert real behaviour, not tautologies
- **house convention:** owned by `review-code` (its anti-pattern checklist:
  assertion-free / asserts-the-mock / asserts-a-constant / re-derives-the-expected).
- **Checkable:** this control states the *requirement* and **defers the check to
  `review-code`** — it does **not** restate the checklist (no-duplication applies to house
  controls too). Coverage % guards quantity; this guards that the covered lines are
  actually asserted.

### `GDSW-TEST-4` — the gate runs on every change and below-bar fails the build
- **realises:** `standards/continuous-delivery.html`, `standards/source-code/using-github-actions.html`.
- **Checkable:** CI runs the full ordered gate (format → lint → type → test → coverage) on
  every change, and a below-bar or red result **blocks the merge** — it is not a warning.
  A pipeline that reports coverage but doesn't gate on it is a finding.

## Highest-value questions
- Is there a real, enforced bar for this tier — and **which source set it**?
- Are unit-testable behaviours actually unit-tested, or hidden behind slow e2e?
- Do the tests assert the code's output, or just exercise it for the coverage number?
  (→ `review-code`.)

## Deep tier
Pull only when about to record the control Contested / Deferred / applicability Unclear:
- GDSW-TEST-1 (coverage bar + source precedence) — deep: deep/gdsw-test-1.md

Source: gds-way.digital.cabinet-office.gov.uk — Test-driven development, Continuous delivery,
Using GitHub Actions, Code review guidelines. Coverage *numbers* are this programme's
(no upstream GDS Way coverage target exists).
