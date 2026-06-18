# Accessibility Code Review Report (code-level) — [Story title]

| | |
|---|---|
| **Story** | [story id + title] |
| **Diff reviewed** | [base ref]...[HEAD] (story branch vs its base) |
| **Ran?** | **Ran** / **Not Required** — [tier reason: UI-facing surface? backend-only?] |
| **Platform(s)** | web / iOS / Android |
| **Reviewer** | independent Claude subagent, fresh context, read-only |
| **Author (drafting)** | review-accessibility (skill assists) |
| **Date** | [date] |
| **Status** | DRAFT — code-level review evidence; NOT WCAG conformance certification, NOT a merge sign-off (human / specialist) |

> Assisted draft. An independent reviewer read this diff cold through the **accessibility**
> lens — checking (a) the diff realises the a11y acceptance criteria `check-accessibility`
> added, and (b) the **statically-detectable** WCAG 2.2 AA failures — citing the WCAG SC for
> each finding. This is the **accessibility, code-level** lens: it does **not** do general
> correctness (`review-code`) or security (`review-security`), re-do the story/design review
> (`check-accessibility`), or drive the running app with AT. **Runtime-only SCs are deferred
> to the QA `accessibility-at-testing` slot** (see below) — a green code-level pass is NOT
> "accessibility done". The reviewer is read-only; any applied fix was made by the **host**
> with the human's approval.

## Tiering decision

- **Decision:** Ran / Not Required
- **Reason:** [diff touches a UI surface → ran] OR [backend/infra only, no UI surface → Not Required]
- **Owner:** [name] · **Date:** [date]

## Findings by WCAG SC

> One row per finding. SC: the WCAG 2.2 success criterion. Kind: **realisation-gap** (an a11y
> acceptance criterion not implemented) / **code-wcag-failure** (a code-detectable WCAG
> failure). Severity by user impact. Class: **trivial** (confined to touched lines) /
> **substantive** (implies a plan delta).

| # | SC | Platform | Location (file:line) | Kind | Sev | Conf | Issue | Proposed fix | Class |
|---|----|----------|----------------------|------|-----|------|-------|--------------|-------|
| 1 | 1.1.1 | web | [path:line] | code-wcag-failure | high | high | [icon button, no accessible name] | [add aria-label] | trivial |
| 2 | 4.1.2 | web | [path:line] | code-wcag-failure | high | high | [`<div onclick>` toggle, no role/state] | [native button + aria-checked] | substantive |
| 3 | 2.5.8 | ios | [path:line] | code-wcag-failure | medium | high | [tap target 32pt < 44pt] | [enlarge hit area] | trivial |
| — | none found | | | | | | | | |

## Deferred to AT testing (QA `accessibility-at-testing`)

> The runtime residue this static review **cannot** confirm — to be verified on the running
> UI with assistive technology. Listed so nothing is silently assumed-fine.

| SC | Platform | What needs the running UI / AT |
|----|----------|-------------------------------|
| 1.4.3 | web | rendered contrast vs the real background/state |
| 2.1.1 | web | full keyboard / AT operability; no focus traps |
| 4.1.2 | web | the custom control actually **announces + updates** to a screen reader |
| 2.4.11 | web | focus not obscured by sticky headers at runtime |

## Dispositions (gated; the assurance trail)

| # | Disposition | Action taken | Gate re-run (if applied) | Oracle intact? | Owner | Date |
|---|-------------|--------------|--------------------------|----------------|-------|------|
| 1 | Accepted | applied to branch | green | yes | [name] | [date] |
| 2 | Accepted | routed → generate-implementation-plan → implement-plan | n/a | n/a | [name] | [date] |
| 3 | Deferred | [tracked where] | — | — | [name] | [date] |

## Outcome at handoff
- **Ran or Not Required:** [decision + reason].
- **Applied to the branch:** [list of #] — gate suite re-run green, oracle unchanged.
- **Routed back to the dev pipeline:** [list of #] — re-review after the fix lands.
- **Deferred to AT testing (QA):** [list of SCs] — verified later in `accessibility-at-testing`.
- **Not done:** running-UI / AT verification, WCAG conformance certification (specialist), the
  QA-phase verification, and the **merge** (human); any deferred findings.
