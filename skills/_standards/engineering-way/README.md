# Engineering Way — the engineering standard (register + conventions)

This domain encodes the **engineering slice** of the cadence library:
how teams build — testing, API design and compatibility, code review, programming
languages and idiom, source control, and operability. It is read by the skills that touch
those surfaces (relative path `../_standards/engineering-way/...` from a SKILL.md), exactly as
the security and accessibility standards are.

## Why this domain has an index and `security/` / `accessibility/` do not

`security/` and `accessibility/` are flat — each file is its own **external** framework
(OWASP, MASVS, WCAG) that owns its own control IDs. The engineering standard is published
as **prose with no control IDs**, so this library **mints** a house identifier scheme (`ENG-*`). A minted
scheme needs one authoritative register — this file. Do **not** add a README/index to
`security/` or `accessibility/`, and do not "tidy" this one away: it exists because the IDs
are ours.

## House identifiers — `ENG-<concern>-<n>` (read this before renumbering)

The `ENG-*` IDs are **authored by this library**. That means **we own their stability**: a
skill, a template, or a TD may cite `ENG-TEST-1` durably, so **do not renumber or reuse an
ID casually**. Retire an ID (mark it withdrawn) rather than reassign its number. New controls
take the next free number in their concern.

## Mandatory, bimodal provenance

Every catalogued control declares its origin, and exactly one of two kinds:
- **`realises:`** a specific engineering reference — the control encodes published guidance.
  These are what any freshness check (re-grounding against the source) governs.
- **`house convention:`** an owning skill or repo file — the control is ours, with no
  upstream page (e.g. `ENG-TEST-3` is owned by `review-code`). These are governed
  by their owning artifact: if they drift from it, that is the finding.

Never blank, never both. A control with no checkable statement is **guidance** — it lives in
prose under its concern file, not in the tickable catalogue.

## The no-duplication boundary (the whole reason the library exists)

This standard is the **engineering** slice only. Security and accessibility have their own
homes and are **cited, never restated**:
- An ENG control that touches security (no PII in logs, dependency scanning, secrets)
  **cross-references** the owning control (`A09`, `A03:2025`, `MASVS-STORAGE-1`) and names
  **which skill ticks that row** — `check-security-standards` owns the security tick;
  `check-engineering-standards` verifies only the engineering discipline.
- An ENG control that restates another house artifact (the commit format, `review-code`'s
  anti-vacuous checklist) **points to it**, never copies it.

## Coverage bars — hybrid (library reference default, project overrides, source reported)

The per-`kind` coverage bars ship here as **labelled reference programme defaults**
(backend 85 / web 90 / iOS 85 / Android 75). A consuming project's `.claude/standards/`
value **wins when present**. Any skill that applies a bar **must report its source** —
`[source: project .claude/standards]` vs `[source: engineering-way reference default]` — so a
mismatch is visible, never silent.

## The register

| File | Concern | Controls |
|------|---------|----------|
| `testing.md` | Testing & coverage | `ENG-TEST-1..4` |
| `api-compatibility.md` | API design & compatibility | `ENG-API-1..4` |
| `code-review.md` | Code review discipline | `ENG-REVIEW-1..3` |
| `languages.md` | Languages & idiom | `ENG-LANG-1..3` |
| `source-control.md` | Source control | `ENG-SCM-1..3` |
| `operability.md` | Operability & docs | `ENG-OPS-1..3` |

Consumed at two altitudes (one standard, owned by the work not the role):
- **Architecture / TD-level** — `check-engineering-standards` ticks the *design-commitment*
  controls (language choice, API-versioning strategy, the coverage commitment, the
  operability approach).
- **Implementation / code-level** — `generate-implementation-plan` (coverage bar + gate +
  shared-API route), `review-code` (idiom; `ENG-TEST-3`), and the named code-level check
  slot realise the rest against the actual repo/diff.
