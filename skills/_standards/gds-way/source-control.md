# GDS Way — Source control (`GDSW-SCM-*`)

The discipline around version control: short-lived branches off a protected `main`, coding
in the open where appropriate with secrets kept out, and traceable commits. Use this lens
when a TD or ways-of-working section commits to a source-control model, or a diff/PR is
reviewed for hygiene.

## Controls

### `GDSW-SCM-1` — short-lived branches off a protected `main`
- **realises:** `standards/source-code/working-with-git.html`, `standards/source-code/use-github.html`
  (+ `standards/pull-requests.html`).
- **Checkable:** `main` is protected (no direct pushes, review required — cross-ref
  `GDSW-REVIEW-1`); feature branches are short-lived and merged back promptly rather than
  diverging for weeks. Unprotected `main`, or long-running divergent branches, is a finding.

### `GDSW-SCM-2` — code in the open by default; secrets never committed
- **realises:** `standards/source-code/use-github.html` (GDS codes in the open by default).
  Secrets handling x-refs `standards/storing-credentials.html`.
- **Checkable:** repositories follow the GDS "open by default" posture where the work allows
  it, and **no secrets are committed** (secret scanning runs; `.gitignore` and pre-commit
  hygiene in place). A committed secret or credential is a finding — and the **security
  tick** for secret handling is owned by `check-security-standards` (cross-ref **A09** /
  secrets); this control verifies the engineering hygiene (scanning is on, history is clean).

### `GDSW-SCM-3` — conventional, traceable commits
- **house convention:** owned by the repo's `COMMIT_STANDARD.md` (Conventional Commits).
- **Checkable:** commits follow the repo's declared format (`type(scope): summary`) and are
  traceable to the work; this control **points to `COMMIT_STANDARD.md`** and does not restate
  it. Non-conforming history is a finding against that file.

## Highest-value questions
- Is `main` actually protected, and are branches short-lived?
- Is secret scanning on, with a clean history — security row left to `check-security-standards`?
- Do commits follow the repo's declared standard?

Source: gds-way.digital.cabinet-office.gov.uk — Working with Git, Use GitHub, Pull requests,
Storing credentials. Commit format: the repo's `COMMIT_STANDARD.md`.
