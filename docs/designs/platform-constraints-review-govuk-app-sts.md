# Platform Constraints Review — TD GOV.UK App / STS service tokens

| | |
|---|---|
| **Design (TD)** | td-govuk-app-sts-service-tokens |
| **Platform surfaces in scope** | STS: reuses existing KMS/S3/SQS/Lambda (no new component). App backend: **new** — KMS signing key, JWKS publishing, hosting/runtime, likely new account/pipeline |
| **Standard** | Platform constraints lens (`_standards/platform/`) + project `platform-baseline.md` |
| **Altitude** | TD-level fit + conditional new-platform-surface security |
| **Author (drafting)** | check-platform-constraints |
| **Date** | 2026-06-24 |
| **Status** | DRAFT — conformance evidence; NOT a sign-off |

> **No platform baseline declared.** Neither repo declares `.claude/standards/` with a
> Platform / CI-CD baseline. Per the skill, specific values (regions, approved services,
> quotas, egress) are recorded as `[gap]` — not invented. The categories are still assessed.

## Fit findings (per `PLAT-*`)

| `PLAT-*` | Constraint | Current TD state | Declared value (source) | Fit? / Gap |
|----------|------------|------------------|-------------------------|------------|
| PLAT-1 | Data residency & jurisdiction | STS: no new data location (reuses existing stores). App backend: new KMS key + registry copy — location unstated | `[gap]` — no baseline declared | **Finding (app backend)**: state the region for the app-backend KMS key + registry copy (UK expected for citizen identity) |
| PLAT-2 | Approved services / components | STS: KMS/S3/SQS/Lambda (already in use). App backend: KMS + JWKS host — services unstated | `[gap]` | **Finding (app backend)**: confirm its services are on the approved list (out-of-STS-estate, app team owns) |
| PLAT-3 | Tenancy & isolation | STS unchanged. App backend is a separate trust domain from STS (intended isolation) | `[gap]` | Fits intent; declare the app backend's account/tenancy boundary |
| PLAT-4 | Resource, quota & scaling limits | STS: additive claim — negligible. App backend: token-mint load unstated | `[gap]` (ties to the NFR scale `[gap]`) | **Finding**: size app-backend issuance load vs quotas (low priority; cheap op) |
| PLAT-5 | Network egress & connectivity | STS unchanged. App backend → departments (outbound, wide blast radius); may fetch dept JWKS | `[gap]` | **Finding**: app backend egress to departments must obey an allow-list (each department is an approved external integration) |
| PLAT-6 | Platform change surface | **STS: NO new component** (claim + registry data, reusing infra). **App backend: YES** — new KMS key, JWKS publishing, hosting, likely new account/pipeline | IaC/deploy approach unstated for app backend | **Fires for the app backend** → conditional security pass below. STS inherited & cited. |

## Conditional security pass (PLAT-6 fired — for the app backend only)

> STS introduces no new platform component → **inherited platform, cited not re-verified**.
> The GOV.UK app backend is a new platform surface (out of the STS estate) → checked against
> existing controls, cited never restated. The app backend's detailed platform is owned by
> the app team; these are the surfaces this TD must flag.

| New platform component | Security control cited | Finding |
|------------------------|------------------------|---------|
| App-backend **signing key** (new KMS) | NCSC Cloud Principle 2 (asset protection); GDSW-OPS-* | Key managed in KMS, access least-privilege, rotation policy; JWKS publication integrity |
| App-backend **JWKS publishing** surface | A08:2025 (Software/Data Integrity); NCSC CP 11 | Departments trust this JWKS — its integrity/availability is now a critical dependency; protect against tampering |
| App-backend **deploy pipeline / IaC** (if new) | A03:2025 (Software Supply Chain); GDSW-SCM-*/OPS-* | New pipeline must inherit the supply-chain integrity baseline (signed builds, protected main, scanning) — or cite the platform that provides it |
| App-backend **egress to departments** | NCSC CP 11 (external interface protection); PLAT-5 | Outbound to departments via an allow-list; each department an approved integration |

> **Note:** the *application-level* security of the token issuance itself (pairwise correctness, token blast-radius containment, JWE vs signed) is **NOT** here — it is `check-security-standards` (next step). This pass covers only the new *platform* surface.

## Dispositions (gated; the assurance trail)

| `PLAT-*` / item | Disposition | Change written to TD | Owner | Date |
|-----------------|-------------|----------------------|-------|------|
| PLAT-6 + PLAT-1/2/5 + A08/A03 (app backend) | Accepted | Flagged app-backend platform-requirements note added to Architecture › Infrastructure (UK residency, approved services, egress allow-list, JWKS integrity, supply-chain baseline) — owned by app team as a dependency | Adam Higginson | 2026-06-24 |
| STS platform (no new component) | Accepted | Recorded STS platform as inherited & cited, not re-verified | Adam Higginson | 2026-06-24 |

## Outcome at handoff
- **Fit corrections written to the TD:** app-backend platform-requirements note (PLAT-1/2/5/6 + A08:2025/A03:2025).
- **New platform components introduced (and security-checked):** the GOV.UK app backend (new KMS key, JWKS publishing, egress, likely new pipeline) — checked against NCSC CP 2/11, A08:2025, A03:2025, GDSW-SCM-*/OPS-*; detailed assurance owned by the app team.
- **STS:** no new platform component — inherited & cited.
- **Gaps:** specific regions/services/quotas/egress values `[gap]` — no platform baseline declared in either repo.
- **Not done:** the change's application-level security (`check-security-standards`); sign-off (human).
