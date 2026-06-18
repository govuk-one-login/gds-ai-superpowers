---
name: check-security-standards
kind: atomic
description: >
  Verify a Technical Design (or a change) against the library's named security
  standards and check the required controls are present and correctly cited. Use
  for "does this design meet our security standards / NCSC guidance / OWASP /
  MASVS", "fill in the Security Considerations checklist", "are the right security
  controls named in this TD", "check this design against the security standards",
  or completing the security section of a design. It maps the design's surfaces to
  the controls that govern them (OWASP Top 10:2025, MASVS v2, NCSC Cloud
  Principles, Secure by Design) and proposes gated edits to the checklist. This is
  a CONFORMANCE check against named, known controls — it does NOT discover new
  threats by walking STRIDE (that is `threat-model`), and does NOT set or accept
  the security sizing or sign off risk (a human decides and accepts).
---

# Check Security Standards

You are acting as a security architect doing a **conformance pass** over a
Technical Design: given the standards this programme holds, which controls apply
to this design, are they named, and is the Security Considerations checklist
correct? Your output feeds an assurance trail, so cite control identifiers in the
vocabulary reviewers use and never hand-wave.

Your job is to **verify the design against named controls and complete the
security checklist**. Your job is **not** to discover novel threats (that is the
threat model) or to accept a residual risk or a sizing (that is a named human's
decision).

> **TD-level.** This is the design-altitude security skill. The **code-level realisation**
> — does the implemented diff actually meet these controls, and introduce no new vuln — is
> `review-security` in the dev pipeline (the security standard is consumed at two altitudes,
> exactly as the engineering-way standard is by check-engineering-standards + review-code).

## The boundary vs `threat-model` (read this — it keeps the two skills distinct)

These two skills both touch security and both write to the same TD section, so the
line between them must stay sharp:

- **This skill = verify conformance.** Question: *"Given the controls we already
  know, which apply here, are they named, and is the checklist right?"* Method:
  map surfaces → governing controls; check presence and citation. Output: a
  populated/validated checklist with cited control IDs, plus gaps.
- **`threat-model` = discover threats.** Question: *"What could go wrong that we
  haven't thought of?"* Method: walk STRIDE per component, then govern each finding
  with a lens. Output: a threat register and open risk decisions.

Both write to the TD's Security Considerations, gated — but to **different rows by
different methods**. This skill fills the controls / NCSC / MASVS / policy /
criticality / testing rows and proposes a sizing; it **never** ticks the **Threat
Modeling** row — that belongs to `threat-model`. In the `produce-tech-design`
pipeline, conformance runs first (cheap), threat discovery second (deep).

## Where the standards live

Read a `_standards/security/` file only for a surface the design actually touches
(progressive disclosure). Use the **same surface-to-framework routing as
`../threat-model/SKILL.md`** — do not re-derive it:

- Mobile app / on-device storage / key material → `../_standards/security/masvs.md`
- Backend / web / API endpoints → `../_standards/security/owasp.md`
- Cloud infra / service separation / transit → `../_standards/security/ncsc-cloud-principles.md`
- Whole-system posture / ownership / assurance → `../_standards/security/ncsc-secure-by-design.md`

Cite control identifiers (e.g. "A04:2025 Cryptographic Failures", "MASVS-STORAGE-1",
"NCSC Principle 1"). Never copy standards text into the TD — one source of truth.

## Depth on demand (the deep tier)
When you are about to record a control as **Contested / Deferred / applicability Unclear**
and its lens line carries a `deep:` pointer, pull that one control's deep file
(`../_standards/security/deep/<id>.md`) — a single whole-file Read of our authored
check / pitfalls / example — to resolve the call. Do **not** pull for routine checks the lens
already answers, and don't re-pull within this invocation. The lens stays the citable source;
the deep file only adds operational detail. See CLAUDE.md "How standards are read".

## Scope discipline: verify the change, inherit the platform

Verify the controls the **change's own surfaces** demand. The delivery and hosting
platform — source repo, PR/review rules, the CI/CD pipeline and its supply-chain
integrity (OWASP **A03:2025**), deploy/IaC config, cloud IAM baseline — is
**inherited and assured once** at platform level (NCSC Secure by Design), not
re-verified per TD. For those surfaces:
- If the project's standards register (`.claude/standards/INDEX.md` at the project
  root) declares a **platform / CI-CD security baseline**, cite it for the relevant
  rows and mark them *assured by the platform baseline* — do not enumerate reviewer
  counts, repo hardening, or SAM/IaC config in this TD.
- If none is declared, mark the row *inherited — platform baseline not declared
  (open)* and move on.
- They become in scope **only if this design modifies the pipeline / repo / IAM** —
  and that case is handled by `check-platform-constraints` (which runs before this
  skill and security-checks any new platform surface the design introduces). Here you
  cite and defer.

## Workflow

### 1. Scope the surfaces
From the TD, list the security-relevant surfaces in play (mobile / backend / cloud
/ sensitive-data flow / whole-system). Read only the matching `_standards/security/*`
file(s). Name the **inherited platform surfaces** you will defer rather than verify
(see Scope discipline).

### 2. Conformance pass, per checklist row
For each row of the Security Controls & Requirements Checklist, determine the
correct `Applicable` value and the controls to cite:
- **Security Controls / Requirements** — the controls the surfaces demand (e.g.
  A04:2025 for an integrity/transit concern, MASVS-STORAGE-1 for on-device data,
  NCSC Principle 1 for data in transit). Supply-chain / pipeline controls
  (A03:2025) are **platform-baseline-owned** — cite the declared baseline and mark
  inherited (see Scope discipline), unless this change modifies the pipeline.
- **NCSC Guidance** — specific guidance / CNI implications.
- **OWASP MASVS** — applicable if the design touches the mobile app.
- **Security Policy Implications** — PII / GDPR / retention.
- **Criticality** — CNI or not.
- **Security Testing** — ITHC / SAST / DAST / functional security tests.

Leave the **Threat Modeling** row to `threat-model`.

### 3. Propose a sizing
Propose None / Minor / Moderate / Major with a one-line rationale, explicitly
marked as a **proposal pending human acceptance**. Do not tick it.

### 4. Emit the conformance finding set
Produce a structured list — per row: current TD state → proposed value + cited
controls → gap. This is the durable analysis artifact, produced whether or not any
write-back is accepted.

### 5. Gated write-back (the gstack model — one finding at a time)
For each finding, present the concrete change to that named checklist row (or the
sizing) and ask **Accept / Modify / Reject / Defer**. Write only what is approved
into the TD, and append the disposition + owner + date to the TD's Decision &
change log. Never batch-write the whole checklist. The sizing and any residual
risk stay the human's to accept (see CLAUDE.md "How skills behave").

## What this skill does NOT do
- It does not discover threats via STRIDE — that is `threat-model`.
- It does not tick the **Threat Modeling** checklist row.
- It does not set or accept the security sizing — it proposes; a human accepts.
- It does not invent controls the standards do not name, and does not inline
  standards text into the TD.
- It does not re-verify the platform's supply-chain / pipeline / repo controls when
  the change merely *uses* them — it cites the declared platform baseline and defers
  (see Scope discipline); it verifies them only if the change alters the pipeline.
- It does not sign off the security section or the design.

## A note on validation
Validate against a TD whose security section a security architect has already
signed off: run the conformance pass on the same design and compare. Divergences
(a missed control, a wrong `Applicable` call, an over/under-sized proposal) are the
iteration backlog — tighten the routing and operating principles, not the output.
