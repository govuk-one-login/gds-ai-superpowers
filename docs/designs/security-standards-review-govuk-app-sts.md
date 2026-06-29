# Security Standards Review — TD GOV.UK App / STS service tokens

| | |
|---|---|
| **Design (TD)** | td-govuk-app-sts-service-tokens |
| **Surfaces in scope** | Backend/API (STS access token + claim; app-backend department-token issuance); cryptographic identity derivation (x-gov-sub-id, per-department pairwise); key material (app-backend KMS); external interfaces to departments; PII/correlation |
| **Standard** | Library security standards (OWASP Top 10:2025, NCSC Cloud Principles, NCSC Secure by Design; MASVS deferred — app frontend out of scope) |
| **Altitude** | TD-level conformance (code-level realisation is `review-security`) |
| **Author (drafting)** | check-security-standards |
| **Date** | 2026-06-24 |
| **Status** | DRAFT — conformance evidence + **proposed sizing pending human acceptance**; NOT a sign-off |

> Inherited platform (cited, not re-verified here): STS supply-chain/pipeline/repo/IAM baseline (A03:2025) — no `.claude/standards` baseline declared, so marked *inherited — baseline not declared (open)*. The app-backend's **new** platform surface was security-checked in `check-platform-constraints` (PLAT-6).

## Conformance findings (per checklist row)

| Checklist row | Proposed `Applicable` + cited controls | Rationale / gap |
|---------------|----------------------------------------|-----------------|
| **Security Controls / Requirements** | **Yes** — A06:2025 (Insecure Design — the pairwise-consistency logic is the central design-security concern); A04:2025 (Cryptographic Failures — SHA256 derivation, **no salt** → enumeration risk if an input is guessable; signing key management); A07:2025 (Authentication Failures — department tokens must be unforgeable, short-TTL, unpredictable `jti`); A01:2025 (Broken Access Control — a department token must reach **only** its bound department `aud`; deny the STS service-token feature for this client); NCSC CP 11 (external interfaces to departments) | Controls named; the **JWE-vs-signed + TTL** decision is still deferred (carried as a control to define). The **no-salt** construction needs A04 scrutiny in the threat model (is `x-gov-sub-id` / `subjectId` guessable/enumerable?). |
| **Best Practice / NCSC Guidance** | **Yes** — NCSC Cloud Principles 1 (transit), 2 (asset/key protection), 11 (external interface), 13 (audit); NCSC Secure by Design posture | CNI implications: identity to government departments — significant but the system is not itself CNI (see Criticality). |
| **OWASP MASVS** | **Deferred / partial** — app **frontend out of scope**, but the access token carrying `x-gov-sub-id` resides on-device → MASVS-STORAGE-1 applies to that workstream | Flag to the app-frontend workstream; not ticked here as the surface is out of scope for this TD. |
| **Security Policy Implications** | **Yes** — **GDPR / privacy**: the per-department pairwise ID is an **anti-correlation** control (prevents departments cross-linking the same citizen). A weak/leaky derivation, or logging the mapping, undermines a data-protection property. Wider risk: **Privacy/Legal consultation required.** | Strong privacy implication — recommend Privacy + Legal in the loop. |
| **Criticality** | **No (not CNI)** — high-impact citizen identity, but the service is not itself critical national infrastructure | Confirm with the human; if departments include CNI consumers, revisit. |
| **Security Testing** | **Yes** — golden-vector tests proving pairwise reproduces front-door values (functional security test = the consistency oracle); negative tests that the GOV.UK app is **denied** the service-token path; token-forgery/expiry tests; ITHC/pen-test recommended given blast radius | Ties to the blocking spike — the golden-vector test is both an assurance and a correctness control. |
| **Threat Modeling** | **NOT TICKED HERE** — owned by `threat-model` | Left for step 6 (gated on the accepted sizing). |

## Proposed sizing (PROPOSAL — pending human acceptance; not ticked)

**Proposed: Major.** Rationale: tokens reach **government departments outside One Login** (wide blast radius); a cryptographic-identity error **mis-identifies citizens** to government, with data-protection consequences; the derivation is bespoke and must match an external system bit-for-bit; new key material and a new external-interface surface are introduced. This warrants the full Secure by Design lifecycle and a **mandatory threat model**. (Minimum defensible alternative: **Moderate** — if the human judges reuse of proven STS patterns + the doc-only front-door change materially lowers it. Either Moderate or Major makes threat-model mandatory.)

## Dispositions (gated; the assurance trail)

| Row / sizing | Disposition | Change written to TD | Owner | Date |
|--------------|-------------|----------------------|-------|------|
| Security Controls / Requirements | Accepted | Row = Yes; A06/A04/A07/A01 + NCSC CP 11 cited; JWE-vs-signed+TTL noted as control to define | Adam Higginson | 2026-06-24 |
| Best Practice / NCSC | Accepted | Row = Yes; NCSC CP 1/2/11/13 + Secure by Design | Adam Higginson | 2026-06-24 |
| Security Policy Implications (GDPR) | Accepted | Row = Yes; pairwise ID as anti-correlation control; Privacy + Legal consultation recommended | Adam Higginson | 2026-06-24 |
| Security Testing | Accepted | Row = Yes; golden-vector + denial + forgery/expiry tests + ITHC | Adam Higginson | 2026-06-24 |
| MASVS | Deferred | Flagged to app-frontend workstream (out of scope here) | Adam Higginson | 2026-06-24 |
| Criticality | Accepted | Not CNI (confirm dept consumers) | Adam Higginson | 2026-06-24 |
| **Sizing** | **Skipped (not accepted)** | Left unticked; **Major proposed**; per risk-tiering, no accepted sizing → threat-model defaults to RUN (confirmed step 6) | Adam Higginson | 2026-06-24 |

## Outcome at handoff
- **Rows written to the TD:** Security Controls, NCSC guidance, GDPR/policy, Security Testing, Criticality (MASVS deferred).
- **Sizing:** NOT accepted this pass (Major proposed). Threat-model is **not** skipped — it defaults to running.
- **Not done:** threat discovery (`threat-model`, step 6); code-level security (`review-security`); sign-off + risk acceptance (human).
