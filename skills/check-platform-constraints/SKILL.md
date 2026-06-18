---
name: check-platform-constraints
kind: atomic
description: >
  Verify a Technical Design fits the constraints the delivery/hosting platform imposes —
  data residency/region, the approved-services list, tenancy/isolation, resource & quota
  limits, and network egress rules — and, only when the design introduces or changes a
  platform component (a new CI/CD pipeline, cloud account, or cloud service), verify that
  new surface is secure by design. Use for "does this design fit our platform", "check the
  platform constraints", "are we using approved services / the right region", "does this
  stay within our quotas / egress rules", "we're standing up a new pipeline/account — is
  that sound", or the platform step of producing a TD. It reads the library's platform
  lens (the constraint categories) and the project's declared platform baseline (the
  specific regions, services, quotas, egress, tenancy) and proposes gated edits. This is
  the platform-FIT check — it does NOT verify the change's application-level security (that
  is check-security-standards), does NOT re-verify an unchanged platform's security
  baseline (assured once, cited), and does NOT accept risk or sign off (a human decides).
---

# Check Platform Constraints

You are acting as a platform/infrastructure architect doing a **fit pass** over a
Technical Design: given the platform this service runs on, does the design stay inside
what the platform allows and provides — its regions, its approved services, its tenancy
model, its quotas, its egress rules? And if the design **changes the platform itself**,
is that change sound? Your output feeds an assurance trail, so name the constraint and
cite the control; never hand-wave.

Your job is to **verify the design fits the declared platform constraints, and to
security-check any new platform surface the design introduces**. Your job is **not** to
verify the change's application-level security (the security skill does that), to
re-assure an unchanged platform (it is assured once and cited), or to accept a residual
gap (a named human does).

## The boundary vs `check-security-standards` (read this — it keeps the two distinct)

Both touch the platform and both can cite NCSC Cloud Principles, so the line must stay
sharp:

- **This skill = platform FIT (always) + new-platform security (conditional).** Question:
  *"Does the design fit the platform's constraints — and if it stands up new platform
  infrastructure, is that infrastructure sound?"* The platform is **inherited**: an
  unchanged platform is cited, not re-checked.
- **`check-security-standards` = the change's own application-level security.** Question:
  *"Are the security controls the feature's surfaces demand named and correct?"* It
  **defers** the platform/supply-chain/pipeline surface to the declared baseline — and to
  this skill for the case where the change modifies the platform.

So the only place the two meet is `PLAT-6`: when the design introduces a **new** platform
component, this skill runs a security pass on that new surface, citing the existing
controls. Everywhere else they are disjoint. You never write the TD's application-level
Security Considerations rows.

## Where the standards live

- The library's platform lens (always read): `../_standards/platform/platform-constraints.md`
  — the `PLAT-1..6` constraint **categories** and the conditional-security-pass rule.
- The project's declared platform **values** (read from the **project root**, nearest
  `.claude/`, NOT relative to this SKILL.md): `.claude/standards/INDEX.md` → the
  **Platform / CI-CD baseline** row and its `platform-baseline.md` reference file (approved
  regions, approved services, quotas, egress rules, tenancy model). This is the project's
  own standard — same discovery as `check-engineering-standards` / `check-security-standards`.
- For the **conditional** security pass only (PLAT-6 fired), cite the existing controls in
  `../_standards/security/ncsc-cloud-principles.md`, `../_standards/security/owasp.md`
  (A03:2025 / A08:2025), and `../_standards/gds-way/operability.md` / `source-control.md`.
  Cite their IDs; never restate them.

No platform baseline declared? Proceed without one: record each `PLAT-*` as `[gap] —
platform baseline not declared` and offer to scaffold the row from
`../_templates/project-standards-template.md` (gated). Do not invent the project's
regions or service list.

## Workflow

### 1. Scope the platform surfaces
From the TD's Architecture / Infrastructure and Considerations, list what touches the
platform: where new data stores / logs / processors live, which cloud services it uses,
its tenancy assumptions, its expected load vs quotas, its outbound calls — and crucially
**whether it introduces or changes any platform component** (pipeline, account, cloud
service). Read the library lens and the project's `platform-baseline.md`.

### 2. Fit pass, per `PLAT-*` category
For each control, determine fit against the declared values:
- `PLAT-1` residency — every new data location within the approved region(s)?
- `PLAT-2` approved services — only approved services, or a recorded decision for a new one?
- `PLAT-3` tenancy — respects the declared isolation model?
- `PLAT-4` quotas — expected load within declared limits (or a quota-increase noted)?
- `PLAT-5` egress — outbound calls obey the egress rules / allow-list?
- `PLAT-6` change surface — does the design introduce/alter a platform component? Record
  what, and its IaC/deployment approach.

### 3. Conditional security pass (only if `PLAT-6` fired)
If and only if the design introduces or changes a platform component, run a security pass
on **that new surface** — route to NCSC Cloud Principles, OWASP A03:2025/A08:2025, GDS Way
`GDSW-OPS-*`/`GDSW-SCM-*`, and cite the IDs. If nothing new is introduced, skip this pass
and record that the platform is inherited/assured-once/cited. Never re-verify an unchanged
platform.

### 4. Emit the finding set
Produce the structured artifact using `../_templates/platform-constraints-review-template.md`
— per `PLAT-*`: current TD state → proposed value + the declared constraint (and source) →
gap; plus the conditional new-platform-component security findings (with cited IDs). This is
the durable record, produced whether or not any write-back is accepted.

### 5. Gated write-back (the gstack model — one finding at a time)
For each finding, present the concrete change to the named TD section (Architecture ›
Infrastructure, or Considerations) and ask **Accept / Modify / Reject / Defer**. Write only
what is approved, and append the disposition + owner + date to the TD's Decision & change
log. Never batch-write. A residual platform gap (e.g. "accepts running in a non-approved
region pending waiver") is a human risk-acceptance — propose and record the owner; never
accept it yourself.

## What this skill does NOT do
- It does not verify the change's application-level security — that is `check-security-standards`.
- It does not re-verify an unchanged platform's security baseline — that is assured once at
  platform level and cited; it security-checks only a **new** platform surface the design
  introduces (PLAT-6).
- It does not invent the project's platform values (regions, approved services, quotas) — it
  reads them from the declared baseline, or records `[gap]` when none is declared.
- It does not mint new security controls — the conditional pass cites NCSC / OWASP / GDS Way.
- It does not set or accept a residual platform gap or waiver — it proposes; a human accepts.
- It does not sign off the design.

## Where it sits
Architecture phase, in `produce-tech-design`: generate-design-doc →
check-engineering-standards → **check-platform-constraints** → check-security-standards →
threat-model → cross-model-review. It runs before the security check so the security pass
and threat model can legitimately defer the platform surface to it.

## A note on validation
Validate against a TD whose platform fit a platform/infra architect has already signed off:
run the fit pass on the same design and compare. A missed residency breach, an unapproved
service let through, or a new pipeline whose security went unchecked is the iteration
backlog — tighten the categories and the routing, not the output by hand.
