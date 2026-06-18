# GDS Way — API design & compatibility (`GDSW-API-*`)

The discipline for contracts between components — HTTP APIs and shared-module public
interfaces. The governing rule on this programme: **a shared/public contract is
change-controlled, and breaking it needs technical-design approval** (the polyrepo reality —
iOS/Android shared modules are consumed across repos, so a break ripples into work the
author can't see). Use this lens whenever a TD defines or changes an API/contract, a plan
touches a shared module, or a diff alters a public interface.

> Provenance honesty: **the GDS Way has no dedicated APIs standard page.** These controls
> are house conventions for this programme; the relevant external reference is GOV.UK's
> separate "API technical and data standards" guidance (not a GDS Way page). The closest
> GDS Way pages are `standards/publishing-packages.html` (publishing shared packages) and
> `standards/tracking-dependencies.html` (consuming them).

## Controls

### `GDSW-API-1` — a shared/public contract is change-controlled; a break needs TD approval
- **house convention:** owned by this programme's polyrepo shared-module rule (cross-ref
  `generate-implementation-plan`, which routes an unapproved break to the technical-design
  process; related GDS Way page: `standards/publishing-packages.html`).
- **Checkable:** a change to a shared module's **public** API (or an HTTP contract other
  services depend on) is flagged; if it is **breaking**, it must carry a TD approval
  reference. An unapproved breaking change is a finding routed to the architect — never a
  plan-time or implement-time decision.

### `GDSW-API-2` — APIs are versioned; breaking changes go behind a new version
- **house convention:** this programme's API rule (external reference: GOV.UK API technical
  and data standards — versioning).
- **Checkable:** the API has an explicit versioning strategy; a breaking change is shipped
  as a **new version**, not mutated into the existing one. At TD-level this is checked as
  the *strategy the design commits to*.

### `GDSW-API-3` — contracts are documented
- **house convention:** this programme's API rule (external reference: GOV.UK API technical
  and data standards — documenting APIs / OpenAPI).
- **Checkable:** an HTTP API has a machine-readable contract (OpenAPI); a shared module has
  an explicit, documented public interface. An undocumented public contract is a finding.

### `GDSW-API-4` — backward-compatible by default: deprecate, then remove
- **house convention:** this programme's API rule (external reference: GOV.UK API technical
  and data standards — backwards compatibility).
- **Checkable:** removals and signature changes to a public contract go through a
  **deprecation** path (announced, dual-supported for a window) rather than a silent break.
  A diff that deletes a public field/endpoint with no deprecation is a finding (and, if
  breaking, also `GDSW-API-1`).

## Highest-value questions
- Does this diff touch a **public** contract or a shared-module interface? (If unsure,
  treat as public.)
- If it changes one, is the change **non-breaking** — or does it carry a TD approval?
- Is the contract versioned and documented, or is compatibility being assumed?

## Deep tier
Pull only when about to record the control Contested / Deferred / applicability Unclear:
- GDSW-API-1 (shared-contract change control; breaking vs non-breaking) — deep: deep/gdsw-api-1.md

Source: house conventions for this programme. Related GDS Way pages:
gds-way.digital.cabinet-office.gov.uk — Publishing packages, Tracking dependencies. External
reference: GOV.UK API technical and data standards. Shared-module rule: see
`generate-implementation-plan`.
