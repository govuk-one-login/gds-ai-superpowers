# Threat Model — [System / Service / Component / Flow Name]

| | |
|---|---|
| **Subject of analysis** | [what is being modelled] |
| **Version / design ref** | [design doc version this models] |
| **Author (drafting)** | [architect — skill assists] |
| **Date** | [date] |
| **Status** | DRAFT — pending human review and risk acceptance |

> This threat model was drafted with assistance and follows STRIDE (method) with
> OWASP Top 10:2025, OWASP MASVS v2, and NCSC Cloud Security Principles as
> governing lenses, framed against NCSC Secure by Design. It enumerates and
> structures threats; it does **not** constitute acceptance of any residual
> risk. Open risk decisions are listed at the end for an accountable owner.

## 1. Scope and assets

**In scope:** [components, flows, boundaries covered]
**Out of scope:** [explicitly excluded, with reason]

**Assets worth protecting:**
- [asset] — [why it matters]
- ...

**Actors:**
- [actor] — [capabilities / trust level]
- ...

## 2. Data-flow model and trust boundaries

[Prose description of the data flow.]

```mermaid
flowchart LR
  %% actors, processes, data stores; mark trust boundaries with subgraphs
```

**Trust boundaries identified:**
- [boundary] — [what crosses it]
- ...

## 3. Threat register

[One record per threat, using the per-threat structure from the skill. Group by
component or by data flow, whichever reads more clearly.]

### [Component / flow]

```
THREAT-001: <title>
  Component / flow:
  STRIDE category:
  Trust boundary:
  Asset at risk:
  Attack path:
  Governing control:
  Likelihood:
  Impact:
  Existing mitigation:
  Residual risk:
  Recommendation:
  Needs human risk decision:
```

## 4. Open questions / design gaps

[Where the design is silent on something security-relevant — list it, don't
assume a mitigation exists.]

## 5. Secure by Design framing

**Security considered from the start:** [assessment]
**Proportionate, threat-informed:** [reference to register]
**Assurance and revalidation:** [what backs this; when to revisit]
**Recorded trade-offs:** [any security trade-offs made and why]

## 6. Open risk decisions (handoff to accountable owner)

> The recommendations below are advisory. Each residual risk requires a decision
> by a named accountable owner. This is not an acceptance.

```
OPEN RISK DECISION — THREAT-NNN
  Residual risk:
  Decision required:  Accept / Mitigate further / Avoid
  Accountable owner:  [role]
  Recommendation (advisory):
```

## 7. Proposed design updates & decisions

> Stage-7 record: each actionable finding walked back into the source design, the
> concrete change proposed, and the human's disposition. The skill proposes and
> records; the named owner decides and accepts. This table — not a silent edit —
> is the assurance trail for what the design model changed and who owned it.

| Finding | Source design field / section | Proposed change | Disposition | Owner | Date |
|---------|-------------------------------|-----------------|-------------|-------|------|
| THREAT-NNN | [e.g. "Threat Modeling" checklist row] | [e.g. set to "Completed (Ref: this TM)"] | Accepted / Modified / Rejected / Deferred | [name] | [date] |
| THREAT-NNN | [e.g. security sizing] | [e.g. "Minor" → "Moderate" for the sensitive-data path] | … | [name] | [date] |
