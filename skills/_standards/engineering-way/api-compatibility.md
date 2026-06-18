# Engineering Way — API design & compatibility (`ENG-API-*`)

The discipline for contracts between components — HTTP APIs and shared-module public
interfaces. The governing rule on this programme: **a shared/public contract is
change-controlled, and breaking it needs technical-design approval** (the polyrepo reality —
iOS/Android shared modules are consumed across repos, so a break ripples into work the
author can't see). Use this lens whenever a TD defines or changes an API/contract, a plan
touches a shared module, or a diff alters a public interface.

> Provenance honesty: **this standard has no dedicated external APIs page.** These controls
> are house conventions for this programme.

## Controls

### `ENG-API-1` — a shared/public contract is change-controlled; a break needs TD approval
- **house convention:** owned by this programme's polyrepo shared-module rule (cross-ref
  `generate-implementation-plan`, which routes an unapproved break to the technical-design
  process).
- **Checkable:** a change to a shared module's **public** API (or an HTTP contract other
  services depend on) is flagged; if it is **breaking**, it must carry a TD approval
  reference. An unapproved breaking change is a finding routed to the architect — never a
  plan-time or implement-time decision.

### `ENG-API-2` — APIs are versioned; breaking changes go behind a new version
- **house convention:** this programme's API rule.
- **Checkable:** the API has an explicit versioning strategy; a breaking change is shipped
  as a **new version**, not mutated into the existing one. At TD-level this is checked as
  the *strategy the design commits to*.

### `ENG-API-3` — contracts are documented
- **house convention:** this programme's API rule.
- **Checkable:** an HTTP API has a machine-readable contract (OpenAPI); a shared module has
  an explicit, documented public interface. An undocumented public contract is a finding.

### `ENG-API-4` — backward-compatible by default: deprecate, then remove
- **house convention:** this programme's API rule.
- **Checkable:** removals and signature changes to a public contract go through a
  **deprecation** path (announced, dual-supported for a window) rather than a silent break.
  A diff that deletes a public field/endpoint with no deprecation is a finding (and, if
  breaking, also `ENG-API-1`).

## Highest-value questions
- Does this diff touch a **public** contract or a shared-module interface? (If unsure,
  treat as public.)
- If it changes one, is the change **non-breaking** — or does it carry a TD approval?
- Is the contract versioned and documented, or is compatibility being assumed?

## Deep tier
Pull only when about to record the control Contested / Deferred / applicability Unclear:
- ENG-API-1 (shared-contract change control; breaking vs non-breaking) — deep: deep/eng-api-1.md

Source: house conventions for this programme. Shared-module rule: see `generate-implementation-plan`.
