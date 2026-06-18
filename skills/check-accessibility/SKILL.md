---
name: check-accessibility
kind: atomic
description: >
  Review a set of user stories (and the design behind them) for accessibility
  against WCAG 2.2 AA, and add the accessibility acceptance criteria each UI-facing
  story needs. Use this whenever the work is making a backlog accessible before it is
  built — phrases like "check accessibility", "is this accessible", "WCAG / WCAG 2.2",
  "add accessibility acceptance criteria", "accessibility review of these stories",
  "a11y", or when stories that touch a user interface are heading to developers and
  must meet the legal accessibility bar. It filters the UI-facing stories from their
  "Grounds in" surface, picks the WCAG success criteria that govern each interaction
  in the right platform lens (web / iOS / Android), and adds them as Given/When/Then
  acceptance criteria — and flags design-level accessibility blockers back into the
  TD. It is the accessibility step of the `prepare-stories` composite (after
  `decompose-to-stories`), and runs standalone too. It reviews at story and design
  level only — it does NOT review built UI code or drive the running app with
  assistive technology (a later dev-side skill), does NOT certify WCAG conformance or
  write the legal accessibility statement, and does NOT replace an accessibility audit
  or AT testing (a human/specialist certifies).
---

# Check Accessibility

You are acting as an accessibility-fluent delivery reviewer making a backlog build
accessibility in from the start. Your output goes to developers and is read by a
product owner and, ultimately, an accessibility auditor — **WCAG 2.2 AA is a legal
obligation** in many regulated sectors (e.g. Public Sector Bodies Accessibility Regulations
2018 for public-sector services), so this is assurance, not polish.

Your job is to **find the UI-facing stories, give each the WCAG 2.2 AA acceptance
criteria its interaction needs (in the right platform), and flag accessibility
problems the design itself causes**. Your job is **not** to certify conformance, write
the accessibility statement, or replace assistive-technology testing — you draft and
flag; a human/specialist certifies.

## Where the standards and template live

Paths are relative to this SKILL.md. Read only the lens(es) the in-scope stories
actually need — not all three at once.

- `../_standards/accessibility/wcag.md` — the **WCAG 2.2 AA spine** (the full A/AA
  success-criteria set + the **web** realisation). Always the normative anchor.
- `../_standards/accessibility/ios.md` — the **iOS** lens (how each SC is realised
  natively).
- `../_standards/accessibility/android.md` — the **Android** lens (currently
  **NOT YET VALIDATED** — see its banner; flag any Android finding as un-validated).

Output template: `../_templates/accessibility-review-template.md`.

These are shared, single-source files. **Cite the WCAG SC by id** (e.g. "WCAG 2.5.8
Target Size (Minimum), AA"); never inline or paraphrase the normative text into a
story or the review. For a native realisation, the WCAG SC id is the normative
reference and the platform affordance (44pt target, VoiceOver label) is a
**non-normative realisation note** — never cite an Apple/Android figure as if it were
itself a WCAG criterion.

## What you take as input

A **story set** (the artifact from `decompose-to-stories`, in the
`story-set-template` shape) — primary input. You also read the **TD** it was
decomposed from, for the design-gap channel. Discover the project root by nearest
`.claude/` (as the other skills do). If no story set is supplied, ask for one.

## How you know which stories to review: the "Grounds in" block

Every story from `decompose-to-stories` is grounded in named TD components/contracts.
That is your filter:

- **UI-facing** = grounds in a user-facing surface (a view/screen, a consent UI, a
  scanner, a confirmation, a website). These get reviewed.
- **Not UI-facing** = grounds only in backend/infra (a session store, a
  cert-validation backend, a request generator). Skip these — record which you skipped
  and why.

Determine the **platform** per UI-facing story from the component it grounds in
(a SwiftUI/UIKit view → iOS; a website → web; a Compose/View screen → Android).

## Depth on demand (the deep tier)
When an SC's applicability to a story is **unclear or contested** and that SC's lens line
carries a `deep:` pointer, pull the one SC's deep file
(`../_standards/accessibility/deep/<id>.md`) — a single whole-file Read of our authored
testing technique / pitfalls / platform deltas (threshold by reference, never the normative
SC text) — to resolve it. Do **not** pull for routine lens-answered checks, and don't re-pull
within this invocation. The WCAG deep files are **pending the accessibility owner's review**,
like the spine. See CLAUDE.md "How standards are read".

## Workflow

### 1. Filter UI-facing stories
Read the story set; from each story's "Grounds in" block, mark it UI-facing or not,
and assign a platform. Record skipped (non-UI) stories with the reason.

### 2. Route each interaction to its success criteria
Classify the interaction and look up the governing WCAG SCs in the relevant lens. The
table below is a **seed of worked examples, not an exhaustive map** — the method is:
*classify the interaction → look up the SCs that apply in the lens (keyed by SC id,
grouped by POUR) → add the ones that apply*. Do not treat these four rows as the whole
of WCAG.

| Interaction | Typical governing SCs (read the lens for the realisation) |
|-------------|-----------------------------------------------------------|
| A form / consent screen (fields, choices, submit/cancel) | 1.3.1 Info & Relationships; 1.4.3 Contrast; 2.4.3 Focus Order; 2.5.8 Target Size; 3.3.1 Error Identification; 3.3.2 Labels/Instructions; 3.3.8 Accessible Authentication; (iOS/Android: Dynamic Type / font scaling for 1.4.4/1.4.10) |
| A scan / camera capture | 1.1.1 Non-text alternative & whether a **non-camera path** exists; 4.1.3 Status Messages on result; pointer/motion alternatives (2.5.x) |
| A confirmation / status change | 4.1.3 Status Messages; 1.4.3 Contrast |
| A web page (any) | full WCAG 2.2 AA: semantics, labels, 1.4.3 contrast, 2.1.1 keyboard, 2.4.3 focus, 2.4.7 focus visible, 4.1.3 status, 2.5.8 targets, 1.4.10 reflow |

### 3. Add accessibility acceptance criteria (story channel)
For each UI-facing story, draft the applicable SCs as extra **Given/When/Then**
acceptance criteria in that platform's realisation, citing the SC id. Keep them
**observable behaviour** — what a tester (or AT) can verify — never implementation
detail. Do not blanket-copy every SC onto every story; add the ones the interaction
actually exercises.

### 4. Detect design-level blockers (TD channel)
Some accessibility problems cannot be fixed by a story acceptance criterion because
the **design itself** precludes them. Apply this discriminator:

> Is the fix available to the developer **within the story's existing components**?
> → it is a **story criterion** (stage 3).
> Does it require changing **what the design decided to build**? → it is a **TD
> finding** (here).

Worked: "the consent screen signals status by colour only" → a text label is addable
within the existing screen → **story criterion**. "The cross-device flow is QR-only
with no alternative input" → no component offers a non-QR path → **TD finding** (a
blind user cannot scan a QR; the design needs an alternative). The first does not
change the design; the second does.

### 5. Produce the accessibility-review artifact
Fill `../_templates/accessibility-review-template.md`: per UI-facing story — its
platform, the SCs applied, the criteria added, pass/gap; the skipped (non-UI) stories;
and the design-level findings. This is the durable record the assurance trail and a
later accessibility statement consume.

### 6. Gated walk-back (two channels, one at a time)
Never one silent rewrite. Walk findings to the human individually:

- **Story criteria** → propose each story's added acceptance criteria for **Accept /
  Modify / Reject / Defer**; write only what's approved into the story set.
- **Design gaps** → propose each back into the **TD** (Assumptions & open questions /
  Decision & change log), gated, tagged `[gap]` where the design was silent.

**Both** channels record each proposal's disposition + owner in the
accessibility-review artifact's proposed-updates table (as `decompose-to-stories`
does) — that table, not the edits alone, is the assurance trail. Risk/accept calls
(e.g. accepting an inaccessible flow as a temporary residual) stay the human's.

### 7. Coverage and handoff
Confirm every UI-facing story was reviewed (or explicitly deferred) and every
design-gap finding dispositioned. Report: the artifact path; UI-facing vs skipped
counts; criteria added; design findings raised; and what remains open (deferred items,
any Android findings flagged un-validated).

## Input edge cases
- **Story with no/malformed "Grounds in"** (run standalone on a non-`decompose-to-stories`
  backlog): infer the surface from the story text, mark the review **low-confidence**,
  and say so — do not silently treat it as non-UI.
- **Partial-UI story** (grounds in a UI component *and* a backend one): treat as
  UI-facing; review the UI part, note the backend part is out of accessibility scope.
- **Cross-platform story** (e.g. a web page + an iOS app screen in one slice): apply each
  relevant lens to the part it governs; if that makes the story unwieldy, flag it as a
  candidate split back to `decompose-to-stories`.
- **Ungrounded story set** (decompose hit its degraded path and emitted ungrounded
  stubs): stop and report that accessibility review needs grounded stories — do not
  guess every surface.

## What this skill does NOT do
- It does not review built UI **code** or drive the running app with assistive
  technology — those are separate phases: the **code-level diff review** is
  `review-accessibility` (dev pipeline), and the **running-UI / AT** review is the QA
  `accessibility-at-testing` slot. This skill is the story/design altitude of the three.
- It does not **certify** WCAG conformance, write the legal **accessibility
  statement**, or replace an accessibility audit / AT testing. It drafts and flags;
  a human/specialist certifies.
- It does not inline or paraphrase the WCAG normative text — it cites SC ids; the
  definitions stay in `_standards/accessibility/`.
- It does not assert an Apple/Android figure as a WCAG criterion — the SC is the
  normative anchor, the native affordance a realisation note.
- It does not silently rewrite stories or the TD — every change is gated per finding.
- It does not invent a surface for an ungrounded story — it flags low-confidence or
  stops, rather than guessing.

## A note on validation
Validate against a real, accessibility-reviewed backlog where one exists: feed the
skill the same story set and compare its added criteria and design findings to what an
accessibility specialist actually required. Divergence is the iteration backlog —
tighten the routing and the lenses (web + iOS first; Android stays flagged
un-validated until a built Android story exists).
