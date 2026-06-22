# GDS Way — Code review discipline (`GDSW-REVIEW-*`)

The human discipline around getting a change merged: peer review before merge, small
reviewable units, and review that covers correctness/tests/idiom while leaving the
specialised lenses to their own checks. Use this lens when a TD or ways-of-working section
commits to a review process.

Note: `review-code` is the library's AI **assist** to this discipline — it does not replace
the human reviewer. These controls describe what the human process must be. The GDS Way also
endorses pair programming (`standards/pair-programming.html`) as an alternative/complement to
formal review.

## Controls

### `GDSW-REVIEW-1` — every change is peer-reviewed before merge
- **realises:** `standards/pull-requests.html`, `manuals/code-review-guidelines.html`.
- **Checkable:** `main` is protected and requires at least one reviewing approver other than
  the author before merge. A path that allows self-merge to a protected branch is a finding
  (cross-ref `GDSW-SCM-1`).

### `GDSW-REVIEW-2` — small, focused, reviewable PRs
- **realises:** `standards/pull-requests.html`, `standards/breaking-down-work.html`.
- **Checkable:** changes are scoped to a reviewable unit (a story/slice), not a sprawling
  multi-concern diff. This is a *guideline with teeth* at review time, not a hard line
  count; a 4,000-line mixed-concern PR is a finding.

### `GDSW-REVIEW-3` — review covers correctness, tests, and idiom; specialised lenses deferred
- **realises:** `manuals/code-review-guidelines.html` (style/linting, dependency vetting,
  appropriate test coverage).
- **Checkable:** the review (human, and the `review-code` assist) covers correctness, test
  quality, reuse, and idiom; **security and accessibility conformance are deferred** to
  `check-security-standards` / `check-accessibility` and their code-level counterparts —
  this control must not absorb them.

## Highest-value questions
- Is `main` actually protected, or is review advisory?
- Are changes arriving in reviewable slices, or as big-bang merges?
- Is the review the *general* lens, with security/a11y owned by their skills?

Source: gds-way.digital.cabinet-office.gov.uk — Pull requests, Code review guidelines,
Breaking down work, Pair programming. AI assist: `review-code`.
