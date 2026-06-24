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
| S1    | iOS \| [description] | C1 — [capability] | R1, R2 | S | |
| S2    | Web \| [description] | C1 — [capability] | R3 | M (split?) | |
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

> Each block is in Jira's field shape — copy field by field and ensure that stories are in plain English. The summary uses the
> format "Skillset | Description", where skillset is one of: iOS, Android, Web, Platform.
> Context and acceptance criteria stay at architecture and observable-behaviour level;
> nothing here prescribes the code inside a component.

### S1 — [Skillset | Short description]

- **Issue type:** Story
- **Epic link:** C1 — [capability name]
- **Summary:** [Skillset] | [Short, specific description — for example, "Valid passport question page" or "Error screen for issues with passport photo"]
- **Context:**
    [One or two sentences of business or technical context explaining why this work is needed and how it fits into the wider service.]

    As a [role], I want to [action] so that [benefit].

    Grounds in (architecture and contract level — not internal code):
    - Component: [reused | extended | new module named in the TD]
    - Contract: [endpoint or message from the TD's API table — omit if not applicable]
- **Requirements:**
    - [Functional or technical requirement]
    - [Error handling — as described in the technical design]
    - [Content change, if applicable]
- **Benefit:** [Why this ticket is being done and what completing it achieves for the user or service.]
- **Acceptance criteria:**
    Scenario: [scenario name]
    - Given [context]
    - When [action]
    - Then [observable outcome]

    Scenario: [edge or error case]
    - Given [context]
    - When [action]
    - Then [observable outcome]

    Include scenarios for relevant non-functional requirements — for example, accessibility, analytics, and monitoring and alerting. Keep each line to a single condition; do not use 'or'.
- **Developer notes:** [Relevant technical notes for developers. Leave blank for developers to fill in during amigos.]
- **Important links:**
    - [Solution or service design - leave blank if not avaialble]
    - [Technical design]
- **Key people:** Leave blank — to be filled in.
- **Labels:** req:R1, req:R2, td:[component-or-API-row]
- **Size / notes:** [Small and testable — mark L and propose a split if it bundles a new module, a new contract and error or timeout handling; note any steps folded in or any reuse from another capability]

### S2 — [Skillset | Short description]
[repeat per story, grouped under its capability]

## Coverage matrix

> Proof that nothing was dropped and nothing was invented. Every requirement maps to
> at least one story; every story traces to a requirement **and** a TD element ("TD element" =
> any named component, infrastructure or mobile module, or API-table row).

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

## Proposed design updates and decisions (write-back to the TD)

> The gstack spine: each gap, contradiction, or orphan found while slicing, walked
> back into the source TD one at a time, with the human's disposition. The skill
> proposes and records; a named owner decides. This table — not a silent edit — is
> the assurance trail for what the decomposition changed in the design and who
> owned it. Story sign-off is recorded separately (it is acceptance of this
> artifact, not a write-back into the TD).

| Finding | Source TD field / section | Proposed change | Disposition | Owner | Date |
|---------|---------------------------|-----------------|-------------|-------|------|
| [for example, R3 uncovered] | [for example, Assumptions and open questions] | [for example, add `[gap]` — no component delivers R3; needs an architecture decision] | Accepted / Modified / Rejected / Deferred | [name] | [date] |
| [for example, S4 ungrounded] | [for example, Architecture] | [for example, confirm or deny the component S4 assumes] | … | [name] | [date] |

## Open items at handoff

- **Deferred findings:** [any write-back deferred, with owner] — or None.
- **Ungrounded stories:** [any marked ungrounded, with reason] — or None.
- **Jira status:** tickets NOT created — human to work the tracking index above.
