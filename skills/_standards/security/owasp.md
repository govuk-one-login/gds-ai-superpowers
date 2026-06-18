# OWASP Top 10:2025 — web / API governing lens

Use this lens for backend services, web-facing surfaces, and API endpoints.
When STRIDE surfaces a threat on one of these surfaces, cite the relevant
A-number as the governing control.

This is the **2025** edition (released January 2026), which replaced the 2021
list. Note the changes from 2021, since older threat models and many tools still
reference the old categories: there are two new categories (Software Supply
Chain Failures, and Mishandling of Exceptional Conditions), several re-rankings,
and SSRF is no longer its own category — it now sits within Broken Access
Control and Mishandling of Exceptional Conditions.

## The 2025 categories

- **A01:2025 — Broken Access Control.** Still ranked #1. Failures letting users
  act outside intended permissions: missing authorisation checks, IDOR, path
  traversal, privilege escalation. Now also absorbs Server-Side Request Forgery
  (SSRF). Maps to STRIDE Elevation of privilege and Spoofing.
- **A02:2025 — Security Misconfiguration.** Moved up to #2. Insecure defaults,
  unnecessary features enabled, verbose errors, missing hardening, permissive
  cloud/storage settings. Maps to STRIDE Information disclosure and Elevation.
- **A03:2025 — Software Supply Chain Failures.** New, broader successor to the
  old "Vulnerable and Outdated Components". Covers compromised dependencies,
  build pipelines, and third-party components — the whole chain, not just
  outdated libraries. Maps to STRIDE Tampering.
- **A04:2025 — Cryptographic Failures.** Weak/absent encryption, poor key
  management, weak algorithms, secrets in the clear. Maps to STRIDE Information
  disclosure and Tampering.
- **A05:2025 — Injection.** SQL, NoSQL, OS command, LDAP, XSS — untrusted input
  reaching an interpreter. Dropped in rank but still high-impact. Maps to STRIDE
  Tampering and Elevation.
- **A06:2025 — Insecure Design.** Flaws in architecture or logic rather than
  implementation: weak password-reset flows, missing authorisation steps, lack
  of threat modelling. The presence of *this* category is itself an argument for
  doing threat modelling at design time. Maps broadly across STRIDE.
- **A07:2025 — Authentication Failures.** Weak credential handling, broken
  session management, missing MFA, predictable tokens. Maps to STRIDE Spoofing.
- **A08:2025 — Software or Data Integrity Failures.** Unverified updates,
  insecure deserialisation, unsigned/unvalidated data or code. Maps to STRIDE
  Tampering and Repudiation.
- **A09:2025 — Security Logging and Alerting Failures.** Insufficient logging,
  detection, and alerting; inability to detect or investigate a breach.
  Renamed from "Logging and Monitoring" to emphasise alerting. Maps to STRIDE
  Repudiation.
- **A10:2025 — Mishandling of Exceptional Conditions.** New. Systems that break
  unsafely under unexpected input, resource shortage, timeout, or internal
  failure — failing open, leaking secrets in error messages, NULL-dereference
  crashes. Also now carries part of the former SSRF category. Principle: fail
  closed, return generic errors externally, log details internally. Maps to
  STRIDE Denial of service and Information disclosure.

## Using this lens
- Cite the full identifier in findings, e.g. "Governing control: A01:2025 Broken
  Access Control".
- If a tool or older document references a 2021 category, translate it: e.g. old
  A10:2021 SSRF → A01:2025; old "Vulnerable and Outdated Components" → A03:2025
  Software Supply Chain Failures.
- For deeper per-category guidance the source is at owasp.org/Top10/2025/.

## Deep tier
Each category has an authored deep file (check / pitfalls / example / link). **Pull one only
when you are about to record that control Contested / Deferred / applicability Unclear** — not
for routine checks. See CLAUDE.md "How standards are read".
- A01 — deep: deep/a01.md   · A02 — deep: deep/a02.md   · A03 — deep: deep/a03.md
- A04 — deep: deep/a04.md   · A05 — deep: deep/a05.md   · A06 — deep: deep/a06.md
- A07 — deep: deep/a07.md   · A08 — deep: deep/a08.md   · A09 — deep: deep/a09.md
- A10 — deep: deep/a10.md
