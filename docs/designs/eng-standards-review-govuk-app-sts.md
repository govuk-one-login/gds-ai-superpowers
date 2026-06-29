# Engineering Standards Review — TD GOV.UK App / STS service tokens

| | |
|---|---|
| **Design (TD)** | td-govuk-app-sts-service-tokens |
| **Surfaces in scope** | Backend (TypeScript/Node — STS + new app backend); HTTP API (`POST /token` access token; new department-token contract); shared/public contracts (the `x-gov-sub-id` claim; the front-door pairwise spec; the department token) |
| **Standard** | GDS Way standard (`_standards/gds-way/`) |
| **Altitude** | TD-level **commitment** controls only |
| **Author (drafting)** | check-engineering-standards |
| **Date** | 2026-06-24 |
| **Status** | DRAFT — conformance evidence; NOT a sign-off |

## Conformance findings (commitment controls)

| `GDSW-*` | Control (commitment) | Current TD state | Proposed commitment + citation | Bar source | Gap? |
|----------|----------------------|------------------|-------------------------------|------------|------|
| GDSW-LANG-1 | Language chosen + supported | Present — STS is TS/Node (supported); app-backend language unstated | Confirm app backend is TS/Node (or justify a new language in the TD) — `GDSW-LANG-1` | — | minor (app backend `[gap]`) |
| GDSW-TEST-1 | Per-`kind` coverage commitment | Partial — "match STS quality-gate bar"; exact % `[gap]` | Commit to backend coverage bar; STS gate is the realised enforcer — `GDSW-TEST-1` | **gds-way reference default (backend 85%)** — no `.claude/standards` declared in either repo | yes (number undeclared) |
| GDSW-API-1 | Shared-contract change control | Absent | The `x-gov-sub-id` claim, the **front-door pairwise spec**, and the **department-token contract** are shared/public contracts; a breaking change to any needs TD approval — `GDSW-API-1` | — | yes |
| GDSW-API-2/4 | API versioning + back-compat | Partial — claim noted additive | State: adding `x-gov-sub-id` is **additive/backward-compatible**; the new department-token contract carries a **versioning strategy** — `GDSW-API-2/4` | — | yes (dept-token versioning) |
| GDSW-API-3 | Contracts documented | Partial | Front-door spec **is** the documented pairwise contract; department-token contract needs a documented (OpenAPI/JWT-claims) spec — `GDSW-API-3` | — | yes (dept-token doc) |
| GDSW-OPS-2/3 | Operability + docs (ADRs) | Partial — STS monitoring N/A; app-backend obs = its workstream | Commit to **ADRs** for the design-shaping decisions (issuer location, pairwise construction, denial mechanism) — `GDSW-OPS-3` | — | yes (ADRs) |
| GDSW-REVIEW-1 / SCM-1 | Review + source-control model | Inherited — STS protected `main` + PR review is platform baseline | Cite as **inherited platform** (assured elsewhere); app backend inherits its own — `GDSW-REVIEW-1`/`SCM-1` | — | no (cite, not re-verify) |

## Security/accessibility cross-references (NOT ticked here)

| GDSW control | Engineering discipline checked here | Security/a11y row owned by |
|--------------|-------------------------------------|----------------------------|
| GDSW-OPS-1 (no PII in logs) | TD already flags: don't log raw `subjectId`/`x-gov-sub-id` correlatably | check-security-standards (A09 / MASVS-STORAGE-1) |
| GDSW-LANG-3 (deps) | STS has lockfile + SCA in quality gate (inherited) | check-security-standards (A03:2025) |
| GDSW-SCM-2 (secrets) | STS secret-scanning on (inherited platform) | check-security-standards (A09) |

## Dispositions (gated; the assurance trail)

| `GDSW-*` | Disposition | Change written to TD | Owner | Date |
|----------|-------------|----------------------|-------|------|
| GDSW-API-1 | Accepted | Shared/public-contract change-control paragraph added to API section (x-gov-sub-id, front-door spec, dept token; breaking change routes via TD) | Adam Higginson | 2026-06-24 |
| GDSW-API-2/3/4 | Accepted | Same paragraph: x-gov-sub-id additive/back-compat; dept-token versioning + documented claims spec | Adam Higginson | 2026-06-24 |
| GDSW-TEST-1 | Deferred | None — testing commitment deferred ("ignore testing for now"); bar source noted as gds-way reference default (backend 85%) for when it is set | Adam Higginson | 2026-06-24 |
| GDSW-LANG-1 | Deferred | None — language decisions kept high-level; app-backend language a [gap] owned by the app team | Adam Higginson | 2026-06-24 |
| GDSW-OPS-3 | Deferred | None — ADR commitment kept high-level; not added at this pass | Adam Higginson | 2026-06-24 |
| GDSW-REVIEW-1 / SCM-1 | Accepted (cite) | Inherited STS platform baseline — cited, not re-verified | Adam Higginson | 2026-06-24 |

## Outcome at handoff
- **Commitments added to the TD:** GDSW-API-1, GDSW-API-2/3/4 (shared-contract change control + dept-token versioning/docs, in the API section).
- **Deferred (human-owned, this pass):** GDSW-TEST-1 (coverage bar), GDSW-LANG-1 (app-backend language), GDSW-OPS-3 (ADRs) — recorded as deferred, to revisit before build.
- **Cited as inherited platform:** GDSW-REVIEW-1 / SCM-1 (STS protected `main` + PR review).
- **Deferred to code-level:** coverage run, linter idiom, in-diff API break, anti-vacuous tests — implementation phase.
- **Not done:** security/accessibility conformance (sibling skills); sign-off (human).
