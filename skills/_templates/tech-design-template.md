# TD [Title]

| | |
|---|---|
| **Summary** | [one-line summary of the change] |
| **Owner** | [name — design owner] |
| **Date Created** | [date] |
| **Jira Link** | [link or N/A] |

> **DRAFT — assisted draft, pending human review and risk acceptance.** Drafted
> with assistance from the architect pipeline. The Security Considerations sizing
> and checklist entries below are **proposals**, not acceptances — a named owner
> ticks and accepts them. `[gap]` marks a point the source brief was silent on; an
> architect must resolve it, not assume it. A **framed** TD (from `frame-design`)
> has Goals, Context, NFRs, Assumptions, Standards and a recommended direction
> filled, with Architecture, API, and Security still to come from the later steps.

## Approach & key decisions

> **The sign-off surface.** A reader should be able to approve the *direction* from
> this block alone, before reading the detail below — it is what an async reviewer
> reads first, and it is the lightweight gate the architect signs off before the full
> draft is deepened. Keep it tight: the chosen approach, the shape of the change, and
> the calls that matter. Fill it from the detail (it summarises what is below) but
> keep it at the top.

- **Chosen approach** — [one or two lines: the direction, and why over the alternatives]
- **Shape of the change** — [reuse / extend / new at a glance — the headline modules and the public API surface this touches]
- **Key decisions** — [the 3-5 calls that actually shaped the design; point down to Options Considered]
- **Open questions / `[gap]`s blocking sign-off** — [what a reviewer must resolve, or "none"]

## Goals

[What this change is for — the objective, in the user's / service's terms.]

## Context

[Background, the problem, the current state, why this is needed now. Link related
designs.]

## Non-functional requirements & success criteria

[Filled during framing. The NFRs the design must meet and what "done" looks like —
do not leave these implicit.]

- **Scale / load** — [expected volume; or `[gap]`]
- **Performance** — [latency / throughput targets; or `[gap]`]
- **Availability / resilience** — [SLO, failure modes; or `[gap]`]
- **Security & privacy posture** — [high-level expectation; the security skills detail it]
- **Accessibility** — [if user-facing; or N/A]
- **Success criteria** — [measurable signals this is working / acceptance]

## Options Considered

### Option 1 — [name] (Proposed | Dismissed)

[One-line description of the option.]

**Pros**
- [pro]

**Cons**
- [con]

**Risks**
- [[Low|Medium|High]] [risk]

### Option 2 — [name] (Proposed | Dismissed)

[Repeat the block per option. Preserve dismissed options and the reason they were
dismissed — the rejected paths are part of the design record.]

**Build vs reuse — when an option leans on an existing asset.** Where an option
reuses or extends an existing asset (a module, library, or test infrastructure named
in the source map — e.g. an existing vocabulary library), evaluate it explicitly
against building new, so the call is on the record rather than assumed:

| Existing asset | Fit to requirement | Gaps to close | Cost: extend vs build-new | Lock-in / maintenance | Call |
|----------------|--------------------|---------------|----------------------------|-----------------------|------|
| [asset] | [how well it fits] | [what's missing] | [extend ↔ build-new] | [risk] | Reuse / Extend / Build new |

## Constraints

- [time / dependency / scope constraint, e.g. a downstream team's timeline]

## Assumptions & open questions

[Filled during framing. Turn the brief's silences into explicit, owned assumptions,
and list what is still unknown — including anything that warrants a spike/POC before
committing.]

- **Assumption:** [stated assumption] — owner [name], [validated? / to confirm]
- **Open question:** [unresolved question blocking or shaping the design]
- **Spike / POC needed:** [genuine unknown to de-risk first, if any]

## Architecture

> **Architecture / module / contract level only.** This TD specifies the
> architecture and the **public** API contracts (what other parties build against).
> It stops above code: **internal module-to-module contracts, function/line design,
> project/file structure, and low-level test contracts (specific cases, mocks,
> assertions) belong to `plan-and-implement`**, per story — do not specify them here.

[Solution overview: the components and how they fit together to deliver the chosen
option, grounded in the existing code. Tag each component **reused** (existing,
unchanged), **extended** (existing, changed), or **new** — naming the real module
where it exists.]

```mermaid
flowchart LR
  %% components and the data/control flow between them; group by tier / trust zone
```

**Reused / extended / new**
- **Reused:** [existing module — what it provides, unchanged]
- **Extended:** [existing module — what changes, at module level]
- **New:** [new module / component — its responsibility]

### Infrastructure

[New or changed cloud (e.g. AWS) services and resources, at the service/resource
level — not IaC code. Or `N/A`.]

### Mobile modules

[New or changed app modules at module granularity, naming the existing modules
reused or extended. Or `N/A`.]

### Test approach

> **Strategy / infrastructure level only** — *not* low-level test contracts
> (specific cases, mocks, assertions), which are `generate-acceptance-tests` + the
> implementer's job, per story. Test infrastructure is an asset: tag it with the same
> reuse / extend / new lens as any module.

- **Test infrastructure (reuse / extend / new)** — [e.g. reuse the existing integration harness; extend the contract-test suite; new e2e lane; naming the real infrastructure — or `N/A`]
- **Coverage commitment** — [the bar this change is held to (e.g. per the engineering standard); or `[gap]`]

## API design & contracts

> **Public contracts only — what another team, service, or app builds against.**
> Record method + path, request/response shapes (fields + types), status/error
> cases, and the protocol. **Internal module-to-module interfaces are "how it's
> built" and do NOT belong here** — they are specified later by `plan-and-implement`,
> per story. Contract level, not handler code.

| Endpoint / message | Direction | Request (shape) | Response (shape) | Notes |
|--------------------|-----------|-----------------|------------------|-------|
| [e.g. POST /v1/resource] | [client ↔ service] | [fields] | [fields] | [protocol; error cases] |

## Considerations

> Record only what carries a **real decision for this change**. If an item is
> standard, untouched, or handled by an existing pattern, mark it `N/A` — do not
> generate generic operational prose (no boilerplate CDN/ADR text). Each item earns
> its place by stating a decision a reader could disagree with.

- **Deployment** — [rollout, migration, version-skew handling, or N/A]
- **Alarms** — [or N/A]
- **Monitoring** — [or N/A]
- **Impact to Run Books** — [or N/A]
- **TxMA Events** — [or N/A]
- **Logging** — [or N/A]

## Security Considerations

> This section is a collaboration between the Security and Architecture teams to
> embed security early. It records the security input required, the controls, and
> how their effectiveness is assessed. A non-security-impacting TD may be marked
> N/A; a TD with no controls defined yet signals that a Threat Model has not yet
> occurred and controls will be defined later.

**Expected level of security input** (one box — a recorded human decision, not an
assisted default):

| Size | Description | Selected |
|------|-------------|----------|
| None | No security impact. No controls or testing required. | [ ] |
| Minor | Low risk. Standard controls (e.g. logging, access) apply. No bespoke testing. | [ ] |
| Moderate | Some sensitive data, integrations, or third-party risk. Threat modelling and control mapping required. | [ ] |
| Major | High-risk components, sensitive data, or critical infrastructure. Full Secure by Design lifecycle applies. | [ ] |

**Rationale:** [proposed — pending security review]

### Security Controls and Requirements Checklist

This checklist must be reviewed by the Security and Architecture teams for each TD.

| Area | Security Domain | Requirements / Considerations | Applicable |
|------|-----------------|-------------------------------|------------|
| Threat Modeling | Design | Has a formal Threat Model been completed or updated for the scope of this TD? (Reference the Threat Model document ID.) | [ ] Completed (Ref ID) [ ] Scheduled (Date) [ ] Not Required |
| Security Controls / Requirements | Specification | List required security controls, or when they will be identified (e.g. strong auth, encryption, least privilege, logging, supplier assurance, vuln management). | [ ] Yes / [ ] No |
| Best Practice / NCSC Guidance Identified | Specification | Specific guidance to follow (NCSC or industry best practice; any CNI implications). | [ ] Yes / [ ] No |
| OWASP MASVS Standard | Verification | If this TD impacts the mobile app, the OWASP MASVS guidance MUST be followed. | [ ] Yes / [ ] No |
| Security Policy Implications | Governance | Compliance / policy concerns (e.g. PII impacting GDPR, encryption policy, data retention). | [ ] Yes / [ ] No |
| Criticality | Specification | Criticality of the TD and components (e.g. are they considered CNI?). | [ ] Yes / [ ] No |
| Security Testing Considerations | Planning | Specific testing needs (pen testing, SAST/DAST, misconfiguration audits, functional security tests). | [ ] Yes / [ ] No |

Wider risk implications beyond security, requiring input from Privacy, Legal and
Fraud? [ ] Yes / [ ] No — [rationale]. If so, have those teams been consulted?
[ ] Yes / [ ] No

## Supporting Documentation

- [references, IETF/standards links, related designs]

## Decision & change log

> The assurance trail. Each pipeline step appends here: the finding, the section it
> touched, the change proposed, and the human's disposition. Skills propose and
> record; a named owner decides and accepts. This table — not a silent edit — is
> the record of what the design changed and who owned each call.

| Finding / source | Section touched | Proposed change | Disposition | Owner | Date |
|------------------|-----------------|-----------------|-------------|-------|------|
| [e.g. generate-design-doc] | [e.g. Options Considered] | [e.g. keep Option 2, dismiss Option 1] | Accepted / Modified / Rejected / Deferred | [name] | [date] |
