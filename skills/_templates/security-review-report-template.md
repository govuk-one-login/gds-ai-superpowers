# Security Review Report (code-level) — [Story title]

| | |
|---|---|
| **Story** | [story id + title] |
| **Diff reviewed** | [base ref]...[HEAD] (story branch vs its base) |
| **Ran?** | **Ran** / **Not Required** — [tier reason: security-sensitive surface? sizing?] |
| **Reviewer** | independent Claude subagent, fresh context, read-only |
| **Author (drafting)** | review-security (skill assists) |
| **Date** | [date] |
| **Status** | DRAFT — review evidence; NOT a merge sign-off or risk acceptance (human owns both) |

> Assisted draft. An independent reviewer read this diff cold through the **security** lens —
> checking (a) the diff realises the controls the TD committed, and (b) it introduces no new
> vulnerability — citing the governing control for each finding. This is the **security,
> code-level** lens: it does **not** do general correctness (`review-code`), re-do the
> TD-level checklist (`check-security-standards`), or walk STRIDE (`threat-model`). The
> reviewer is read-only; any applied fix was made by the **host** with the human's approval.

## Tiering decision

> If **Not Required**, record why and stop — the rest of the report is empty by design.

- **Decision:** Ran / Not Required
- **Reason:** [diff touches auth/data/crypto/… → ran] OR [no security-sensitive surface; sizing None/Minor → Not Required]
- **Owner:** [name] · **Date:** [date]

## Findings by control

> One row per finding. Control: the governing OWASP/MASVS/NCSC id. Kind: **realisation-gap**
> (a TD-committed control not implemented) / **new-vuln** (the diff introduces an issue).
> Severity by **security impact**. Class: **trivial** (confined to touched lines, no new
> design decision) / **substantive** (changes the approach, implies a plan delta).

| # | Control | Location (file:line) | Kind | Sev | Conf | Issue | Proposed fix | Class |
|---|---------|----------------------|------|-----|------|-------|--------------|-------|
| 1 | A05:2025 | [path:line] | new-vuln | critical | high | [string-built SQL] | [parameterise] | trivial |
| 2 | A01:2025 | [path:line] | new-vuln | high | high | [unscoped object fetch / IDOR] | [scope to caller] | substantive |
| 3 | A04:2025 | [path:line] | realisation-gap | high | medium | [TD committed TLS; call is plaintext] | [enforce TLS] | substantive |
| — | none found | | | | | | | |

## Dispositions (gated; the assurance trail)

> Each finding's outcome. Trivial accepts are applied by the **host** then the gate suite is
> re-run to green + the oracle confirmed unchanged. Substantive accepts route
> **generate-implementation-plan → implement-plan** as a plan amendment. A risk-acceptance
> outcome is the human's, recorded with an owner. This table — not the edits — is the record.

| # | Disposition | Action taken | Gate re-run (if applied) | Oracle intact? | Owner | Date |
|---|-------------|--------------|--------------------------|----------------|-------|------|
| 1 | Accepted | applied to branch | green | yes | [name] | [date] |
| 2 | Accepted | routed → generate-implementation-plan → implement-plan | n/a | n/a | [name] | [date] |
| 3 | Deferred | [tracked where; residual risk accepted by owner] | — | — | [name] | [date] |

## Outcome at handoff
- **Ran or Not Required:** [decision + reason].
- **Applied to the branch:** [list of #] — gate suite re-run green, oracle unchanged.
- **Routed back to the dev pipeline:** [list of #] — re-review after the fix lands.
- **Residual risks proposed for human acceptance:** [list] — or None.
- **Not done:** the code-level accessibility check (when built), the QA-phase verification,
  and the **merge** (human); any deferred findings.
