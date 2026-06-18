# Engineering Standards Review — [TD title]

| | |
|---|---|
| **Design (TD)** | [TD id + title] |
| **Surfaces in scope** | [tiers/`kind`s, HTTP APIs, shared modules, services] |
| **Standard** | Engineering-way standard (`_standards/engineering-way/`) |
| **Altitude** | TD-level **commitment** controls only (code-level realisation is the implementation phase) |
| **Author (drafting)** | check-engineering-standards (skill assists) |
| **Date** | [date] |
| **Status** | DRAFT — conformance evidence; NOT a sign-off (a human accepts) |

> Assisted draft. This verifies the **design commits** to the engineering-way
> disciplines a TD should carry, and proposes gated edits. It does **not** review code
> (implementation phase), does **not** write the Security Considerations rows (those are
> `check-security-standards`'), and does **not** accept a residual gap (a human does).

## Conformance findings (commitment controls)

> One row per design-commitment control. State: current TD state → proposed commitment + cited `ENG-*` → gap. For `ENG-TEST-1`, record the **bar source**.

| `ENG-*` | Control (commitment) | Current TD state | Proposed commitment + citation | Bar source (TEST-1 only) | Gap? |
|----------|----------------------|------------------|-------------------------------|--------------------------|------|
| ENG-LANG-1 | Language chosen + supported | [present / absent] | [name the language; justify if new] | — | [y/n] |
| ENG-TEST-1 | Per-`kind` coverage commitment | [present / absent] | [commit to a bar per tier] | [project .claude/standards \| engineering-way reference default] | [y/n] |
| ENG-API-1 | Shared-contract change control | [present / absent] | [name the rule] | — | [y/n] |
| ENG-API-2/4 | API versioning + back-compat strategy | [present / absent] | [the strategy] | — | [y/n] |
| ENG-OPS-2/3 | Operability + docs approach | [present / absent] | [monitoring/alerting; ADRs] | — | [y/n] |
| ENG-REVIEW-1 / SCM-1 | Review + source-control model | [present / absent] | [protected main; review before merge] | — | [y/n] |

## Security/accessibility cross-references (NOT ticked here)

> Where an ENG control x-refs a security control, the engineering discipline is noted; the
> conformance **row is owned by another skill**. Listed so nothing is double-ticked.

| ENG control | Engineering discipline checked here | Security/a11y row owned by |
|--------------|-------------------------------------|----------------------------|
| ENG-OPS-1 (no PII in logs) | logs structured; no-PII rule in force | check-security-standards (A09 / MASVS-STORAGE-1) |
| ENG-LANG-3 (deps) | lockfile + scanner exist | check-security-standards (A03:2025) |
| ENG-SCM-2 (secrets) | secret scanning on; clean history | check-security-standards (A09) |

## Dispositions (gated; the assurance trail)

> Each finding's outcome, walked one at a time. This table — not the edits — is the record.

| `ENG-*` | Disposition | Change written to TD | Owner | Date |
|----------|-------------|----------------------|-------|------|
| [id] | Accepted / Modified / Rejected / Deferred | [the commitment added/corrected, or "none"] | [name] | [date] |

## Outcome at handoff
- **Commitments added to the TD:** [list of ENG-*].
- **Gaps accepted as residual (human-owned):** [list] — or None.
- **Deferred to code-level:** every realisation control (coverage run, linter, in-diff API
  break, anti-vacuous tests) — enforced by the implementation phase, not here.
- **Not done:** the security/accessibility conformance (sibling skills), and sign-off (human).
