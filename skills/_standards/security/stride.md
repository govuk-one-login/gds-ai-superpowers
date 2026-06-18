# STRIDE — the enumeration method

STRIDE is the spine of this threat model. It is a *method*, not a checklist of
requirements: you walk each component and each data flow and ask the six
questions. The other frameworks (OWASP, MASVS, NCSC) supply the governing
controls and mitigations for whatever STRIDE surfaces.

Each STRIDE category is the inverse of a security property:

| Category | Threatens the property of | Ask, for each component / flow |
|----------|---------------------------|--------------------------------|
| **S — Spoofing** | Authentication | Can an actor pretend to be someone or something they are not? (a user, a client service, a third-party integration, a service identity, a device) |
| **T — Tampering** | Integrity | Can data or code be modified in transit, at rest, or in memory without detection? (protected records, request payloads, stored keys, app binary) |
| **R — Repudiation** | Non-repudiation | Can an actor perform an action and later deny it, because there is no trustworthy record? (transactions, data sharing, consent, admin actions) |
| **I — Information disclosure** | Confidentiality | Can data be exposed to someone not authorised to see it? (PII, protected records, keys, correlation/linkability across interactions) |
| **D — Denial of service** | Availability | Can an actor degrade or deny the service for legitimate users? (flooding, resource exhaustion, lockout, key/token revocation abuse) |
| **E — Elevation of privilege** | Authorisation | Can an actor gain capabilities they should not have? (bypassing access control, escaping the app sandbox, abusing a trust boundary) |

## How to apply it methodically

1. Take one component or data flow at a time. Do not try to reason about the
   whole system at once.
2. For that component, walk all six categories in order. Most components will
   have threats in several categories; some in only one. Record what you find;
   note categories you considered and dismissed only if the reasoning is
   non-obvious.
3. Pay special attention to threats that cross a **trust boundary** — these are
   where the highest-value findings live. A data flow that stays entirely
   within one trust zone is lower priority than one that crosses from device to
   backend, or from your service to a third party.
4. For each threat, go to the routing table in `SKILL.md` and pull the framework
   that governs that surface, so the threat carries a concrete control
   identifier rather than a generic label.

## Bound the model: inherit the platform, don't re-model it

Step 1 says take one component at a time — but first decide which components are
**yours to model**. The delivery and hosting platform (source repo, PR/review
controls, CI/CD pipeline and its supply-chain integrity, deploy config, cloud IAM
baseline) is inherited and assured once at platform level; it sits **outside** the
boundary you draw. Model it only if the change alters it. Otherwise a change that
merely *ships via* a pipeline drags the pipeline into the diagram, and STRIDE starts
enumerating GitHub-hardening threats instead of the change's own. Model the change;
cite the platform baseline for the rest. (SKILL.md "Scope discipline" has the full rule.)
When the change *does* introduce or alter a platform component, `check-platform-constraints`
owns that new surface — it is not threat-modelled from scratch here.

## High-value STRIDE prompts often under-weighted

These are threats a quick STRIDE pass tends to miss. Consider each explicitly for
any system that holds sensitive data, authenticates users, or exchanges data with
third parties:

- **Spoofing:** impersonation of a user, a service, or a third-party integration to
  gain trust or harvest data; cloned-device or stolen-session access.
- **Tampering:** forgery or alteration of protected data; replay of a captured
  request; relay / man-in-the-middle between client and service.
- **Repudiation:** a user later denies an action, or a service denies processing it
  — is there a trustworthy, privacy-respecting record?
- **Information disclosure:** over-collection or over-exposure of data beyond what is
  needed; **linkability** — can separate interactions be correlated to track a user?
  Leakage of sensitive data or keys at rest.
- **Denial of service:** a hard external dependency (e.g. an availability or
  revocation check) makes the flow fail when an endpoint is down; lockout of a user
  from their own data or account.
- **Elevation of privilege:** a binding or authorisation failure lets an attacker act
  as another user; sandbox escape exposing key material.
