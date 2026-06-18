# NCSC Cloud Principle 3 — Separation between customers — deep

Pull when multi-tenant separation applicability is contested or unclear. Critical for any
shared/multi-tenant backend.

**Check**
- A tenant cannot read, write, or affect another tenant's data or availability: every query
  and resource access is scoped by tenant id, enforced server-side (not by the client).
- Separation model is explicit and appropriate to the data sensitivity — logical (row-level,
  enforced) vs physical (separate DBs/accounts) — and matches the threat model.
- Noisy-neighbour / resource-exhaustion isolation (quotas, rate limits) so one tenant can't DoS others.
- Shared caches, search indexes, file stores, and queues are also tenant-scoped (a common miss).

**Pitfalls**
- App-layer tenant filtering that one missing `WHERE tenant_id` bypasses (prefer DB row-level security).
- A shared cache keyed without the tenant id, leaking data across tenants.
- Background jobs/exports that run without the tenant scope the request path enforces.

**Example / anti-example**
- *Bad:* `GET /report/{id}` joins across tenants because the report query trusts the id alone.
- *Good:* row-level security binds every query to the session's tenant; cross-tenant id → empty.

**Source (gated web)**: https://www.ncsc.gov.uk/collection/cloud/the-cloud-security-principles (P3). STRIDE: Elevation, Information disclosure. x-ref A01.
