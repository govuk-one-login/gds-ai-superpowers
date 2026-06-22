# Platform constraints (`PLAT-*`)

The constraints the **delivery and hosting platform** imposes on a design: where data
may live, which services may be used, how tenants are isolated, what resource and
network limits apply, and what happens when the design **changes the platform itself**.
Read this lens when a TD is checked for platform fit (`check-platform-constraints`).

This is the **fit** surface, distinct from application-level security (which
`check-security-standards` owns) and from the engineering disciplines
(`check-engineering-standards`). It is the architect-pipeline home for the
"inherited platform" surface that `threat-model` and `check-security-standards`
deliberately defer — **assured once at platform level, cited not re-modelled, unless
the change alters it**.

## House identifiers — `PLAT-*` (categories here; values are the project's)

Like the `GDSW-*` scheme, these IDs are **authored by this library** — so we own
their stability (don't renumber casually; retire rather than reuse). But unlike a security
framework, the library cannot enumerate the *values*: the approved regions, the approved-
services list, the quotas, the egress rules, the tenancy model are **programme-specific**.
So the split is:

- **The library owns the categories and the method** — the `PLAT-*` controls below: what
  to check, how, and why.
- **The project declares the specific values** — in its `.claude/standards/` register, the
  **Platform / CI-CD baseline** row and its `platform-baseline.md` reference file (region
  allow-list, approved services, quotas, egress rules, tenancy model). `check-platform-
  constraints` reads those and verifies the design against them.

No project declaration → the skill cannot assert a value; it records each control as
`[gap] — platform baseline not declared` and proceeds. Provenance for every control here is
**`house convention:`** (owned by `check-platform-constraints`); where a control meets a
security surface it **cross-references** the owning security control and never restates it.

## The conditional security pass (PLAT-6 is the trigger)

By default this lens checks **fit** only. A platform whose security is assured elsewhere is
cited, not re-verified. **But when the design introduces or changes a platform component**
(a new CI/CD pipeline, a new cloud account, a new cloud service) — surfaced by `PLAT-6` —
that **new** surface is now in scope, and `check-platform-constraints` runs a security-
baseline pass on it, **routing to existing controls** (NCSC Cloud Principles, OWASP
**A03:2025**/**A08:2025**, GDS Way `GDSW-OPS-*`/`GDSW-SCM-*`). It mints no new security
content — it cites those. This is exactly the "in scope only if the change modifies them"
carve-out the security skills defer.

## Controls

### `PLAT-1` — data residency & jurisdiction
- **house convention:** owned by `check-platform-constraints`; cross-ref **NCSC Cloud
  Principle 2** (asset protection — physical location of data).
- **Checkable:** data at rest and in processing stays within the project's approved
  region(s)/jurisdiction(s) as declared in `platform-baseline.md`. A store, queue, backup,
  log sink, or third-party processor outside the allowed region is a finding. Design silent
  on where a new data store lives is a `[gap]`.

### `PLAT-2` — approved services / components
- **house convention:** owned by `check-platform-constraints`.
- **Checkable:** the design uses only platform/cloud services on the project's **approved
  list**. A service not on the list is a recorded **decision** (named, with the approval
  route), not an implementation-time default. An unlisted, unjustified service is a finding.

### `PLAT-3` — tenancy & isolation
- **house convention:** owned by `check-platform-constraints`; cross-ref **NCSC Cloud
  Principle 3** (separation between customers/tenants).
- **Checkable:** the design respects the platform's tenancy model (shared vs dedicated
  cluster/account, namespace/network isolation, row-level separation) as declared. A design
  that breaks an isolation boundary the platform assumes — or assumes dedicated capacity on
  a shared platform — is a finding.

### `PLAT-4` — resource, quota & scaling limits
- **house convention:** owned by `check-platform-constraints`.
- **Checkable:** the design fits the platform's runtime limits — CPU/memory/storage quotas,
  rate/connection/payload caps, and the scaling model (auto-scaling bounds, instance caps).
  A design whose expected load exceeds a declared quota, with no quota-increase request
  noted, is a finding. (Performance *targets* are an NFR; this is *platform headroom*.)

### `PLAT-5` — network egress & connectivity
- **house convention:** owned by `check-platform-constraints`; cross-ref **NCSC Cloud
  Principle 11** (external interface protection).
- **Checkable:** outbound/external calls follow the platform's egress rules — via the
  approved proxy/allow-list, to approved external integrations only. A design calling an
  arbitrary external endpoint, or assuming open egress on a locked-down platform, is a
  finding.

### `PLAT-6` — platform change surface (the trigger)
- **house convention:** owned by `check-platform-constraints`.
- **Checkable:** any **new or changed platform component** the design introduces — a new
  CI/CD pipeline or pipeline stage, a new cloud account/subscription, a new managed cloud
  service or shared infrastructure — is **explicitly declared** in the design, with its IaC/
  deployment approach. When this control fires, run the **conditional security pass** above
  on that new surface. A design that quietly stands up new platform infrastructure without
  declaring it is a finding (and the security pass cannot scope what isn't declared).

## Highest-value questions
- Where does every new data store / log sink / processor physically live — within the
  approved region?
- Does the design reach for any service not on the approved list, and is that a recorded
  decision or a silent default?
- Does anything here introduce **new** platform infrastructure (pipeline, account, cloud
  service)? If so, has its security been checked (not just its fit)?
- Does the expected load fit the platform's quotas, and does external connectivity obey the
  egress rules?

Source: house convention (this library). The constraint **values** are project-declared in
`.claude/standards/` (`platform-baseline.md`). Security cross-references point to the
existing `security/` and `gds-way/` lenses; nothing is restated here.
