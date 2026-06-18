# Engineering Way — Operability & docs (`ENG-OPS-*`)

The discipline for running and understanding the service: structured logging that leaks no
sensitive data, health/monitoring/alerting, and documentation-as-code. Use this lens when a
TD commits to an operability approach, or a diff touches logging, telemetry, or service
health.

## Controls

### `ENG-OPS-1` — structured logging; no PII or secrets in logs
- **realises:** logging standards (requires filtering PII — e.g. query params — out of logs
  before they ship, using framework log-filtering where available).
- **Checkable:** logs are structured (machine-parseable, correlation IDs) and **carry no PII
  or secrets**. A log line emitting personal data or a token is a finding — and the
  **security/privacy tick** is owned by `check-security-standards` (cross-ref **A09** /
  **MASVS-STORAGE-1**); this control verifies the engineering discipline (logs are
  structured and a no-PII rule is in force), not the security conformance row.

### `ENG-OPS-2` — health checks, monitoring, and alerting on the running service
- **realises:** monitoring, alerting, SLI, and SLO standards.
- **Checkable:** the service exposes health checks and is monitored, with alerting on the
  signals that matter (error rate, latency, saturation). At TD-level this is the
  *operability approach the design commits to*; a design silent on monitoring is a finding.

### `ENG-OPS-3` — documentation as code: README, ADRs, runbook
- **realises:** README guidance, architecture-decisions (ADRs), and diagrams-as-code standards.
- **Checkable:** the repo carries a README that explains run/build/test, an **ADR** for each
  significant decision, and a runbook for operating the service. Significant architectural
  choices made with no ADR are a finding.

## Highest-value questions
- Are logs structured and provably free of PII — security row left to `check-security-standards`?
- Does the design commit to monitoring and alerting, or is operability an afterthought?
- Are significant decisions captured as ADRs, or only in people's heads?
