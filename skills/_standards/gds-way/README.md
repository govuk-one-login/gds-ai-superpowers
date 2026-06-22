# GDS Way — the engineering standard (register + conventions)

This domain encodes the **engineering slice** of the [GDS Way](https://gds-way.digital.cabinet-office.gov.uk/):
how GDS builds — testing, API design and compatibility, code review, programming
languages and idiom, source control, and operability. It is read by the skills that touch
those surfaces (relative path `../_standards/gds-way/...` from a SKILL.md), exactly as
the security and accessibility standards are.

## Why this domain has an index and `security/` / `accessibility/` do not

`security/` and `accessibility/` are flat — each file is its own **external** framework
(OWASP, MASVS, WCAG) that owns its own control IDs. GDS Way is published as **prose with no
control IDs**, so this library **mints** a house identifier scheme (`GDSW-*`). A minted
scheme needs one authoritative register — this file. Do **not** add a README/index to
`security/` or `accessibility/`, and do not "tidy" this one away: it exists because the IDs
are ours.

## House identifiers — `GDSW-<concern>-<n>` (read this before renumbering)

The `GDSW-*` IDs are **authored by this library**, unlike the security IDs we cite from
OWASP/MASVS. That means **we own their stability**: a skill, a template, or a TD may cite
`GDSW-TEST-1` durably, so **do not renumber or reuse an ID casually**. Retire an ID (mark it
withdrawn) rather than reassign its number. New controls take the next free number in their
concern.

## Mandatory, bimodal provenance

Every catalogued control declares its origin, and exactly one of two kinds:
- **`realises:`** a specific GDS Way page — the control encodes published GDS guidance.
  These are what the freshness check (re-grounding against the live site) governs.
- **`house convention:`** an owning skill or repo file — the control is ours, with no
  upstream GDS Way page (e.g. `GDSW-TEST-3` is owned by `review-code`). These are governed
  by their owning artifact: if they drift from it, that is the finding.

Never blank, never both. A control with no checkable statement is **guidance** — it lives in
prose under its concern file, not in the tickable catalogue.

## The no-duplication boundary (the whole reason the library exists)

This standard is the **engineering** slice only. Security and accessibility have their own
homes and are **cited, never restated**:
- A GDSW control that touches security (no PII in logs, dependency scanning, secrets)
  **cross-references** the owning control (`A09`, `A03:2025`, `MASVS-STORAGE-1`) and names
  **which skill ticks that row** — `check-security-standards` owns the security tick;
  `check-engineering-standards` verifies only the engineering discipline.
- A GDSW control that restates another house artifact (the commit format, `review-code`'s
  anti-vacuous checklist) **points to it**, never copies it.

## Coverage bars — hybrid (library reference default, project overrides, source reported)

The per-`kind` coverage bars ship here as **labelled reference programme defaults**
(backend 85 / web 90 / iOS 85 / Android 75). A consuming project's `.claude/standards/`
value **wins when present**. Any skill that applies a bar **must report its source** —
`[source: project .claude/standards]` vs `[source: gds-way reference default]` — so a
mismatch is visible, never silent. (This was a considered call: a second GDS programme
overrides via its own `.claude/standards/`; the label and the source-reporting keep a
programme number in a product-agnostic library honest.)

## The register

| File | Concern | Controls |
|------|---------|----------|
| `testing.md` | Testing & coverage | `GDSW-TEST-1..4` |
| `api-compatibility.md` | API design & compatibility | `GDSW-API-1..4` |
| `code-review.md` | Code review discipline | `GDSW-REVIEW-1..3` |
| `languages.md` | Languages & idiom | `GDSW-LANG-1..3` |
| `source-control.md` | Source control | `GDSW-SCM-1..3` |
| `operability.md` | Operability & docs | `GDSW-OPS-1..3` |

Consumed at two altitudes (one standard, owned by the work not the role):
- **Architecture / TD-level** — `check-engineering-standards` ticks the *design-commitment*
  controls (language choice, API-versioning strategy, the coverage commitment, the
  operability approach).
- **Implementation / code-level** — `generate-implementation-plan` (coverage bar + gate +
  shared-API route), `review-code` (idiom; `GDSW-TEST-3`), and the named code-level check
  slot realise the rest against the actual repo/diff.

Source: **gds-way.digital.cabinet-office.gov.uk** (the canonical live site; the older
`gds-way.cabinet-office.gov.uk` / `gds-way.cloudapps.digital` hosts are dead/legacy). The
authoritative content lives in the **alphagov/gds-way** GitHub repo (`source/standards/`,
`source/manuals/`). **Catalogue verified against the live site on 2026-06-10:** every
`realises:` control names a real page; the coverage **numbers** (`GDSW-TEST-1`) and the
`GDSW-API-*` versioning/compat controls are honestly marked **house convention** because the
GDS Way publishes no numeric coverage target and no dedicated APIs standard page. Re-ground
the `realises:` controls against the live site as ongoing maintenance.
