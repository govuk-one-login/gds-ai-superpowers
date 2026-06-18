# GDS Way — Languages & idiom (`GDSW-LANG-*`)

The discipline around language choice and house style: use a supported language, follow its
idiom enforced by the standard linter/formatter, and keep dependencies healthy. Use this
lens when a TD chooses a language/stack, or a diff is reviewed for idiom and dependency
hygiene.

## Controls

### `GDSW-LANG-1` — use a GDS-supported language for the tier; justify a new one in the TD
- **realises:** `standards/programming-languages.html` (GDS keeps a deliberately small set —
  Node.js/TypeScript, Python 3, native Swift/Kotlin for mobile; Go and Scala are not for new
  work — and allows reasoned exceptions, e.g. during an alpha or an unusual domain).
- **Checkable:** the tier's language is one of the GDS-supported set already in use on the
  programme; introducing a **new** language is a TD-level decision with a recorded
  justification, not an implementation-time choice. At TD-level this is the *language the
  design commits to*.

### `GDSW-LANG-2` — follow the language idiom, enforced by the standard linter/formatter
- **realises:** `manuals/programming-languages.html` (the GDS style guides) and the
  per-language manuals under it.
- **Checkable:** the repo runs the standard formatter + linter for its language
  (e.g. Prettier + ESLint for TS; SwiftLint for Swift; ktlint + detekt for Kotlin) in the
  gate, and the diff conforms. Non-idiomatic code that the configured linter would reject,
  or a missing standard linter, is a finding. (Realised code-side; `review-code` also flags
  idiom.)

### `GDSW-LANG-3` — dependency hygiene: pinned, scanned, kept current
- **realises:** `standards/tracking-dependencies.html` (+ `manuals/code-review-guidelines.html`,
  which asks reviewers to vet new third-party dependencies for reliability and to prefer open
  source).
- **Checkable:** dependencies are pinned/locked, scanned for known vulnerabilities, and kept
  current. The **security tick** for vulnerable/outdated components is owned by
  `check-security-standards` (cross-ref **A03:2025 Software Supply Chain Failures**, which
  absorbed the old vulnerable-components category) — this control verifies the *engineering
  discipline* (a lockfile exists, a scanner runs in CI), not the security conformance row.

## Highest-value questions
- Is the language a supported one, or a new introduction that should have been a TD decision?
- Does the standard linter/formatter run in the gate, and does the diff pass it?
- Are deps pinned and scanned — with the security row left to `check-security-standards`?

## Deep tier
Pull only when about to record the control Contested / Deferred / applicability Unclear:
- GDSW-LANG-1 (supported language choice; new-language = TD decision) — deep: deep/gdsw-lang-1.md

Source: gds-way.digital.cabinet-office.gov.uk — Programming languages, Style guides
(manuals/programming-languages), Tracking dependencies, Code review guidelines.
