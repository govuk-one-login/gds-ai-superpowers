# Platform Constraints Review — [TD title]

| | |
|---|---|
| **Design (TD)** | [TD id + title] |
| **Platform surfaces in scope** | [data locations, services, tenancy, load vs quotas, egress, any new platform component] |
| **Standard** | Platform constraints lens (`_standards/platform/`) + project `platform-baseline.md` |
| **Altitude** | TD-level **fit** (does the design fit the platform) + conditional new-platform-surface security |
| **Author (drafting)** | check-platform-constraints (skill assists) |
| **Date** | [date] |
| **Status** | DRAFT — conformance evidence; NOT a sign-off (a human accepts) |

> Assisted draft. This verifies the design **fits** the declared platform constraints, and
> (only when the design introduces/changes a platform component) that the **new** surface is
> secure by design. It does **not** verify the change's application-level security (that is
> `check-security-standards`'), does **not** re-verify an unchanged platform (assured once,
> cited), and does **not** accept a residual gap or waiver (a human does).

## Fit findings (per `PLAT-*`)

> One row per control. State: current TD state → the declared constraint it's checked against
> (+ source) → gap. `[gap]` where no baseline value is declared.

| `PLAT-*` | Constraint | Current TD state | Declared value (source) | Fit? / Gap |
|----------|------------|------------------|-------------------------|------------|
| PLAT-1 | Data residency & jurisdiction | [present / absent] | [approved region(s) — `platform-baseline.md` \| `[gap]`] | [fits / finding] |
| PLAT-2 | Approved services / components | [present / absent] | [approved list — source] | [fits / finding] |
| PLAT-3 | Tenancy & isolation | [present / absent] | [tenancy model — source] | [fits / finding] |
| PLAT-4 | Resource, quota & scaling limits | [present / absent] | [quotas — source] | [fits / finding] |
| PLAT-5 | Network egress & connectivity | [present / absent] | [egress rules — source] | [fits / finding] |
| PLAT-6 | Platform change surface | [introduces new component? Y/N — what] | [IaC/deploy approach] | [declared / finding] |

## Conditional security pass (only if PLAT-6 fired)

> Filled **only** when the design introduces/changes a platform component. The new surface,
> checked against the existing controls — cited, never restated. Empty (with "no new platform
> component — platform inherited and cited") otherwise.

| New platform component | Security control cited | Finding |
|------------------------|------------------------|---------|
| [e.g. new CI/CD pipeline] | [NCSC CP 8 / A03:2025 / A08:2025 / GDSW-SCM-* / GDSW-OPS-*] | [what to add / address] |

## Dispositions (gated; the assurance trail)

> Each finding's outcome, walked one at a time. This table — not the edits — is the record.

| `PLAT-*` / item | Disposition | Change written to TD | Owner | Date |
|-----------------|-------------|----------------------|-------|------|
| [id] | Accepted / Modified / Rejected / Deferred | [the fit correction / declaration added, or "none"] | [name] | [date] |

## Outcome at handoff
- **Fit corrections written to the TD:** [list of PLAT-*].
- **New platform components introduced (and security-checked):** [list] — or None (platform inherited, cited).
- **Gaps accepted as residual / waivers (human-owned):** [list] — or None.
- **Not done:** the change's application-level security (`check-security-standards`), and sign-off (human).
