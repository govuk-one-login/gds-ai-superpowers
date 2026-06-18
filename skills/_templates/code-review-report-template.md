# Code Review Report — [Story title]

| | |
|---|---|
| **Story** | [story id + title] |
| **Diff reviewed** | [base ref]...[HEAD] (story branch vs its base) |
| **Effort level** | low / **med** (default) / high — [auto-escalated? why] |
| **Reviewer** | independent Claude subagent, fresh context, read-only |
| **Author (drafting)** | review-code (skill assists) |
| **Date** | [date] |
| **Status** | DRAFT — review evidence; NOT a merge sign-off (human owns the merge) |

> Assisted draft. An independent reviewer read this diff cold (diff + acceptance criteria
> + approved plan) and judged it on its merits. This is the **general correctness/quality**
> lens — it does **not** re-do the security or accessibility checks (sibling slots), does
> **not** merge, and does **not** accept risk. The reviewer is read-only; any applied fix
> was made by the **host** and only with the human's approval.

## Findings by dimension

> One row per finding. Severity: critical / high / medium / low. Confidence: high / medium
> / low. Class: **trivial** (confined to lines the diff touches, no new design decision) /
> **substantive** (changes the approach, implies a plan delta).

| # | Dimension | Location (file:line) | Sev | Conf | Issue | Proposed fix | Class |
|---|-----------|----------------------|-----|------|-------|--------------|-------|
| 1 | correctness | [path:line] | high | high | [what's wrong] | [the fix] | trivial |
| 2 | edge-case | [path:line] | medium | medium | [missed path] | [the fix] | substantive |
| 3 | test-quality | [path:line] | high | high | [anti-pattern: asserts-the-mock] | [assert real behaviour] | substantive |
| 4 | reuse | [path:line] | low | medium | [duplicated logic] | [use existing util] | trivial |
| 5 | idiom | [path:line] | low | high | [non-idiomatic] | [house pattern] | trivial |

### Test anti-pattern flags (the specific mandate)

> Each implementer-authored unit test checked against the checklist. Flag the type:
> **assertion-free** / **asserts-the-mock** / **asserts-a-constant** / **re-derives-the-expected**.

| Test (path / name) | Flag | Why it's vacuous | Proposed real assertion |
|--------------------|------|------------------|-------------------------|
| [tests/… ::name] | asserts-the-mock | [asserts a value the test configured] | [assert the code's actual output] |
| — none found — | | | |

## Dispositions (gated; the assurance trail)

> Each finding's outcome. Trivial accepts are applied by the **host** then the gate suite
> is re-run to green + the oracle confirmed unchanged. Substantive accepts route
> **generate-implementation-plan → implement-plan** as a plan amendment. This table — not
> the edits — is the record.

| # | Disposition | Action taken | Gate re-run (if applied) | Oracle intact? | Owner | Date |
|---|-------------|--------------|--------------------------|----------------|-------|------|
| 1 | Accepted | applied to branch | green | yes | [name] | [date] |
| 2 | Accepted | routed → generate-implementation-plan → implement-plan (plan amendment) | n/a | n/a | [name] | [date] |
| 3 | Modified | [the modified fix] | green | yes | [name] | [date] |
| 4 | Rejected | [reason] | — | — | [name] | [date] |
| 5 | Deferred | [tracked where] | — | — | [name] | [date] |

## Outcome at handoff
- **Applied to the branch:** [list of #] — gate suite re-run green, oracle unchanged.
- **Routed back to the dev pipeline:** [list of #] — re-review after the fix lands.
- **Effort used:** [low/med/high] [+ auto-escalation reason, if any].
- **Not done:** the sibling code-level checks (security / accessibility on the diff), the
  QA-phase verification, and the **merge** (human); any deferred findings.
