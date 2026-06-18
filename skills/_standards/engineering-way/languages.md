# Engineering Way — Languages & idiom (`ENG-LANG-*`)

The discipline around language choice and house style: use a supported language, follow its
idiom enforced by the standard linter/formatter, and keep dependencies healthy. Use this
lens when a TD chooses a language/stack, or a diff is reviewed for idiom and dependency
hygiene.

## Controls

### `ENG-LANG-1` — use a programme-supported language for the tier; justify a new one in the TD
- **house convention:** programmes keep a deliberately small supported set and allow reasoned
  exceptions (e.g. during an alpha or an unusual domain). The specific supported languages
  are declared by the consuming project.
- **Checkable:** the tier's language is one of the programme's supported set already in use;
  introducing a **new** language is a TD-level decision with a recorded justification, not
  an implementation-time choice. At TD-level this is the *language the design commits to*.

### `ENG-LANG-2` — follow the language idiom, enforced by the standard linter/formatter
- **realises:** per-language style guides.
- **Checkable:** the repo runs the standard formatter + linter for its language
  (e.g. Prettier + ESLint for TS; SwiftLint for Swift; ktlint + detekt for Kotlin) in the
  gate, and the diff conforms. Non-idiomatic code that the configured linter would reject,
  or a missing standard linter, is a finding. (Realised code-side; `review-code` also flags
  idiom.)

### `ENG-LANG-3` — dependency hygiene: pinned, scanned, kept current
- **realises:** dependency-tracking guidance (vet new third-party dependencies for reliability;
  prefer open source).
- **Checkable:** dependencies are pinned/locked, scanned for known vulnerabilities, and kept
  current. The **security tick** for vulnerable/outdated components is owned by
  `check-security-standards` (cross-ref **A03:2025 Software Supply Chain Failures**) —
  this control verifies the *engineering discipline* (a lockfile exists, a scanner runs in
  CI), not the security conformance row.

## Highest-value questions
- Is the language a supported one, or a new introduction that should have been a TD decision?
- Does the standard linter/formatter run in the gate, and does the diff pass it?
- Are deps pinned and scanned — with the security row left to `check-security-standards`?

## Deep tier
Pull only when about to record the control Contested / Deferred / applicability Unclear:
- ENG-LANG-1 (supported language choice; new-language = TD decision) — deep: deep/eng-lang-1.md
