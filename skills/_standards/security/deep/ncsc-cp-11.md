# NCSC Cloud Principle 11 — External interface protection — deep

Pull when external-interface defence is contested or unclear. Pairs with the trust-boundary
analysis in the threat model.

**Check**
- Every external/less-trusted interface is enumerated (public APIs, webhooks, admin panels,
  management planes, file uploads) and each is defended proportionately.
- Management/admin interfaces are not on the public internet, or are gated by strong auth +
  network controls (VPN/bastion/allow-list) — they are high-value targets.
- Edge protections where warranted: WAF, rate limiting, schema validation, request-size limits,
  anti-automation; mutual TLS for service-to-service.
- Attack surface minimised: unused interfaces closed; default endpoints removed.

**Pitfalls**
- An admin/management endpoint reachable from the internet "behind a guessable path".
- A webhook receiver that doesn't verify the sender signature.
- Counting only the "front door" API and forgetting upload, callback, and ops interfaces.

**Example / anti-example**
- *Bad:* `/admin` exposed publicly, protected only by a password form, no rate limit.
- *Good:* admin plane on a private network, SSO + MFA, allow-listed, audited.

**Source (gated web)**: https://www.ncsc.gov.uk/collection/cloud/the-cloud-security-principles (P11). STRIDE: Tampering, Elevation. x-ref A01, A02.
