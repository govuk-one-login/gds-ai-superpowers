# Verification Report — [Story title]

| | |
|---|---|
| **Story** | [story id + title] |
| **Surface (`kind`)** | [backend / web-frontend / ios / android] |
| **Driver used** | [the project-declared driver for this `kind`] |
| **Running target** | [provided URL / booted sim — or "stood up locally via <command>"] |
| **Branch** | [the dev-pipeline story branch] |
| **Author (drafting)** | verify-story (skill assists) |
| **Date** | [date] |
| **Status** | DRAFT — verification evidence; NOT a release sign-off (human owns the merge) |

> Assisted draft. This proves the **running build** against the story's acceptance
> criteria and records the e2e coverage. It is **not** a release certification and does
> **not** fix product code — confirmed defects route back to the dev pipeline as failing
> tests. SCs of "done" are the story's acceptance criteria.

## Per-criterion results

> One row per acceptance criterion. Result is one of: **verified-automated** (a passing
> e2e test exists), **verified-manual-gap** (driven + evidence, but not automatable —
> flagged), **failed** (running build does not meet it → defect below).

| Criterion (Given/When/Then) | Result | e2e test (path / id) | Evidence (if manual) |
|-----------------------------|--------|----------------------|----------------------|
| [C1 …] | verified-automated | [tests/e2e/…] | — |
| [C2 …] | verified-manual-gap | — | [screenshot/response ref] |
| [C3 …] | failed | [failing test path] | [what was observed] |

## Coverage assessment (v1 rubric)

- **Every criterion covered or flagged:** [yes / list uncovered]
- **Primary happy path covered end to end:** [yes / no — detail]
- **Each named error/edge path covered:** [yes / list missing]
- **Flagged gaps (not automatable):** [criterion → why no automated coverage] — or None.

## Failure classification (before any defect is filed)

> Stage-5 record: a failure is only a product defect if env preconditions were green and
> it reproduced. Environment/flaky failures are fixed-and-retried, not filed.

| Failing criterion | Preconditions green? | Reproduced (≥2)? | Classified | Action |
|-------------------|----------------------|------------------|-----------|--------|
| [C3] | yes | yes | **product defect** | filed below |
| [Cn] | no (sim not booted) | — | environment | fixed + retried |
| [Cn] | yes | once only | ambiguous | escalated to human |

## Defects & dispositions (gated, routed as failing tests)

> Each confirmed defect: the reproduction test, the proposed route back into the dev
> pipeline, and the human's disposition. This table — not the edits — is the assurance
> trail. verify-story never fixes product code.

| Defect | Reproduction test | Proposed route | Disposition | Owner | Date |
|--------|-------------------|----------------|-------------|-------|------|
| [C3 fails: …] | [tests/e2e/… (red)] | add to story oracle (generate-acceptance-tests) → fix via implement-plan | Accepted / Modified / Rejected / Deferred | [name] | [date] |

## Open items at handoff
- **Routed defects awaiting fix:** [list] — re-verify after they land.
- **Flagged coverage gaps:** [list] — or None.
- **Not done:** release sign-off and the **merge** (human); any deferred defects.
