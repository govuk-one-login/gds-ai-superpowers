# Accessibility Review — [Feature / story-set title]

| | |
|---|---|
| **Story set reviewed** | [story-set artifact + date] |
| **Design ref (TD)** | [TD title + version] |
| **Standard** | WCAG 2.2 AA |
| **Author (drafting)** | check-accessibility (skill assists) |
| **Date** | [date] |
| **Status** | DRAFT — pending product-owner sign-off; NOT a conformance certification |

> Assisted draft. This review adds WCAG 2.2 AA acceptance criteria to UI-facing
> stories and flags design-level accessibility blockers. It is **not** a WCAG
> conformance certification, not the legal accessibility statement, and not a
> substitute for an accessibility audit or assistive-technology testing — a
> human/specialist certifies. SCs are cited by id; native affordances are
> non-normative realisation notes anchored to the WCAG SC.

## Scope

**UI-facing stories reviewed:** [S1, S3, …]
**Skipped (not UI-facing):** [S-n — grounds only in backend/infra: reason]
**Low-confidence (no/malformed "Grounds in"):** [S-n — surface inferred from text] — or None.

## Per-story accessibility criteria added

> For each UI-facing story: its platform, the success criteria applied, the criteria
> added (Given/When/Then), and whether the story passes at criteria level or has a gap.

### [S1 — title] · Platform: [iOS | Android | Web]

- **SCs applied:** WCAG 1.3.1, 1.4.3, 2.5.8, 3.3.8 [+ …]
- **Acceptance criteria added:**
    - Given [context], when [action], then [observable, AT-verifiable outcome]. *(WCAG <id>)*
    - Given [context], when [action], then [observable outcome]. *(WCAG <id>)*
- **Result:** Pass at criteria level / Gap → [what; routed to story or TD]

### [S3 — title] · Platform: […]
[repeat per UI-facing story]

## Design-level findings (TD channel)

> Accessibility problems that the **design** causes and a story criterion cannot fix
> (the fix requires changing what the design decided to build). These walk back into
> the TD, gated.

| Finding | Story exposing it | WCAG SC at risk | Why it's design-level (not a story fix) | Proposed TD change |
|---------|-------------------|-----------------|------------------------------------------|--------------------|
| [e.g. cross-device flow is QR-only] | [S7] | [1.1.1 / pointer-input intent] | [no component offers a non-QR path; a blind user cannot scan] | [add an accessible alternative entry (manual code / link); or `[gap]`] |

## Proposed updates & dispositions (both channels)

> The assurance trail: every proposal (story criteria and TD findings) with the
> human's disposition. The skill proposes and records; a named owner decides.

| Channel | Finding / story | Target (story field or TD section) | Proposed change | Disposition | Owner | Date |
|---------|-----------------|------------------------------------|-----------------|-------------|-------|------|
| Story | [S1] | acceptance criteria | [add WCAG 2.5.8 target-size criterion] | Accepted / Modified / Rejected / Deferred | [name] | [date] |
| TD | [QR-only] | Assumptions & open questions | [add `[gap]` — no accessible alternative to QR] | … | [name] | [date] |

## Coverage and open items

- **UI-facing reviewed:** [N of M] — [all reviewed / list deferred].
- **Design findings:** [N raised, N accepted, N deferred].
- **Android (if any):** findings flagged **NOT YET VALIDATED** (no built Android story).
- **Not a certification:** WCAG conformance, the accessibility statement, and AT
  testing remain outstanding human/specialist activities.
