# Story Set — [Feature / TD title]

| | |
|---|---|
| **Decomposed from (TD)** | [TD title + version/ref] |
| **Requirements source** | [brief / PRD ref, or "TD Goals/Context (no brief)"] |
| **Author (drafting)** | [name — skill assists] |
| **Date** | [date] |
| **Status** | DRAFT — pending product-owner sign-off |

> Assisted draft. These stories were decomposed from a Technical Design and its
> source requirements. They specify user value, acceptance criteria, and the design
> elements each story grounds in — and **stop above function/line code** (the
> developer's job). This artifact is **not** a sign-off: a named product owner
> accepts the backlog. It is **Jira-ready for manual transcription** — no tickets
> have been created in Jira; a human works the tracking index below. Capability =
> Epic, story = Story.

## Ticket-tracking index

> Work down this list as you create tickets in Jira; fill the **Jira key** column
> as each is created. Create the Epics first, then the Stories under them.

| Story | Title | Epic (capability) | Requirement(s) | Size | Jira key |
|-------|-------|-------------------|----------------|------|----------|
| S1    | [title] | C1 — [capability] | R1, R2 | S | |
| S2    | [title] | C1 — [capability] | R3 | M (split?) | |
| …     |  |  |  |  | |

## Capability map (Epics)

> The user-value grouping the stories were sliced from — the transposition of the
> TD's component axis into user value, confirmed with the human before slicing.

### C1 — [capability name]

- **Issue type:** Epic
- **Summary:** [capability name]
- **Spans requirement(s):** R1, R2
- **Spans TD element(s):** [components / API rows this capability covers]
- **Intent:** [one line — the user-meaningful outcome this epic delivers]

### C2 — [capability name]
[repeat per capability]

## Stories

> Each block is in Jira's field shape — copy field by field. "Grounds in" and the
> acceptance criteria stay at architecture/contract and observable-behaviour level;
> nothing here prescribes the code inside a component.

### S1 — [short title]

- **Issue type:** Story
- **Epic Link:** C1 — [capability name]
- **Summary:** [short title]
- **Description:**
    As a [role], I want [capability], so that [benefit].

    Grounds in (architecture/contract level — never internal code):
    - Component: [reused | extended | new module named in the TD]
    - Contract: [endpoint/message from the TD's API table — omit if API is N/A]
- **Acceptance criteria:**
    - Given [context], when [action], then [observable outcome].
    - Given [edge/error context], when [action], then [observable outcome].
- **Labels:** req:R1, req:R2, td:[component-or-API-row]
- **Size / notes:** [Small + Testable check; mark **L and propose a split** if it bundles a new module + a new contract + error/timeout handling; note any steps folded in or any reuse from another capability]

### S2 — [short title]
[repeat per story, grouped under its capability]

## Coverage matrix

> Proof that nothing was dropped and nothing was invented. Every requirement maps to
> ≥1 story; every story traces to a requirement **and** a TD element ("TD element" =
> any named component, infra/mobile module, or API-table row).

**Requirement → stories** (show reuse explicitly: "S3 (C1), reused in C2")

| Requirement | Covered by | Status |
|-------------|------------|--------|
| R1 | S1, S3 | Covered |
| R2 | S1 | Covered |
| R3 | S2 (C1), reused in C2 | Covered (reused) |
| R4 | — | **ORPHAN — no story; raised as finding below** |

**Story → requirement + TD element**

| Story | Requirement(s) | TD element(s) | Status |
|-------|----------------|---------------|--------|
| S1 | R1, R2 | [component / API row] | Traced |
| S4 | — | — | **ORPHAN — traces to nothing; raised as finding below** |

## Proposed design updates & decisions (write-back to the TD)

> The gstack spine: each gap, contradiction, or orphan found while slicing, walked
> back into the source TD one at a time, with the human's disposition. The skill
> proposes and records; a named owner decides. This table — not a silent edit — is
> the assurance trail for what the decomposition changed in the design and who
> owned it. Story sign-off is recorded separately (it is acceptance of this
> artifact, not a write-back into the TD).

| Finding | Source TD field / section | Proposed change | Disposition | Owner | Date |
|---------|---------------------------|-----------------|-------------|-------|------|
| [e.g. R3 uncovered] | [e.g. Assumptions & open questions] | [e.g. add `[gap]` — no component delivers R3; needs an architecture decision] | Accepted / Modified / Rejected / Deferred | [name] | [date] |
| [e.g. S4 ungrounded] | [e.g. Architecture] | [e.g. confirm/deny the component S4 assumes] | … | [name] | [date] |

## Open items at handoff

- **Deferred findings:** [any write-back deferred, with owner] — or None.
- **Ungrounded stories:** [any marked ungrounded, with reason] — or None.
- **Jira status:** tickets NOT created — human to work the tracking index above.
