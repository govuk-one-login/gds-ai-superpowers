# TD Public Feedback API (SYNTHETIC — eval fixture, not a real system)

| | |
|---|---|
| **Summary** | A small public HTTP API that accepts free-text feedback submissions and exposes an authenticated admin endpoint to read them. |
| **Owner** | Test Fixture |
| **Date Created** | 2026-01-01 |
| **Jira Link** | N/A |

> Synthetic fixture for the evals harness. Any resemblance to a real service is
> coincidental. The Security Considerations section below is intentionally left
> **unset** so check-security-standards has something to propose.

## Goals

Let members of the public submit short feedback on a service, and let a small admin
team read it.

## Context

New standalone microservice. No existing service does this. Submissions are stored for
90 days then deleted.

## Non-functional requirements & success criteria

- **Scale / load** — up to 50 submissions/sec at peak.
- **Performance** — p95 submit latency < 300ms.
- **Availability / resilience** — 99.5% monthly.
- **Security & privacy posture** — feedback may contain personal data typed by users.
- **Success criteria** — submissions persist; admin can list them; abusive volume is rejected.

## Options Considered

### Option 1 — Managed API + managed datastore (Proposed)
A stateless HTTP service behind the platform gateway, writing to a managed document store.

**Pros**
- Minimal ops.

**Cons**
- Vendor coupling.

**Risks**
- [Low] Document store schema drift.

## Constraints

- Must ship in one sprint.

## Assumptions & open questions

- **Assumption:** the platform gateway terminates TLS — owner Test Fixture, to confirm.
- **Open question:** rate-limit thresholds.

## Architecture

A single stateless service: a `POST /v1/feedback` write path and a `GET /v1/admin/feedback`
read path, backed by a managed document store.

### Infrastructure

One managed API service + one managed document store.

### Mobile modules

N/A.

### Test approach

- **Test infrastructure** — new integration harness against an ephemeral store.
- **Coverage commitment** — [gap].

## API design & contracts

| Endpoint | Direction | Request | Response | Notes |
|----------|-----------|---------|----------|-------|
| POST /v1/feedback | client → service | { text: string } | 202 { id } | public; unauthenticated |
| GET /v1/admin/feedback | admin → service | — | 200 { items[] } | requires admin auth |

## Considerations

- **Deployment** — rolling.
- **Logging** — request logs.

## Security Considerations

> This section is a collaboration between the Security and Architecture teams to embed
> security early.

**Expected level of security input** (one box — a recorded human decision):

| Size | Description | Selected |
|------|-------------|----------|
| None | No security impact. No controls or testing required. | [ ] |
| Minor | Low risk. Standard controls (e.g. logging, access) apply. No bespoke testing. | [ ] |
| Moderate | Some sensitive data, integrations, or third-party risk. Threat modelling and control mapping required. | [ ] |
| Major | High-risk components, sensitive data, or critical infrastructure. Full Secure by Design lifecycle applies. | [ ] |

**Rationale:** [proposed — pending security review]

### Security Controls and Requirements Checklist

| Area | Security Domain | Requirements / Considerations | Applicable |
|------|-----------------|-------------------------------|------------|
| Threat Modeling | Design | Has a formal Threat Model been completed or updated for the scope of this TD? | [ ] Completed (Ref ID) [ ] Scheduled (Date) [ ] Not Required |
| Security Controls / Requirements | Specification | List required security controls. | [ ] Yes / [ ] No |
| Best Practice / NCSC Guidance Identified | Specification | Specific guidance to follow. | [ ] Yes / [ ] No |
| OWASP MASVS Standard | Verification | If this TD impacts the mobile app, MASVS MUST be followed. | [ ] Yes / [ ] No |
| Security Policy Implications | Governance | Compliance / policy concerns. | [ ] Yes / [ ] No |
| Criticality | Specification | Criticality of the TD and components. | [ ] Yes / [ ] No |
| Security Testing Considerations | Planning | Specific testing needs. | [ ] Yes / [ ] No |

Wider risk implications beyond security (Privacy, Legal, Fraud)? [ ] Yes / [ ] No.

## Decision & change log

| Finding / source | Section touched | Proposed change | Disposition | Owner | Date |
|------------------|-----------------|-----------------|-------------|-------|------|
| (fixture) | — | initial synthetic draft | Accepted | Test Fixture | 2026-01-01 |
