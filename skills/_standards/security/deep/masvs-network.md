# MASVS-NETWORK — secure mobile network comms — deep

Pull when mobile transit-security applicability is contested or unclear.

**Check**
- TLS enforced and validated for all traffic; no cleartext (Android `cleartextTrafficPermitted
  = false`; iOS ATS not weakened).
- Certificate/public-key **pinning** for high-value backends where the threat model warrants it,
  with a rotation/backup-pin plan.
- No trust-all/custom `TrustManager` or disabled hostname verification (a classic MITM hole).

**Pitfalls**
- A debug build's "trust all certs" shim shipping to production.
- Pinning a single leaf cert with no backup pin → outage on rotation.
- An ATS exception (`NSAllowsArbitraryLoads`) left enabled.

**Example / anti-example**
- *Bad:* `X509TrustManager` that accepts any chain to make staging work.
- *Good:* default validation + pinned backend keys with a backup pin and rotation runbook.

**Source (gated web)**: https://mas.owasp.org/MASVS/ (NETWORK). STRIDE: Information disclosure, Tampering. x-ref A04, NCSC P1.
