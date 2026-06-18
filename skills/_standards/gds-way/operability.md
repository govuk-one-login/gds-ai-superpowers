# GDS Way — Operability & docs (`GDSW-OPS-*`)

The discipline for running and understanding the service: structured logging that leaks no
sensitive data, health/monitoring/alerting, and documentation-as-code. Use this lens when a
TD commits to an operability approach, or a diff touches logging, telemetry, or service
health.

## Controls

### `GDSW-OPS-1` — structured logging; no PII or secrets in logs
- **realises:** `standards/logging.html` (grounded in the NCSC Cyber Assessment Framework's
  Security Monitoring category; it requires filtering PII — e.g. query params — out of logs
  before they ship, using framework log-filtering where available).
- **Checkable:** logs are structured (machine-parseable, correlation IDs) and **carry no PII
  or secrets**. A log line emitting personal data or a token is a finding — and the
  **security/privacy tick** is owned by `check-security-standards` (cross-ref **A09** /
  **MASVS-STORAGE-1**); this control verifies the engineering discipline (logs are
  structured and a no-PII rule is in force), not the security conformance row.

### `GDSW-OPS-2` — health checks, monitoring, and alerting on the running service
- **realises:** `standards/monitoring.html`, `standards/alerting.html` (+ `standards/slis.html`,
  `standards/slo.html` for the signals worth alerting on).
- **Checkable:** the service exposes health checks and is monitored, with alerting on the
  signals that matter (error rate, latency, saturation). At TD-level this is the
  *operability approach the design commits to*; a design silent on monitoring is a finding.

### `GDSW-OPS-3` — documentation as code: README, ADRs, runbook
- **realises:** `manuals/readme-guidance.html`, `standards/architecture-decisions.html`
  (ADRs), `standards/diagrams-as-code.html`.
- **Checkable:** the repo carries a README that explains run/build/test, an **ADR** for each
  significant decision, and a runbook for operating the service. Significant architectural
  choices made with no ADR are a finding.

## Highest-value questions
- Are logs structured and provably free of PII — security row left to `check-security-standards`?
- Does the design commit to monitoring and alerting, or is operability an afterthought?
- Are significant decisions captured as ADRs, or only in people's heads?

Source: gds-way.digital.cabinet-office.gov.uk — Logging, Monitoring, Alerting, SLIs, SLOs,
Architecture decisions, Diagrams as code, README guidance.
